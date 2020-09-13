#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct
{
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int cpuid()
{
  return mycpu() - cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void)
{
  int apicid, i;

  if (readeflags() & FL_IF)
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i)
  {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void)
{
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

int allocpid(void)
{
  int pid;
  // acquire(&ptable.lock);
  // pid = nextpid++;
  // release(&ptable.lock);
  do
  {
    pid = nextpid;

  } while (!cas(&nextpid, pid, pid + 1));
  return pid;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void)
{
  struct proc *p;
  char *sp;
  //acquire(&ptable.lock);
  //for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  //  if(p->state == UNUSED)
  //    goto found;
  //release(&ptable.lock);

  pushcli();
  do
  {
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
      if (p->state == UNUSED)
        break;
    if (p == &ptable.proc[NPROC])
    { // if true, it means that the ptable is full and there is nothing we can do
      popcli();
      return 0;
    }
  } while (!cas(&p->state, UNUSED, EMBRYO)); //changing the state,but in an atomic way
  popcli();

  //return 0;

  //found:
  //p->state = EMBRYO;
  //release(&ptable.lock);

  p->pid = allocpid();
  //int i;
  //for (i = 0; i < 32; i++)
  //{
    //p->signal_handlers[i]->sa_handler = (void *)SIG_DFL;
    //p->signal_handlers[i]->sigmask = 0;
  //}

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
  {
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe *)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;

  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  for(int k = 0; k<32; k++){// allocating space for the new fields and initializing them
    sp -= (sizeof (struct sigaction *));
    p->signal_handlers[31-k] = (struct sigaction *)sp;
  }
  for(int k = 0; k<32; k++){
    p->signal_handlers[k]->sa_handler = (void *) SIG_DFL;
    p->signal_handlers[k]->sigmask = 0;
  }
  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();

  initproc = p;
  if ((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0; // beginning of initcode.S
  
  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");
  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.

  /////////Assignment2//////////////////
  pushcli();
  p->stopped = 0;
  p->killed = 0;
  p->pending_signals = 0;
  p->signal_mask = 0;
  p->userspace_trapframe_backup = 0;
  for (int i = 0; i < 32; i++)
  {
    p->signal_handlers[i]->sa_handler = (void *)SIG_DFL;
    p->signal_handlers[i]->sigmask = 0;
  }

  p->state = RUNNABLE; //now, the proccess is ready
  popcli();
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if (n > 0)
  {
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  else if (n < 0)
  {
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if ((np = allocproc()) == 0)
  {
    return -1;
  }

  // Copy process state from proc.
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
  {
    pushcli();
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    popcli();
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for (i = 0; i < NOFILE; i++)
    if (curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;
  int j;
  for (j = 0; j < 32; j++)
  {
    np->signal_handlers[j] = curproc->signal_handlers[j];
  }
  np->signal_mask = curproc->signal_mask;
  np->pending_signals = 0;

  //acquire(&ptable.lock);
  pushcli();
  cas(&np->state, EMBRYO, RUNNABLE);
  popcli();
  //np->state = RUNNABLE;

  //release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if (curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++)
  {
    if (curproc->ofile[fd])
    {
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  //acquire(&ptable.lock);
  pushcli();
  if(!cas(&curproc->state, RUNNING, NEG_ZOMBIE)){
    panic("in exit: cas has failed");
  }

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->parent == curproc)
    {
      p->parent = initproc;
      if(p->state == ZOMBIE || p->state == NEG_ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.

int wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  //acquire(&ptable.lock);
  pushcli();
  for (;;)
  {
    if(!cas(&curproc->state, RUNNING, NEG_SLEEPING)){
      panic("at wait: cas has faiiled");
    }
    
    
    // Scan through table looking for exited children.
    havekids = 0;
    curproc->chan = curproc;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (p->parent != curproc)
        continue;
      havekids = 1;
      while(p->state == NEG_ZOMBIE){}// busy wait
      
      if (cas(&p->state, ZOMBIE, NEG_UNUSED))// change it to the 'middle-state' until we finish preparing
      {
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        
        curproc->chan=0;
        cas(&curproc->state, NEG_SLEEPING, RUNNING);//we need to change it, only once
        cas(&(p->state),  NEG_UNUSED, UNUSED);

        //release(&ptable.lock);
        popcli();
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || curproc->killed)
    {
      //release(&ptable.lock);
      curproc->chan=0;
      if(!cas(&curproc->state, NEG_SLEEPING, RUNNING)){
        panic("at wait: couldn't switch from -SLEEPING to RUNNING");
      }
      popcli();
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    //sleep(curproc, &ptable.lock); //DOC: wait-sleep
    sched();
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;

  for (;;)
  {
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    //acquire(&ptable.lock);
    pushcli();
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if (!cas(&(p->state), RUNNABLE, NEG_RUNNING)) //if we couldnt change it's state
        continue;
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      cas(&(p->state), NEG_RUNNING, RUNNING);
      switchuvm(p);
      swtch(&(c->scheduler), p->context);
      switchkvm();
      cas(&(p->state), NEG_RUNNABLE, RUNNABLE);
      // Process is done running for now.
      // It should have changed its p->state before coming back.

      //here we are going to use all the negative states, in order to make sure that everything (the memory, etc..) is ready for the next one (because wwe are not locking the ptable now)
      if (cas(&(p->state), NEG_SLEEPING, SLEEPING))
        if (p->killed == 1)
          cas(&(p->state), SLEEPING, RUNNABLE);

      cas(&(p->state), NEG_RUNNABLE, RUNNABLE);

      if (cas(&(p->state), NEG_ZOMBIE, ZOMBIE))
        wakeup1(p->parent);
      
      c->proc = 0;
    }
    //release(&ptable.lock);
    popcli();
  }
  cprintf("sched4");
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
  int intena;
  struct proc *p = myproc();

  //if (!holding(&ptable.lock))
    //panic("sched ptable.lock");
  if (mycpu()->ncli != 1)
    panic("sched locks");
  if (p->state == RUNNING)
    panic("sched running");
  if (readeflags() & FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void yield(void)
{
  struct proc *curproc = myproc();
  //acquire(ptable.lock);
  pushcli();
  if (!cas(&curproc->state, RUNNING, NEG_RUNNABLE))
    panic("In yield: the cas has failed");
  sched();
  //release(&ptable.lock);
  popcli();
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  //release(&ptable.lock);
  popcli();

  if (first)
  {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if (p == 0)
    panic("sleep");

  if (lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  //if (lk != &ptable.lock)
  //{                        //DOC: sleeplock0
    //acquire(&ptable.lock); //DOC: sleeplock1
  
  //}
  pushcli();
  
  // Go to sleep.
  
  //p->state = SLEEPING;
  if(!cas(&p->state, RUNNING, NEG_SLEEPING))
    panic("in sleep: cas failed");
  release(lk);
  p->chan = chan;
  sched();
  
  // Tidy up.
  p->chan=0;
  //p->chan = 0;

  // Reacquire original lock.
  //if (lk != &ptable.lock)
  //{ //DOC: sleeplock2
    //release(&ptable.lock);
  //}
  popcli();
  acquire(lk);
}
         
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;
  pushcli();
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    while(p->state == NEG_SLEEPING){}//waiting for this state to change
    if (p->state == SLEEPING && p->chan == chan){
        if(cas(&p->state, SLEEPING, NEG_RUNNABLE)){
          p->chan=0;
          if(!cas(&p->state, NEG_RUNNABLE, RUNNABLE))
            panic("at waikup1: second cas has failed");
        }
    }
  }
  popcli();
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
  //acquire(&ptable.lock);
  pushcli();
  wakeup1(chan);
  //release(&ptable.lock);
  popcli();
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid, int signum)
{
  struct proc *p;

  pushcli(); // preventing interruptions

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {

    if (p->pid == pid)
    {
      switch (signum)
      { //checking the special signals options
      case SIGKILL:
        p->killed = 1;
        cas(&p->state, SLEEPING, RUNNABLE);
        popcli();
        return 0;

      case SIGSTOP:
        p->stopped = 1;
        //cas(&p->state, SLEEPING, RUNNABLE);
        popcli();
        return 0;

      case SIGCONT:
        if (p->stopped == 1)
        {
          p->pending_signals = p->pending_signals | (1 << (32 - signum));
          popcli();
          return 0;
        }
        popcli();  //the 'else' case
        return -1; // continue was sent but the proccess is not pn stopped

      default:
        p->pending_signals = p->pending_signals | (1 << (32 - signum));
        popcli();
        return 0;
      }

      //p->pending_signals = p->pending_signals | 1 << (32 - signum);
      // Wake process from sleep if necessary.
      //if (p->state == SLEEPING && (signum == SIGKILL || signum == SIGSTOP))
        //p->state = RUNNABLE;
      //release(&ptable.lock);
      //return 0;
    }
  }
  //release(&ptable.lock);
  popcli();
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
  static char *states[] = {
      [UNUSED] "unused",
      [EMBRYO] "embryo",
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if (p->state == SLEEPING)
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
  struct proc *p = myproc();
  if (oldact != null)
  {
    oldact->sa_handler = p->signal_handlers[signum - 1]->sa_handler;
    oldact->sigmask = p->signal_handlers[signum - 1]->sigmask;
  }
  if (act->sigmask <= 0)
    return -1;

  p->signal_handlers[signum - 1]->sa_handler = act->sa_handler;
  p->signal_handlers[signum - 1]->sigmask = act->sigmask;
  return 0;
}

void checkS(struct trapframe *trap_frame)
{
  struct proc *curproc = myproc();
  
  if(curproc == 0){
    //cprintf("first if\n");
    return;
  }

  if(curproc->pending_signals == 0)
    return;

  if(((trap_frame->cs & 3) != DPL_USER)){
    cprintf(" if\n");
    return;
  }
  if (curproc->stopped)
  {
    for (;;)
    {
      if(curproc->killed)
        exit();
      uint cont = (1 << (32 - SIGCONT));
      int is_pending = curproc->pending_signals & cont; //check if continue's bit is on or not

      if (is_pending)
      {
        pushcli(); //for interrupts
        if (cas(&curproc->stopped, 1, 0))
        {                                                                              // it has to be with cas in the if, they have to be updated together
          curproc->pending_signals = curproc->pending_signals ^ (1 << (32 - SIGCONT)); // to turn off the continue bit
        }
        popcli();
        break;
      }
      else
      {
        yield(); // didn't get cont yet, give back the cpu time
      }
    }
  }


  if (curproc->stopped)
  { // should I remove it? is it actually neccessary?
    return;
  }

  for (int i = 1; i <= 32; i++)
  {
    int pending = (curproc->pending_signals & (1 << (32 - i)));

    if (!pending || ((curproc->signal_mask) & (1 << (32 - i)))) //this proccess is not pending or should be ignored (the second option is to check if the bit in the mask is on or not)
      continue;

    curproc->pending_signals = curproc->pending_signals ^ (1 << (32 - i));

    if (curproc->signal_handlers[i - 1]->sa_handler == (void *)SIG_IGN)
    {                                                                              //pretty straight forward
      curproc->pending_signals = curproc->pending_signals ^ (1 << (32 - i)); //discard the bit
      continue;
    }
    if (curproc->signal_handlers[i - 1]->sa_handler == (void *)SIGCONT)
    {
      continue;
    }
    if (curproc->signal_handlers[i - 1]->sa_handler == (void *)SIG_DFL || curproc->signal_handlers[i - 1]->sa_handler == (void *)SIGKILL)
    {                              // as stated in the assignment
      kill(curproc->pid, SIGKILL); //
      continue;
    }

    //////////USER-SPACE HANDLERS////////////////
    curproc->signal_mask_backup = sigprocmask(curproc->signal_handlers[i]->sigmask); // updating the mask while keeping a copy of the old one (preventing support of nested user-level signal handling)

    // if((trap_frame->cs & 3) == DPL_USER){// checks the privilage or something, to see if we are in user space or otherwise (nested user signals)
    // pushcli();//for interrupts
    // if(cas(&curproc->))
    //}
    curproc->tf->esp -= sizeof(struct trapframe);                               // reserve space in the stack for the backup we are about to create
    memmove((void *)(curproc->tf->esp), curproc->tf, sizeof(struct trapframe)); //copy the trapframe into the reserved space in the stack
    curproc->userspace_trapframe_backup = (void *)(curproc->tf->esp);           //esp now points at the beginning of the backup we copied into the stack

    uint call_size = (uint)&injected_call_end - (uint)&injected_call_beginning; // with these we can find the size of the call to sigret that we want to push into the stack (return address). variables can be found in the 'injected_call.S' file
    curproc->tf->esp -= call_size;                                              //reserving space in stack
    memmove((void *)(curproc->tf->esp), injected_call_beginning, call_size);    //injecting call into the stack

    *((int *)(curproc->tf->esp - 4)) = i;                // pushing the first parameter- signum
    *((int *)(curproc->tf->esp - 8)) = curproc->tf->esp; //the return address (actually the sigret we injected)

    curproc->tf->esp -= 8; // updating esp
    curproc->tf->eip = (uint)curproc->signal_handlers[i - 1];
    break;
  }
}

void sigret(void)
{
  struct proc *curproc = myproc();

  pushcli(); // for interrupts

  memmove(curproc->tf, curproc->userspace_trapframe_backup, sizeof(struct trapframe)); //restoring the backup by updating the tf with the backup we saved in the checkS function
  curproc->tf->esp = curproc->tf->esp + sizeof(struct trapframe);                      //representing popping out the backup we saved in the stack
  curproc->signal_mask = curproc->signal_mask_backup;                                  //restoring the mask back to where it was before handling the signal (part of preventing nested user-level signal handling)
  popcli();
}

uint sigprocmask(uint sigmask)
{
  uint oldmask = myproc()->signal_mask;
  myproc()->signal_mask = sigmask;
  return oldmask;
}