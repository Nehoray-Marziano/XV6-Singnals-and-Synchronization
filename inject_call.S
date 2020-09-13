#include "traps.h"
#include "syscall.h"



.globl injected_call_beginning
.globl injected_call_end


injected_call_beginning: #this lets me save the address of the beginning of the call that I want to later inject
    movl $SYS_sigret, %eax
    int $T_SYSCALL
injected_call_end:  #this lets me save the address of the beginning of the call that I want to later inject