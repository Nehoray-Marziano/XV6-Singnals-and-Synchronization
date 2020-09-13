
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 2e 10 80       	mov    $0x80102ee0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 76 10 80       	push   $0x80107600
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 05 48 00 00       	call   80104860 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 76 10 80       	push   $0x80107607
80100097:	50                   	push   %eax
80100098:	e8 93 46 00 00       	call   80104730 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 b7 48 00 00       	call   801049a0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 f9 48 00 00       	call   80104a60 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 fe 45 00 00       	call   80104770 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 cd 1f 00 00       	call   80102150 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 0e 76 10 80       	push   $0x8010760e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 5d 46 00 00       	call   80104810 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 87 1f 00 00       	jmp    80102150 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 76 10 80       	push   $0x8010761f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 1c 46 00 00       	call   80104810 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 cc 45 00 00       	call   801047d0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 90 47 00 00       	call   801049a0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 ff 47 00 00       	jmp    80104a60 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 76 10 80       	push   $0x80107626
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 0b 15 00 00       	call   80101790 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 0f 47 00 00       	call   801049a0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002a7:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 a0 0f 11 80       	push   $0x80110fa0
801002c5:	e8 b6 3e 00 00       	call   80104180 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 40 36 00 00       	call   80103920 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 6c 47 00 00       	call   80104a60 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 b4 13 00 00       	call   801016b0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 0e 47 00 00       	call   80104a60 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 56 13 00 00       	call   801016b0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 c2 23 00 00       	call   80102770 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 2d 76 10 80       	push   $0x8010762d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 43 80 10 80 	movl   $0x80108043,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 a3 44 00 00       	call   80104880 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 41 76 10 80       	push   $0x80107641
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 d1 5d 00 00       	call   80106210 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 1f 5d 00 00       	call   80106210 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 13 5d 00 00       	call   80106210 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 07 5d 00 00       	call   80106210 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 37 46 00 00       	call   80104b60 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 6a 45 00 00       	call   80104ab0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 45 76 10 80       	push   $0x80107645
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 70 76 10 80 	movzbl -0x7fef8990(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 7c 11 00 00       	call   80101790 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 80 43 00 00       	call   801049a0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 14 44 00 00       	call   80104a60 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 5b 10 00 00       	call   801016b0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 3c 43 00 00       	call   80104a60 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 58 76 10 80       	mov    $0x80107658,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 ab 41 00 00       	call   801049a0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 5f 76 10 80       	push   $0x8010765f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 78 41 00 00       	call   801049a0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100856:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 d3 41 00 00       	call   80104a60 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100911:	68 a0 0f 11 80       	push   $0x80110fa0
80100916:	e8 15 39 00 00       	call   80104230 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010093d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100964:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 94 39 00 00       	jmp    80104330 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 68 76 10 80       	push   $0x80107668
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 8b 3e 00 00       	call   80104860 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 12 19 00 00       	call   80102310 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 ff 2e 00 00       	call   80103920 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  

  begin_op();
80100a27:	e8 b4 21 00 00       	call   80102be0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 d9 14 00 00       	call   80101f10 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 63 0c 00 00       	call   801016b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 32 0f 00 00       	call   80101990 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 d1 0e 00 00       	call   80101940 <iunlockput>
    end_op();
80100a6f:	e8 dc 21 00 00       	call   80102c50 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 c7 68 00 00       	call   80107360 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 c6 02 00 00    	je     80100d85 <exec+0x375>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 85 66 00 00       	call   80107180 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 93 65 00 00       	call   801070c0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 33 0e 00 00       	call   80101990 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 69 67 00 00       	call   801072e0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 a6 0d 00 00       	call   80101940 <iunlockput>
  end_op();
80100b9a:	e8 b1 20 00 00       	call   80102c50 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 d1 65 00 00       	call   80107180 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 1a 67 00 00       	call   801072e0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 78 20 00 00       	call   80102c50 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 81 76 10 80       	push   $0x80107681
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 f5 67 00 00       	call   80107400 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 92 40 00 00       	call   80104cd0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 7f 40 00 00       	call   80104cd0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 fe 68 00 00       	call   80107560 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 94 68 00 00       	call   80107560 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	8d 47 70             	lea    0x70(%edi),%eax
80100d07:	50                   	push   %eax
80100d08:	e8 83 3f 00 00       	call   80104c90 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d13:	89 fa                	mov    %edi,%edx
80100d15:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d18:	8b 42 18             	mov    0x18(%edx),%eax
  curproc->sz = sz;
80100d1b:	89 32                	mov    %esi,(%edx)
80100d1d:	83 c4 10             	add    $0x10,%esp
  curproc->pgdir = pgdir;
80100d20:	89 4a 04             	mov    %ecx,0x4(%edx)
  curproc->tf->eip = elf.entry;  // main
80100d23:	89 d1                	mov    %edx,%ecx
80100d25:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d2b:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2e:	8b 41 18             	mov    0x18(%ecx),%eax
80100d31:	89 58 44             	mov    %ebx,0x44(%eax)
80100d34:	89 c8                	mov    %ecx,%eax
80100d36:	8d 89 0c 01 00 00    	lea    0x10c(%ecx),%ecx
80100d3c:	05 8c 00 00 00       	add    $0x8c,%eax
80100d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((int)curproc->signal_handlers[j]->sa_handler>1){
80100d48:	8b 10                	mov    (%eax),%edx
80100d4a:	83 3a 01             	cmpl   $0x1,(%edx)
80100d4d:	7e 0f                	jle    80100d5e <exec+0x34e>
      curproc->signal_handlers[j]->sa_handler=(void*)SIG_DFL;
80100d4f:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
      curproc->signal_handlers[j]->sigmask=0;
80100d55:	8b 10                	mov    (%eax),%edx
80100d57:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
80100d5e:	83 c0 04             	add    $0x4,%eax
  for(j=0;j<32;j++){ 
80100d61:	39 c1                	cmp    %eax,%ecx
80100d63:	75 e3                	jne    80100d48 <exec+0x338>
  switchuvm(curproc);
80100d65:	83 ec 0c             	sub    $0xc,%esp
80100d68:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d6e:	e8 bd 61 00 00       	call   80106f30 <switchuvm>
  freevm(oldpgdir);
80100d73:	89 3c 24             	mov    %edi,(%esp)
80100d76:	e8 65 65 00 00       	call   801072e0 <freevm>
  return 0;
80100d7b:	83 c4 10             	add    $0x10,%esp
80100d7e:	31 c0                	xor    %eax,%eax
80100d80:	e9 f7 fc ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d85:	be 00 20 00 00       	mov    $0x2000,%esi
80100d8a:	e9 02 fe ff ff       	jmp    80100b91 <exec+0x181>
80100d8f:	90                   	nop

80100d90 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d96:	68 8d 76 10 80       	push   $0x8010768d
80100d9b:	68 c0 0f 11 80       	push   $0x80110fc0
80100da0:	e8 bb 3a 00 00       	call   80104860 <initlock>
}
80100da5:	83 c4 10             	add    $0x10,%esp
80100da8:	c9                   	leave  
80100da9:	c3                   	ret    
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100db0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db4:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100db9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dbc:	68 c0 0f 11 80       	push   $0x80110fc0
80100dc1:	e8 da 3b 00 00       	call   801049a0 <acquire>
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	eb 10                	jmp    80100ddb <filealloc+0x2b>
80100dcb:	90                   	nop
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dd0:	83 c3 18             	add    $0x18,%ebx
80100dd3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100dd9:	73 25                	jae    80100e00 <filealloc+0x50>
    if(f->ref == 0){
80100ddb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dde:	85 c0                	test   %eax,%eax
80100de0:	75 ee                	jne    80100dd0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100de2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100de5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dec:	68 c0 0f 11 80       	push   $0x80110fc0
80100df1:	e8 6a 3c 00 00       	call   80104a60 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100df6:	89 d8                	mov    %ebx,%eax
      return f;
80100df8:	83 c4 10             	add    $0x10,%esp
}
80100dfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dfe:	c9                   	leave  
80100dff:	c3                   	ret    
  release(&ftable.lock);
80100e00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e03:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e05:	68 c0 0f 11 80       	push   $0x80110fc0
80100e0a:	e8 51 3c 00 00       	call   80104a60 <release>
}
80100e0f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e11:	83 c4 10             	add    $0x10,%esp
}
80100e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e17:	c9                   	leave  
80100e18:	c3                   	ret    
80100e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	53                   	push   %ebx
80100e24:	83 ec 10             	sub    $0x10,%esp
80100e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e2a:	68 c0 0f 11 80       	push   $0x80110fc0
80100e2f:	e8 6c 3b 00 00       	call   801049a0 <acquire>
  if(f->ref < 1)
80100e34:	8b 43 04             	mov    0x4(%ebx),%eax
80100e37:	83 c4 10             	add    $0x10,%esp
80100e3a:	85 c0                	test   %eax,%eax
80100e3c:	7e 1a                	jle    80100e58 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e3e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e41:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e44:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e47:	68 c0 0f 11 80       	push   $0x80110fc0
80100e4c:	e8 0f 3c 00 00       	call   80104a60 <release>
  return f;
}
80100e51:	89 d8                	mov    %ebx,%eax
80100e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e56:	c9                   	leave  
80100e57:	c3                   	ret    
    panic("filedup");
80100e58:	83 ec 0c             	sub    $0xc,%esp
80100e5b:	68 94 76 10 80       	push   $0x80107694
80100e60:	e8 2b f5 ff ff       	call   80100390 <panic>
80100e65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e70 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	57                   	push   %edi
80100e74:	56                   	push   %esi
80100e75:	53                   	push   %ebx
80100e76:	83 ec 28             	sub    $0x28,%esp
80100e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e7c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e81:	e8 1a 3b 00 00       	call   801049a0 <acquire>
  if(f->ref < 1)
80100e86:	8b 43 04             	mov    0x4(%ebx),%eax
80100e89:	83 c4 10             	add    $0x10,%esp
80100e8c:	85 c0                	test   %eax,%eax
80100e8e:	0f 8e 9b 00 00 00    	jle    80100f2f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e94:	83 e8 01             	sub    $0x1,%eax
80100e97:	85 c0                	test   %eax,%eax
80100e99:	89 43 04             	mov    %eax,0x4(%ebx)
80100e9c:	74 1a                	je     80100eb8 <fileclose+0x48>
    release(&ftable.lock);
80100e9e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ea5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ea8:	5b                   	pop    %ebx
80100ea9:	5e                   	pop    %esi
80100eaa:	5f                   	pop    %edi
80100eab:	5d                   	pop    %ebp
    release(&ftable.lock);
80100eac:	e9 af 3b 00 00       	jmp    80104a60 <release>
80100eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100eb8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100ebc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100ebe:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ec1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100ec4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eca:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ecd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ed0:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100ed5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ed8:	e8 83 3b 00 00       	call   80104a60 <release>
  if(ff.type == FD_PIPE)
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	83 ff 01             	cmp    $0x1,%edi
80100ee3:	74 13                	je     80100ef8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ee5:	83 ff 02             	cmp    $0x2,%edi
80100ee8:	74 26                	je     80100f10 <fileclose+0xa0>
}
80100eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eed:	5b                   	pop    %ebx
80100eee:	5e                   	pop    %esi
80100eef:	5f                   	pop    %edi
80100ef0:	5d                   	pop    %ebp
80100ef1:	c3                   	ret    
80100ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ef8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100efc:	83 ec 08             	sub    $0x8,%esp
80100eff:	53                   	push   %ebx
80100f00:	56                   	push   %esi
80100f01:	e8 8a 24 00 00       	call   80103390 <pipeclose>
80100f06:	83 c4 10             	add    $0x10,%esp
80100f09:	eb df                	jmp    80100eea <fileclose+0x7a>
80100f0b:	90                   	nop
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f10:	e8 cb 1c 00 00       	call   80102be0 <begin_op>
    iput(ff.ip);
80100f15:	83 ec 0c             	sub    $0xc,%esp
80100f18:	ff 75 e0             	pushl  -0x20(%ebp)
80100f1b:	e8 c0 08 00 00       	call   801017e0 <iput>
    end_op();
80100f20:	83 c4 10             	add    $0x10,%esp
}
80100f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f26:	5b                   	pop    %ebx
80100f27:	5e                   	pop    %esi
80100f28:	5f                   	pop    %edi
80100f29:	5d                   	pop    %ebp
    end_op();
80100f2a:	e9 21 1d 00 00       	jmp    80102c50 <end_op>
    panic("fileclose");
80100f2f:	83 ec 0c             	sub    $0xc,%esp
80100f32:	68 9c 76 10 80       	push   $0x8010769c
80100f37:	e8 54 f4 ff ff       	call   80100390 <panic>
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	53                   	push   %ebx
80100f44:	83 ec 04             	sub    $0x4,%esp
80100f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f4a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f4d:	75 31                	jne    80100f80 <filestat+0x40>
    ilock(f->ip);
80100f4f:	83 ec 0c             	sub    $0xc,%esp
80100f52:	ff 73 10             	pushl  0x10(%ebx)
80100f55:	e8 56 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100f5a:	58                   	pop    %eax
80100f5b:	5a                   	pop    %edx
80100f5c:	ff 75 0c             	pushl  0xc(%ebp)
80100f5f:	ff 73 10             	pushl  0x10(%ebx)
80100f62:	e8 f9 09 00 00       	call   80101960 <stati>
    iunlock(f->ip);
80100f67:	59                   	pop    %ecx
80100f68:	ff 73 10             	pushl  0x10(%ebx)
80100f6b:	e8 20 08 00 00       	call   80101790 <iunlock>
    return 0;
80100f70:	83 c4 10             	add    $0x10,%esp
80100f73:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f78:	c9                   	leave  
80100f79:	c3                   	ret    
80100f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f85:	eb ee                	jmp    80100f75 <filestat+0x35>
80100f87:	89 f6                	mov    %esi,%esi
80100f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f90 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	57                   	push   %edi
80100f94:	56                   	push   %esi
80100f95:	53                   	push   %ebx
80100f96:	83 ec 0c             	sub    $0xc,%esp
80100f99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f9f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100fa2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fa6:	74 60                	je     80101008 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100fa8:	8b 03                	mov    (%ebx),%eax
80100faa:	83 f8 01             	cmp    $0x1,%eax
80100fad:	74 41                	je     80100ff0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100faf:	83 f8 02             	cmp    $0x2,%eax
80100fb2:	75 5b                	jne    8010100f <fileread+0x7f>
    ilock(f->ip);
80100fb4:	83 ec 0c             	sub    $0xc,%esp
80100fb7:	ff 73 10             	pushl  0x10(%ebx)
80100fba:	e8 f1 06 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fbf:	57                   	push   %edi
80100fc0:	ff 73 14             	pushl  0x14(%ebx)
80100fc3:	56                   	push   %esi
80100fc4:	ff 73 10             	pushl  0x10(%ebx)
80100fc7:	e8 c4 09 00 00       	call   80101990 <readi>
80100fcc:	83 c4 20             	add    $0x20,%esp
80100fcf:	85 c0                	test   %eax,%eax
80100fd1:	89 c6                	mov    %eax,%esi
80100fd3:	7e 03                	jle    80100fd8 <fileread+0x48>
      f->off += r;
80100fd5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fd8:	83 ec 0c             	sub    $0xc,%esp
80100fdb:	ff 73 10             	pushl  0x10(%ebx)
80100fde:	e8 ad 07 00 00       	call   80101790 <iunlock>
    return r;
80100fe3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe9:	89 f0                	mov    %esi,%eax
80100feb:	5b                   	pop    %ebx
80100fec:	5e                   	pop    %esi
80100fed:	5f                   	pop    %edi
80100fee:	5d                   	pop    %ebp
80100fef:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100ff0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100ff3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff9:	5b                   	pop    %ebx
80100ffa:	5e                   	pop    %esi
80100ffb:	5f                   	pop    %edi
80100ffc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100ffd:	e9 3e 25 00 00       	jmp    80103540 <piperead>
80101002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101008:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010100d:	eb d7                	jmp    80100fe6 <fileread+0x56>
  panic("fileread");
8010100f:	83 ec 0c             	sub    $0xc,%esp
80101012:	68 a6 76 10 80       	push   $0x801076a6
80101017:	e8 74 f3 ff ff       	call   80100390 <panic>
8010101c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101020 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 1c             	sub    $0x1c,%esp
80101029:	8b 75 08             	mov    0x8(%ebp),%esi
8010102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010102f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101033:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101036:	8b 45 10             	mov    0x10(%ebp),%eax
80101039:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010103c:	0f 84 aa 00 00 00    	je     801010ec <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101042:	8b 06                	mov    (%esi),%eax
80101044:	83 f8 01             	cmp    $0x1,%eax
80101047:	0f 84 c3 00 00 00    	je     80101110 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104d:	83 f8 02             	cmp    $0x2,%eax
80101050:	0f 85 d9 00 00 00    	jne    8010112f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101059:	31 ff                	xor    %edi,%edi
    while(i < n){
8010105b:	85 c0                	test   %eax,%eax
8010105d:	7f 34                	jg     80101093 <filewrite+0x73>
8010105f:	e9 9c 00 00 00       	jmp    80101100 <filewrite+0xe0>
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101068:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101071:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101074:	e8 17 07 00 00       	call   80101790 <iunlock>
      end_op();
80101079:	e8 d2 1b 00 00       	call   80102c50 <end_op>
8010107e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101081:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101084:	39 c3                	cmp    %eax,%ebx
80101086:	0f 85 96 00 00 00    	jne    80101122 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010108c:	01 df                	add    %ebx,%edi
    while(i < n){
8010108e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101091:	7e 6d                	jle    80101100 <filewrite+0xe0>
      int n1 = n - i;
80101093:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101096:	b8 00 06 00 00       	mov    $0x600,%eax
8010109b:	29 fb                	sub    %edi,%ebx
8010109d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010a3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801010a6:	e8 35 1b 00 00       	call   80102be0 <begin_op>
      ilock(f->ip);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	ff 76 10             	pushl  0x10(%esi)
801010b1:	e8 fa 05 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010b9:	53                   	push   %ebx
801010ba:	ff 76 14             	pushl  0x14(%esi)
801010bd:	01 f8                	add    %edi,%eax
801010bf:	50                   	push   %eax
801010c0:	ff 76 10             	pushl  0x10(%esi)
801010c3:	e8 c8 09 00 00       	call   80101a90 <writei>
801010c8:	83 c4 20             	add    $0x20,%esp
801010cb:	85 c0                	test   %eax,%eax
801010cd:	7f 99                	jg     80101068 <filewrite+0x48>
      iunlock(f->ip);
801010cf:	83 ec 0c             	sub    $0xc,%esp
801010d2:	ff 76 10             	pushl  0x10(%esi)
801010d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010d8:	e8 b3 06 00 00       	call   80101790 <iunlock>
      end_op();
801010dd:	e8 6e 1b 00 00       	call   80102c50 <end_op>
      if(r < 0)
801010e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e5:	83 c4 10             	add    $0x10,%esp
801010e8:	85 c0                	test   %eax,%eax
801010ea:	74 98                	je     80101084 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010ef:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010f4:	89 f8                	mov    %edi,%eax
801010f6:	5b                   	pop    %ebx
801010f7:	5e                   	pop    %esi
801010f8:	5f                   	pop    %edi
801010f9:	5d                   	pop    %ebp
801010fa:	c3                   	ret    
801010fb:	90                   	nop
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101100:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101103:	75 e7                	jne    801010ec <filewrite+0xcc>
}
80101105:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101108:	89 f8                	mov    %edi,%eax
8010110a:	5b                   	pop    %ebx
8010110b:	5e                   	pop    %esi
8010110c:	5f                   	pop    %edi
8010110d:	5d                   	pop    %ebp
8010110e:	c3                   	ret    
8010110f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101110:	8b 46 0c             	mov    0xc(%esi),%eax
80101113:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101119:	5b                   	pop    %ebx
8010111a:	5e                   	pop    %esi
8010111b:	5f                   	pop    %edi
8010111c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010111d:	e9 0e 23 00 00       	jmp    80103430 <pipewrite>
        panic("short filewrite");
80101122:	83 ec 0c             	sub    $0xc,%esp
80101125:	68 af 76 10 80       	push   $0x801076af
8010112a:	e8 61 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 b5 76 10 80       	push   $0x801076b5
80101137:	e8 54 f2 ff ff       	call   80100390 <panic>
8010113c:	66 90                	xchg   %ax,%ax
8010113e:	66 90                	xchg   %ax,%ax

80101140 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	56                   	push   %esi
80101144:	53                   	push   %ebx
80101145:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101147:	c1 ea 0c             	shr    $0xc,%edx
8010114a:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101150:	83 ec 08             	sub    $0x8,%esp
80101153:	52                   	push   %edx
80101154:	50                   	push   %eax
80101155:	e8 76 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010115a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010115c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010115f:	ba 01 00 00 00       	mov    $0x1,%edx
80101164:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101167:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010116d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101170:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101172:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101177:	85 d1                	test   %edx,%ecx
80101179:	74 25                	je     801011a0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010117b:	f7 d2                	not    %edx
8010117d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010117f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101182:	21 ca                	and    %ecx,%edx
80101184:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101188:	56                   	push   %esi
80101189:	e8 22 1c 00 00       	call   80102db0 <log_write>
  brelse(bp);
8010118e:	89 34 24             	mov    %esi,(%esp)
80101191:	e8 4a f0 ff ff       	call   801001e0 <brelse>
}
80101196:	83 c4 10             	add    $0x10,%esp
80101199:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010119c:	5b                   	pop    %ebx
8010119d:	5e                   	pop    %esi
8010119e:	5d                   	pop    %ebp
8010119f:	c3                   	ret    
    panic("freeing free block");
801011a0:	83 ec 0c             	sub    $0xc,%esp
801011a3:	68 bf 76 10 80       	push   $0x801076bf
801011a8:	e8 e3 f1 ff ff       	call   80100390 <panic>
801011ad:	8d 76 00             	lea    0x0(%esi),%esi

801011b0 <balloc>:
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	56                   	push   %esi
801011b5:	53                   	push   %ebx
801011b6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801011b9:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
801011bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011c2:	85 c9                	test   %ecx,%ecx
801011c4:	0f 84 87 00 00 00    	je     80101251 <balloc+0xa1>
801011ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011d1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	89 f0                	mov    %esi,%eax
801011d9:	c1 f8 0c             	sar    $0xc,%eax
801011dc:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801011e2:	50                   	push   %eax
801011e3:	ff 75 d8             	pushl  -0x28(%ebp)
801011e6:	e8 e5 ee ff ff       	call   801000d0 <bread>
801011eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ee:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801011f3:	83 c4 10             	add    $0x10,%esp
801011f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011f9:	31 c0                	xor    %eax,%eax
801011fb:	eb 2f                	jmp    8010122c <balloc+0x7c>
801011fd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101200:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101202:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101205:	bb 01 00 00 00       	mov    $0x1,%ebx
8010120a:	83 e1 07             	and    $0x7,%ecx
8010120d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010120f:	89 c1                	mov    %eax,%ecx
80101211:	c1 f9 03             	sar    $0x3,%ecx
80101214:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101219:	85 df                	test   %ebx,%edi
8010121b:	89 fa                	mov    %edi,%edx
8010121d:	74 41                	je     80101260 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121f:	83 c0 01             	add    $0x1,%eax
80101222:	83 c6 01             	add    $0x1,%esi
80101225:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010122a:	74 05                	je     80101231 <balloc+0x81>
8010122c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010122f:	77 cf                	ja     80101200 <balloc+0x50>
    brelse(bp);
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	ff 75 e4             	pushl  -0x1c(%ebp)
80101237:	e8 a4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010123c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101243:	83 c4 10             	add    $0x10,%esp
80101246:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101249:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010124f:	77 80                	ja     801011d1 <balloc+0x21>
  panic("balloc: out of blocks");
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 d2 76 10 80       	push   $0x801076d2
80101259:	e8 32 f1 ff ff       	call   80100390 <panic>
8010125e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101260:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101263:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101266:	09 da                	or     %ebx,%edx
80101268:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010126c:	57                   	push   %edi
8010126d:	e8 3e 1b 00 00       	call   80102db0 <log_write>
        brelse(bp);
80101272:	89 3c 24             	mov    %edi,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010127a:	58                   	pop    %eax
8010127b:	5a                   	pop    %edx
8010127c:	56                   	push   %esi
8010127d:	ff 75 d8             	pushl  -0x28(%ebp)
80101280:	e8 4b ee ff ff       	call   801000d0 <bread>
80101285:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101287:	8d 40 5c             	lea    0x5c(%eax),%eax
8010128a:	83 c4 0c             	add    $0xc,%esp
8010128d:	68 00 02 00 00       	push   $0x200
80101292:	6a 00                	push   $0x0
80101294:	50                   	push   %eax
80101295:	e8 16 38 00 00       	call   80104ab0 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 0e 1b 00 00       	call   80102db0 <log_write>
  brelse(bp);
801012a2:	89 1c 24             	mov    %ebx,(%esp)
801012a5:	e8 36 ef ff ff       	call   801001e0 <brelse>
}
801012aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ad:	89 f0                	mov    %esi,%eax
801012af:	5b                   	pop    %ebx
801012b0:	5e                   	pop    %esi
801012b1:	5f                   	pop    %edi
801012b2:	5d                   	pop    %ebp
801012b3:	c3                   	ret    
801012b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012c8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ca:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
801012cf:	83 ec 28             	sub    $0x28,%esp
801012d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012d5:	68 e0 19 11 80       	push   $0x801119e0
801012da:	e8 c1 36 00 00       	call   801049a0 <acquire>
801012df:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012e5:	eb 17                	jmp    801012fe <iget+0x3e>
801012e7:	89 f6                	mov    %esi,%esi
801012e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012f0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012f6:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801012fc:	73 22                	jae    80101320 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012fe:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101301:	85 c9                	test   %ecx,%ecx
80101303:	7e 04                	jle    80101309 <iget+0x49>
80101305:	39 3b                	cmp    %edi,(%ebx)
80101307:	74 4f                	je     80101358 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101309:	85 f6                	test   %esi,%esi
8010130b:	75 e3                	jne    801012f0 <iget+0x30>
8010130d:	85 c9                	test   %ecx,%ecx
8010130f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101312:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101318:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010131e:	72 de                	jb     801012fe <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101320:	85 f6                	test   %esi,%esi
80101322:	74 5b                	je     8010137f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101324:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101327:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101329:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010132c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101333:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010133a:	68 e0 19 11 80       	push   $0x801119e0
8010133f:	e8 1c 37 00 00       	call   80104a60 <release>

  return ip;
80101344:	83 c4 10             	add    $0x10,%esp
}
80101347:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134a:	89 f0                	mov    %esi,%eax
8010134c:	5b                   	pop    %ebx
8010134d:	5e                   	pop    %esi
8010134e:	5f                   	pop    %edi
8010134f:	5d                   	pop    %ebp
80101350:	c3                   	ret    
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101358:	39 53 04             	cmp    %edx,0x4(%ebx)
8010135b:	75 ac                	jne    80101309 <iget+0x49>
      release(&icache.lock);
8010135d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101360:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101363:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101365:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
8010136a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010136d:	e8 ee 36 00 00       	call   80104a60 <release>
      return ip;
80101372:	83 c4 10             	add    $0x10,%esp
}
80101375:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101378:	89 f0                	mov    %esi,%eax
8010137a:	5b                   	pop    %ebx
8010137b:	5e                   	pop    %esi
8010137c:	5f                   	pop    %edi
8010137d:	5d                   	pop    %ebp
8010137e:	c3                   	ret    
    panic("iget: no inodes");
8010137f:	83 ec 0c             	sub    $0xc,%esp
80101382:	68 e8 76 10 80       	push   $0x801076e8
80101387:	e8 04 f0 ff ff       	call   80100390 <panic>
8010138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101390 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	53                   	push   %ebx
80101396:	89 c6                	mov    %eax,%esi
80101398:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010139b:	83 fa 0b             	cmp    $0xb,%edx
8010139e:	77 18                	ja     801013b8 <bmap+0x28>
801013a0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801013a3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801013a6:	85 db                	test   %ebx,%ebx
801013a8:	74 76                	je     80101420 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ad:	89 d8                	mov    %ebx,%eax
801013af:	5b                   	pop    %ebx
801013b0:	5e                   	pop    %esi
801013b1:	5f                   	pop    %edi
801013b2:	5d                   	pop    %ebp
801013b3:	c3                   	ret    
801013b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801013b8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801013bb:	83 fb 7f             	cmp    $0x7f,%ebx
801013be:	0f 87 90 00 00 00    	ja     80101454 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013c4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013ca:	8b 00                	mov    (%eax),%eax
801013cc:	85 d2                	test   %edx,%edx
801013ce:	74 70                	je     80101440 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013d0:	83 ec 08             	sub    $0x8,%esp
801013d3:	52                   	push   %edx
801013d4:	50                   	push   %eax
801013d5:	e8 f6 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013da:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013de:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013e1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013e3:	8b 1a                	mov    (%edx),%ebx
801013e5:	85 db                	test   %ebx,%ebx
801013e7:	75 1d                	jne    80101406 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013e9:	8b 06                	mov    (%esi),%eax
801013eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013ee:	e8 bd fd ff ff       	call   801011b0 <balloc>
801013f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013f6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013f9:	89 c3                	mov    %eax,%ebx
801013fb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013fd:	57                   	push   %edi
801013fe:	e8 ad 19 00 00       	call   80102db0 <log_write>
80101403:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101406:	83 ec 0c             	sub    $0xc,%esp
80101409:	57                   	push   %edi
8010140a:	e8 d1 ed ff ff       	call   801001e0 <brelse>
8010140f:	83 c4 10             	add    $0x10,%esp
}
80101412:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101415:	89 d8                	mov    %ebx,%eax
80101417:	5b                   	pop    %ebx
80101418:	5e                   	pop    %esi
80101419:	5f                   	pop    %edi
8010141a:	5d                   	pop    %ebp
8010141b:	c3                   	ret    
8010141c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101420:	8b 00                	mov    (%eax),%eax
80101422:	e8 89 fd ff ff       	call   801011b0 <balloc>
80101427:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010142a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010142d:	89 c3                	mov    %eax,%ebx
}
8010142f:	89 d8                	mov    %ebx,%eax
80101431:	5b                   	pop    %ebx
80101432:	5e                   	pop    %esi
80101433:	5f                   	pop    %edi
80101434:	5d                   	pop    %ebp
80101435:	c3                   	ret    
80101436:	8d 76 00             	lea    0x0(%esi),%esi
80101439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101440:	e8 6b fd ff ff       	call   801011b0 <balloc>
80101445:	89 c2                	mov    %eax,%edx
80101447:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010144d:	8b 06                	mov    (%esi),%eax
8010144f:	e9 7c ff ff ff       	jmp    801013d0 <bmap+0x40>
  panic("bmap: out of range");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 f8 76 10 80       	push   $0x801076f8
8010145c:	e8 2f ef ff ff       	call   80100390 <panic>
80101461:	eb 0d                	jmp    80101470 <readsb>
80101463:	90                   	nop
80101464:	90                   	nop
80101465:	90                   	nop
80101466:	90                   	nop
80101467:	90                   	nop
80101468:	90                   	nop
80101469:	90                   	nop
8010146a:	90                   	nop
8010146b:	90                   	nop
8010146c:	90                   	nop
8010146d:	90                   	nop
8010146e:	90                   	nop
8010146f:	90                   	nop

80101470 <readsb>:
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	56                   	push   %esi
80101474:	53                   	push   %ebx
80101475:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101478:	83 ec 08             	sub    $0x8,%esp
8010147b:	6a 01                	push   $0x1
8010147d:	ff 75 08             	pushl  0x8(%ebp)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
80101485:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101487:	8d 40 5c             	lea    0x5c(%eax),%eax
8010148a:	83 c4 0c             	add    $0xc,%esp
8010148d:	6a 1c                	push   $0x1c
8010148f:	50                   	push   %eax
80101490:	56                   	push   %esi
80101491:	e8 ca 36 00 00       	call   80104b60 <memmove>
  brelse(bp);
80101496:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101499:	83 c4 10             	add    $0x10,%esp
}
8010149c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010149f:	5b                   	pop    %ebx
801014a0:	5e                   	pop    %esi
801014a1:	5d                   	pop    %ebp
  brelse(bp);
801014a2:	e9 39 ed ff ff       	jmp    801001e0 <brelse>
801014a7:	89 f6                	mov    %esi,%esi
801014a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014b0 <iinit>:
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	53                   	push   %ebx
801014b4:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
801014b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014bc:	68 0b 77 10 80       	push   $0x8010770b
801014c1:	68 e0 19 11 80       	push   $0x801119e0
801014c6:	e8 95 33 00 00       	call   80104860 <initlock>
801014cb:	83 c4 10             	add    $0x10,%esp
801014ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014d0:	83 ec 08             	sub    $0x8,%esp
801014d3:	68 12 77 10 80       	push   $0x80107712
801014d8:	53                   	push   %ebx
801014d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014df:	e8 4c 32 00 00       	call   80104730 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014e4:	83 c4 10             	add    $0x10,%esp
801014e7:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801014ed:	75 e1                	jne    801014d0 <iinit+0x20>
  readsb(dev, &sb);
801014ef:	83 ec 08             	sub    $0x8,%esp
801014f2:	68 c0 19 11 80       	push   $0x801119c0
801014f7:	ff 75 08             	pushl  0x8(%ebp)
801014fa:	e8 71 ff ff ff       	call   80101470 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014ff:	ff 35 d8 19 11 80    	pushl  0x801119d8
80101505:	ff 35 d4 19 11 80    	pushl  0x801119d4
8010150b:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101511:	ff 35 cc 19 11 80    	pushl  0x801119cc
80101517:	ff 35 c8 19 11 80    	pushl  0x801119c8
8010151d:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101523:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101529:	68 78 77 10 80       	push   $0x80107778
8010152e:	e8 2d f1 ff ff       	call   80100660 <cprintf>
}
80101533:	83 c4 30             	add    $0x30,%esp
80101536:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101539:	c9                   	leave  
8010153a:	c3                   	ret    
8010153b:	90                   	nop
8010153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101540 <ialloc>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
80101550:	8b 45 0c             	mov    0xc(%ebp),%eax
80101553:	8b 75 08             	mov    0x8(%ebp),%esi
80101556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101559:	0f 86 91 00 00 00    	jbe    801015f0 <ialloc+0xb0>
8010155f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101564:	eb 21                	jmp    80101587 <ialloc+0x47>
80101566:	8d 76 00             	lea    0x0(%esi),%esi
80101569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101570:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101573:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101576:	57                   	push   %edi
80101577:	e8 64 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101585:	76 69                	jbe    801015f0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101587:	89 d8                	mov    %ebx,%eax
80101589:	83 ec 08             	sub    $0x8,%esp
8010158c:	c1 e8 03             	shr    $0x3,%eax
8010158f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101595:	50                   	push   %eax
80101596:	56                   	push   %esi
80101597:	e8 34 eb ff ff       	call   801000d0 <bread>
8010159c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010159e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015a0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801015a3:	83 e0 07             	and    $0x7,%eax
801015a6:	c1 e0 06             	shl    $0x6,%eax
801015a9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015ad:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015b1:	75 bd                	jne    80101570 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015b3:	83 ec 04             	sub    $0x4,%esp
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	6a 40                	push   $0x40
801015bb:	6a 00                	push   $0x0
801015bd:	51                   	push   %ecx
801015be:	e8 ed 34 00 00       	call   80104ab0 <memset>
      dip->type = type;
801015c3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015ca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015cd:	89 3c 24             	mov    %edi,(%esp)
801015d0:	e8 db 17 00 00       	call   80102db0 <log_write>
      brelse(bp);
801015d5:	89 3c 24             	mov    %edi,(%esp)
801015d8:	e8 03 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015dd:	83 c4 10             	add    $0x10,%esp
}
801015e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015e3:	89 da                	mov    %ebx,%edx
801015e5:	89 f0                	mov    %esi,%eax
}
801015e7:	5b                   	pop    %ebx
801015e8:	5e                   	pop    %esi
801015e9:	5f                   	pop    %edi
801015ea:	5d                   	pop    %ebp
      return iget(dev, inum);
801015eb:	e9 d0 fc ff ff       	jmp    801012c0 <iget>
  panic("ialloc: no inodes");
801015f0:	83 ec 0c             	sub    $0xc,%esp
801015f3:	68 18 77 10 80       	push   $0x80107718
801015f8:	e8 93 ed ff ff       	call   80100390 <panic>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <iupdate>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101608:	83 ec 08             	sub    $0x8,%esp
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010161a:	50                   	push   %eax
8010161b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010161e:	e8 ad ea ff ff       	call   801000d0 <bread>
80101623:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101625:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101628:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010162f:	83 e0 07             	and    $0x7,%eax
80101632:	c1 e0 06             	shl    $0x6,%eax
80101635:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101639:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010163c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101640:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101643:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101647:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010164b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010164f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101653:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101657:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010165a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010165d:	6a 34                	push   $0x34
8010165f:	53                   	push   %ebx
80101660:	50                   	push   %eax
80101661:	e8 fa 34 00 00       	call   80104b60 <memmove>
  log_write(bp);
80101666:	89 34 24             	mov    %esi,(%esp)
80101669:	e8 42 17 00 00       	call   80102db0 <log_write>
  brelse(bp);
8010166e:	89 75 08             	mov    %esi,0x8(%ebp)
80101671:	83 c4 10             	add    $0x10,%esp
}
80101674:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101677:	5b                   	pop    %ebx
80101678:	5e                   	pop    %esi
80101679:	5d                   	pop    %ebp
  brelse(bp);
8010167a:	e9 61 eb ff ff       	jmp    801001e0 <brelse>
8010167f:	90                   	nop

80101680 <idup>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 10             	sub    $0x10,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	68 e0 19 11 80       	push   $0x801119e0
8010168f:	e8 0c 33 00 00       	call   801049a0 <acquire>
  ip->ref++;
80101694:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101698:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010169f:	e8 bc 33 00 00       	call   80104a60 <release>
}
801016a4:	89 d8                	mov    %ebx,%eax
801016a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016a9:	c9                   	leave  
801016aa:	c3                   	ret    
801016ab:	90                   	nop
801016ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016b0 <ilock>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016b8:	85 db                	test   %ebx,%ebx
801016ba:	0f 84 b7 00 00 00    	je     80101777 <ilock+0xc7>
801016c0:	8b 53 08             	mov    0x8(%ebx),%edx
801016c3:	85 d2                	test   %edx,%edx
801016c5:	0f 8e ac 00 00 00    	jle    80101777 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016cb:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ce:	83 ec 0c             	sub    $0xc,%esp
801016d1:	50                   	push   %eax
801016d2:	e8 99 30 00 00       	call   80104770 <acquiresleep>
  if(ip->valid == 0){
801016d7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016da:	83 c4 10             	add    $0x10,%esp
801016dd:	85 c0                	test   %eax,%eax
801016df:	74 0f                	je     801016f0 <ilock+0x40>
}
801016e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016e4:	5b                   	pop    %ebx
801016e5:	5e                   	pop    %esi
801016e6:	5d                   	pop    %ebp
801016e7:	c3                   	ret    
801016e8:	90                   	nop
801016e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f0:	8b 43 04             	mov    0x4(%ebx),%eax
801016f3:	83 ec 08             	sub    $0x8,%esp
801016f6:	c1 e8 03             	shr    $0x3,%eax
801016f9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016ff:	50                   	push   %eax
80101700:	ff 33                	pushl  (%ebx)
80101702:	e8 c9 e9 ff ff       	call   801000d0 <bread>
80101707:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101709:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010170c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010170f:	83 e0 07             	and    $0x7,%eax
80101712:	c1 e0 06             	shl    $0x6,%eax
80101715:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101719:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010171c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010171f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101723:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101727:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010172b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010172f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101733:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101737:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010173b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010173e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101741:	6a 34                	push   $0x34
80101743:	50                   	push   %eax
80101744:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101747:	50                   	push   %eax
80101748:	e8 13 34 00 00       	call   80104b60 <memmove>
    brelse(bp);
8010174d:	89 34 24             	mov    %esi,(%esp)
80101750:	e8 8b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101755:	83 c4 10             	add    $0x10,%esp
80101758:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010175d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101764:	0f 85 77 ff ff ff    	jne    801016e1 <ilock+0x31>
      panic("ilock: no type");
8010176a:	83 ec 0c             	sub    $0xc,%esp
8010176d:	68 30 77 10 80       	push   $0x80107730
80101772:	e8 19 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101777:	83 ec 0c             	sub    $0xc,%esp
8010177a:	68 2a 77 10 80       	push   $0x8010772a
8010177f:	e8 0c ec ff ff       	call   80100390 <panic>
80101784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010178a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101790 <iunlock>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101798:	85 db                	test   %ebx,%ebx
8010179a:	74 28                	je     801017c4 <iunlock+0x34>
8010179c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010179f:	83 ec 0c             	sub    $0xc,%esp
801017a2:	56                   	push   %esi
801017a3:	e8 68 30 00 00       	call   80104810 <holdingsleep>
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	85 c0                	test   %eax,%eax
801017ad:	74 15                	je     801017c4 <iunlock+0x34>
801017af:	8b 43 08             	mov    0x8(%ebx),%eax
801017b2:	85 c0                	test   %eax,%eax
801017b4:	7e 0e                	jle    801017c4 <iunlock+0x34>
  releasesleep(&ip->lock);
801017b6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017bc:	5b                   	pop    %ebx
801017bd:	5e                   	pop    %esi
801017be:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017bf:	e9 0c 30 00 00       	jmp    801047d0 <releasesleep>
    panic("iunlock");
801017c4:	83 ec 0c             	sub    $0xc,%esp
801017c7:	68 3f 77 10 80       	push   $0x8010773f
801017cc:	e8 bf eb ff ff       	call   80100390 <panic>
801017d1:	eb 0d                	jmp    801017e0 <iput>
801017d3:	90                   	nop
801017d4:	90                   	nop
801017d5:	90                   	nop
801017d6:	90                   	nop
801017d7:	90                   	nop
801017d8:	90                   	nop
801017d9:	90                   	nop
801017da:	90                   	nop
801017db:	90                   	nop
801017dc:	90                   	nop
801017dd:	90                   	nop
801017de:	90                   	nop
801017df:	90                   	nop

801017e0 <iput>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	83 ec 28             	sub    $0x28,%esp
801017e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017ec:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017ef:	57                   	push   %edi
801017f0:	e8 7b 2f 00 00       	call   80104770 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017f5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017f8:	83 c4 10             	add    $0x10,%esp
801017fb:	85 d2                	test   %edx,%edx
801017fd:	74 07                	je     80101806 <iput+0x26>
801017ff:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101804:	74 32                	je     80101838 <iput+0x58>
  releasesleep(&ip->lock);
80101806:	83 ec 0c             	sub    $0xc,%esp
80101809:	57                   	push   %edi
8010180a:	e8 c1 2f 00 00       	call   801047d0 <releasesleep>
  acquire(&icache.lock);
8010180f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101816:	e8 85 31 00 00       	call   801049a0 <acquire>
  ip->ref--;
8010181b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010181f:	83 c4 10             	add    $0x10,%esp
80101822:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101829:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5f                   	pop    %edi
8010182f:	5d                   	pop    %ebp
  release(&icache.lock);
80101830:	e9 2b 32 00 00       	jmp    80104a60 <release>
80101835:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101838:	83 ec 0c             	sub    $0xc,%esp
8010183b:	68 e0 19 11 80       	push   $0x801119e0
80101840:	e8 5b 31 00 00       	call   801049a0 <acquire>
    int r = ip->ref;
80101845:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101848:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010184f:	e8 0c 32 00 00       	call   80104a60 <release>
    if(r == 1){
80101854:	83 c4 10             	add    $0x10,%esp
80101857:	83 fe 01             	cmp    $0x1,%esi
8010185a:	75 aa                	jne    80101806 <iput+0x26>
8010185c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101862:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101865:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101868:	89 cf                	mov    %ecx,%edi
8010186a:	eb 0b                	jmp    80101877 <iput+0x97>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101870:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101873:	39 fe                	cmp    %edi,%esi
80101875:	74 19                	je     80101890 <iput+0xb0>
    if(ip->addrs[i]){
80101877:	8b 16                	mov    (%esi),%edx
80101879:	85 d2                	test   %edx,%edx
8010187b:	74 f3                	je     80101870 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010187d:	8b 03                	mov    (%ebx),%eax
8010187f:	e8 bc f8 ff ff       	call   80101140 <bfree>
      ip->addrs[i] = 0;
80101884:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010188a:	eb e4                	jmp    80101870 <iput+0x90>
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101890:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101896:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101899:	85 c0                	test   %eax,%eax
8010189b:	75 33                	jne    801018d0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010189d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801018a0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018a7:	53                   	push   %ebx
801018a8:	e8 53 fd ff ff       	call   80101600 <iupdate>
      ip->type = 0;
801018ad:	31 c0                	xor    %eax,%eax
801018af:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018b3:	89 1c 24             	mov    %ebx,(%esp)
801018b6:	e8 45 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018bb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018c2:	83 c4 10             	add    $0x10,%esp
801018c5:	e9 3c ff ff ff       	jmp    80101806 <iput+0x26>
801018ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d0:	83 ec 08             	sub    $0x8,%esp
801018d3:	50                   	push   %eax
801018d4:	ff 33                	pushl  (%ebx)
801018d6:	e8 f5 e7 ff ff       	call   801000d0 <bread>
801018db:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018e1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018e7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ea:	83 c4 10             	add    $0x10,%esp
801018ed:	89 cf                	mov    %ecx,%edi
801018ef:	eb 0e                	jmp    801018ff <iput+0x11f>
801018f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018f8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018fb:	39 fe                	cmp    %edi,%esi
801018fd:	74 0f                	je     8010190e <iput+0x12e>
      if(a[j])
801018ff:	8b 16                	mov    (%esi),%edx
80101901:	85 d2                	test   %edx,%edx
80101903:	74 f3                	je     801018f8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101905:	8b 03                	mov    (%ebx),%eax
80101907:	e8 34 f8 ff ff       	call   80101140 <bfree>
8010190c:	eb ea                	jmp    801018f8 <iput+0x118>
    brelse(bp);
8010190e:	83 ec 0c             	sub    $0xc,%esp
80101911:	ff 75 e4             	pushl  -0x1c(%ebp)
80101914:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101917:	e8 c4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010191c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101922:	8b 03                	mov    (%ebx),%eax
80101924:	e8 17 f8 ff ff       	call   80101140 <bfree>
    ip->addrs[NDIRECT] = 0;
80101929:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101930:	00 00 00 
80101933:	83 c4 10             	add    $0x10,%esp
80101936:	e9 62 ff ff ff       	jmp    8010189d <iput+0xbd>
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <iunlockput>:
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	53                   	push   %ebx
80101944:	83 ec 10             	sub    $0x10,%esp
80101947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010194a:	53                   	push   %ebx
8010194b:	e8 40 fe ff ff       	call   80101790 <iunlock>
  iput(ip);
80101950:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101953:	83 c4 10             	add    $0x10,%esp
}
80101956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101959:	c9                   	leave  
  iput(ip);
8010195a:	e9 81 fe ff ff       	jmp    801017e0 <iput>
8010195f:	90                   	nop

80101960 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	8b 55 08             	mov    0x8(%ebp),%edx
80101966:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101969:	8b 0a                	mov    (%edx),%ecx
8010196b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010196e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101971:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101974:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101978:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010197b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010197f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101983:	8b 52 58             	mov    0x58(%edx),%edx
80101986:	89 50 10             	mov    %edx,0x10(%eax)
}
80101989:	5d                   	pop    %ebp
8010198a:	c3                   	ret    
8010198b:	90                   	nop
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101990 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	57                   	push   %edi
80101994:	56                   	push   %esi
80101995:	53                   	push   %ebx
80101996:	83 ec 1c             	sub    $0x1c,%esp
80101999:	8b 45 08             	mov    0x8(%ebp),%eax
8010199c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010199f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019a2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801019a7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801019aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019ad:	8b 75 10             	mov    0x10(%ebp),%esi
801019b0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019b3:	0f 84 a7 00 00 00    	je     80101a60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019bc:	8b 40 58             	mov    0x58(%eax),%eax
801019bf:	39 c6                	cmp    %eax,%esi
801019c1:	0f 87 ba 00 00 00    	ja     80101a81 <readi+0xf1>
801019c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ca:	89 f9                	mov    %edi,%ecx
801019cc:	01 f1                	add    %esi,%ecx
801019ce:	0f 82 ad 00 00 00    	jb     80101a81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019d4:	89 c2                	mov    %eax,%edx
801019d6:	29 f2                	sub    %esi,%edx
801019d8:	39 c8                	cmp    %ecx,%eax
801019da:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019dd:	31 ff                	xor    %edi,%edi
801019df:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e4:	74 6c                	je     80101a52 <readi+0xc2>
801019e6:	8d 76 00             	lea    0x0(%esi),%esi
801019e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019f0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019f3:	89 f2                	mov    %esi,%edx
801019f5:	c1 ea 09             	shr    $0x9,%edx
801019f8:	89 d8                	mov    %ebx,%eax
801019fa:	e8 91 f9 ff ff       	call   80101390 <bmap>
801019ff:	83 ec 08             	sub    $0x8,%esp
80101a02:	50                   	push   %eax
80101a03:	ff 33                	pushl  (%ebx)
80101a05:	e8 c6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a0d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0f:	89 f0                	mov    %esi,%eax
80101a11:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a16:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a1b:	83 c4 0c             	add    $0xc,%esp
80101a1e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a20:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a24:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a27:	29 fb                	sub    %edi,%ebx
80101a29:	39 d9                	cmp    %ebx,%ecx
80101a2b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a2e:	53                   	push   %ebx
80101a2f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a30:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a32:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a35:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a37:	e8 24 31 00 00       	call   80104b60 <memmove>
    brelse(bp);
80101a3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a3f:	89 14 24             	mov    %edx,(%esp)
80101a42:	e8 99 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a4a:	83 c4 10             	add    $0x10,%esp
80101a4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a50:	77 9e                	ja     801019f0 <readi+0x60>
  }
  return n;
80101a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a58:	5b                   	pop    %ebx
80101a59:	5e                   	pop    %esi
80101a5a:	5f                   	pop    %edi
80101a5b:	5d                   	pop    %ebp
80101a5c:	c3                   	ret    
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a64:	66 83 f8 09          	cmp    $0x9,%ax
80101a68:	77 17                	ja     80101a81 <readi+0xf1>
80101a6a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101a71:	85 c0                	test   %eax,%eax
80101a73:	74 0c                	je     80101a81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a7b:	5b                   	pop    %ebx
80101a7c:	5e                   	pop    %esi
80101a7d:	5f                   	pop    %edi
80101a7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a7f:	ff e0                	jmp    *%eax
      return -1;
80101a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a86:	eb cd                	jmp    80101a55 <readi+0xc5>
80101a88:	90                   	nop
80101a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aa7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aaa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aad:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 b7 00 00 00    	je     80101b70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	39 70 58             	cmp    %esi,0x58(%eax)
80101abf:	0f 82 eb 00 00 00    	jb     80101bb0 <writei+0x120>
80101ac5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ac8:	31 d2                	xor    %edx,%edx
80101aca:	89 f8                	mov    %edi,%eax
80101acc:	01 f0                	add    %esi,%eax
80101ace:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ad1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ad6:	0f 87 d4 00 00 00    	ja     80101bb0 <writei+0x120>
80101adc:	85 d2                	test   %edx,%edx
80101ade:	0f 85 cc 00 00 00    	jne    80101bb0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae4:	85 ff                	test   %edi,%edi
80101ae6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aed:	74 72                	je     80101b61 <writei+0xd1>
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 f8                	mov    %edi,%eax
80101afa:	e8 91 f8 ff ff       	call   80101390 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 37                	pushl  (%edi)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b0d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b12:	89 f0                	mov    %esi,%eax
80101b14:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b19:	83 c4 0c             	add    $0xc,%esp
80101b1c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b21:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b23:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b27:	39 d9                	cmp    %ebx,%ecx
80101b29:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b2c:	53                   	push   %ebx
80101b2d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b30:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b32:	50                   	push   %eax
80101b33:	e8 28 30 00 00       	call   80104b60 <memmove>
    log_write(bp);
80101b38:	89 3c 24             	mov    %edi,(%esp)
80101b3b:	e8 70 12 00 00       	call   80102db0 <log_write>
    brelse(bp);
80101b40:	89 3c 24             	mov    %edi,(%esp)
80101b43:	e8 98 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b4b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b4e:	83 c4 10             	add    $0x10,%esp
80101b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b57:	77 97                	ja     80101af0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b5f:	77 37                	ja     80101b98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b67:	5b                   	pop    %ebx
80101b68:	5e                   	pop    %esi
80101b69:	5f                   	pop    %edi
80101b6a:	5d                   	pop    %ebp
80101b6b:	c3                   	ret    
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 36                	ja     80101bb0 <writei+0x120>
80101b7a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 2b                	je     80101bb0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b8f:	ff e0                	jmp    *%eax
80101b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ba1:	50                   	push   %eax
80101ba2:	e8 59 fa ff ff       	call   80101600 <iupdate>
80101ba7:	83 c4 10             	add    $0x10,%esp
80101baa:	eb b5                	jmp    80101b61 <writei+0xd1>
80101bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bb5:	eb ad                	jmp    80101b64 <writei+0xd4>
80101bb7:	89 f6                	mov    %esi,%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bc6:	6a 0e                	push   $0xe
80101bc8:	ff 75 0c             	pushl  0xc(%ebp)
80101bcb:	ff 75 08             	pushl  0x8(%ebp)
80101bce:	e8 fd 2f 00 00       	call   80104bd0 <strncmp>
}
80101bd3:	c9                   	leave  
80101bd4:	c3                   	ret    
80101bd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101be0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 1c             	sub    $0x1c,%esp
80101be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bf1:	0f 85 85 00 00 00    	jne    80101c7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bfa:	31 ff                	xor    %edi,%edi
80101bfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bff:	85 d2                	test   %edx,%edx
80101c01:	74 3e                	je     80101c41 <dirlookup+0x61>
80101c03:	90                   	nop
80101c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c08:	6a 10                	push   $0x10
80101c0a:	57                   	push   %edi
80101c0b:	56                   	push   %esi
80101c0c:	53                   	push   %ebx
80101c0d:	e8 7e fd ff ff       	call   80101990 <readi>
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	83 f8 10             	cmp    $0x10,%eax
80101c18:	75 55                	jne    80101c6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c1f:	74 18                	je     80101c39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c21:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c24:	83 ec 04             	sub    $0x4,%esp
80101c27:	6a 0e                	push   $0xe
80101c29:	50                   	push   %eax
80101c2a:	ff 75 0c             	pushl  0xc(%ebp)
80101c2d:	e8 9e 2f 00 00       	call   80104bd0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c32:	83 c4 10             	add    $0x10,%esp
80101c35:	85 c0                	test   %eax,%eax
80101c37:	74 17                	je     80101c50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c39:	83 c7 10             	add    $0x10,%edi
80101c3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c3f:	72 c7                	jb     80101c08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c44:	31 c0                	xor    %eax,%eax
}
80101c46:	5b                   	pop    %ebx
80101c47:	5e                   	pop    %esi
80101c48:	5f                   	pop    %edi
80101c49:	5d                   	pop    %ebp
80101c4a:	c3                   	ret    
80101c4b:	90                   	nop
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c50:	8b 45 10             	mov    0x10(%ebp),%eax
80101c53:	85 c0                	test   %eax,%eax
80101c55:	74 05                	je     80101c5c <dirlookup+0x7c>
        *poff = off;
80101c57:	8b 45 10             	mov    0x10(%ebp),%eax
80101c5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c60:	8b 03                	mov    (%ebx),%eax
80101c62:	e8 59 f6 ff ff       	call   801012c0 <iget>
}
80101c67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6a:	5b                   	pop    %ebx
80101c6b:	5e                   	pop    %esi
80101c6c:	5f                   	pop    %edi
80101c6d:	5d                   	pop    %ebp
80101c6e:	c3                   	ret    
      panic("dirlookup read");
80101c6f:	83 ec 0c             	sub    $0xc,%esp
80101c72:	68 59 77 10 80       	push   $0x80107759
80101c77:	e8 14 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c7c:	83 ec 0c             	sub    $0xc,%esp
80101c7f:	68 47 77 10 80       	push   $0x80107747
80101c84:	e8 07 e7 ff ff       	call   80100390 <panic>
80101c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	56                   	push   %esi
80101c95:	53                   	push   %ebx
80101c96:	89 cf                	mov    %ecx,%edi
80101c98:	89 c3                	mov    %eax,%ebx
80101c9a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c9d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ca0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101ca3:	0f 84 67 01 00 00    	je     80101e10 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ca9:	e8 72 1c 00 00       	call   80103920 <myproc>
  acquire(&icache.lock);
80101cae:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cb1:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101cb4:	68 e0 19 11 80       	push   $0x801119e0
80101cb9:	e8 e2 2c 00 00       	call   801049a0 <acquire>
  ip->ref++;
80101cbe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc2:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101cc9:	e8 92 2d 00 00       	call   80104a60 <release>
80101cce:	83 c4 10             	add    $0x10,%esp
80101cd1:	eb 08                	jmp    80101cdb <namex+0x4b>
80101cd3:	90                   	nop
80101cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cdb:	0f b6 03             	movzbl (%ebx),%eax
80101cde:	3c 2f                	cmp    $0x2f,%al
80101ce0:	74 f6                	je     80101cd8 <namex+0x48>
  if(*path == 0)
80101ce2:	84 c0                	test   %al,%al
80101ce4:	0f 84 ee 00 00 00    	je     80101dd8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cea:	0f b6 03             	movzbl (%ebx),%eax
80101ced:	3c 2f                	cmp    $0x2f,%al
80101cef:	0f 84 b3 00 00 00    	je     80101da8 <namex+0x118>
80101cf5:	84 c0                	test   %al,%al
80101cf7:	89 da                	mov    %ebx,%edx
80101cf9:	75 09                	jne    80101d04 <namex+0x74>
80101cfb:	e9 a8 00 00 00       	jmp    80101da8 <namex+0x118>
80101d00:	84 c0                	test   %al,%al
80101d02:	74 0a                	je     80101d0e <namex+0x7e>
    path++;
80101d04:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d07:	0f b6 02             	movzbl (%edx),%eax
80101d0a:	3c 2f                	cmp    $0x2f,%al
80101d0c:	75 f2                	jne    80101d00 <namex+0x70>
80101d0e:	89 d1                	mov    %edx,%ecx
80101d10:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d12:	83 f9 0d             	cmp    $0xd,%ecx
80101d15:	0f 8e 91 00 00 00    	jle    80101dac <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d1b:	83 ec 04             	sub    $0x4,%esp
80101d1e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d21:	6a 0e                	push   $0xe
80101d23:	53                   	push   %ebx
80101d24:	57                   	push   %edi
80101d25:	e8 36 2e 00 00       	call   80104b60 <memmove>
    path++;
80101d2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d2d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d30:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d32:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d35:	75 11                	jne    80101d48 <namex+0xb8>
80101d37:	89 f6                	mov    %esi,%esi
80101d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d40:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d46:	74 f8                	je     80101d40 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d48:	83 ec 0c             	sub    $0xc,%esp
80101d4b:	56                   	push   %esi
80101d4c:	e8 5f f9 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101d51:	83 c4 10             	add    $0x10,%esp
80101d54:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d59:	0f 85 91 00 00 00    	jne    80101df0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d62:	85 d2                	test   %edx,%edx
80101d64:	74 09                	je     80101d6f <namex+0xdf>
80101d66:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d69:	0f 84 b7 00 00 00    	je     80101e26 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d6f:	83 ec 04             	sub    $0x4,%esp
80101d72:	6a 00                	push   $0x0
80101d74:	57                   	push   %edi
80101d75:	56                   	push   %esi
80101d76:	e8 65 fe ff ff       	call   80101be0 <dirlookup>
80101d7b:	83 c4 10             	add    $0x10,%esp
80101d7e:	85 c0                	test   %eax,%eax
80101d80:	74 6e                	je     80101df0 <namex+0x160>
  iunlock(ip);
80101d82:	83 ec 0c             	sub    $0xc,%esp
80101d85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d88:	56                   	push   %esi
80101d89:	e8 02 fa ff ff       	call   80101790 <iunlock>
  iput(ip);
80101d8e:	89 34 24             	mov    %esi,(%esp)
80101d91:	e8 4a fa ff ff       	call   801017e0 <iput>
80101d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d99:	83 c4 10             	add    $0x10,%esp
80101d9c:	89 c6                	mov    %eax,%esi
80101d9e:	e9 38 ff ff ff       	jmp    80101cdb <namex+0x4b>
80101da3:	90                   	nop
80101da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101da8:	89 da                	mov    %ebx,%edx
80101daa:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101dac:	83 ec 04             	sub    $0x4,%esp
80101daf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101db5:	51                   	push   %ecx
80101db6:	53                   	push   %ebx
80101db7:	57                   	push   %edi
80101db8:	e8 a3 2d 00 00       	call   80104b60 <memmove>
    name[len] = 0;
80101dbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dc3:	83 c4 10             	add    $0x10,%esp
80101dc6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dca:	89 d3                	mov    %edx,%ebx
80101dcc:	e9 61 ff ff ff       	jmp    80101d32 <namex+0xa2>
80101dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ddb:	85 c0                	test   %eax,%eax
80101ddd:	75 5d                	jne    80101e3c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ddf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de2:	89 f0                	mov    %esi,%eax
80101de4:	5b                   	pop    %ebx
80101de5:	5e                   	pop    %esi
80101de6:	5f                   	pop    %edi
80101de7:	5d                   	pop    %ebp
80101de8:	c3                   	ret    
80101de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101df0:	83 ec 0c             	sub    $0xc,%esp
80101df3:	56                   	push   %esi
80101df4:	e8 97 f9 ff ff       	call   80101790 <iunlock>
  iput(ip);
80101df9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dfc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dfe:	e8 dd f9 ff ff       	call   801017e0 <iput>
      return 0;
80101e03:	83 c4 10             	add    $0x10,%esp
}
80101e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e09:	89 f0                	mov    %esi,%eax
80101e0b:	5b                   	pop    %ebx
80101e0c:	5e                   	pop    %esi
80101e0d:	5f                   	pop    %edi
80101e0e:	5d                   	pop    %ebp
80101e0f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e10:	ba 01 00 00 00       	mov    $0x1,%edx
80101e15:	b8 01 00 00 00       	mov    $0x1,%eax
80101e1a:	e8 a1 f4 ff ff       	call   801012c0 <iget>
80101e1f:	89 c6                	mov    %eax,%esi
80101e21:	e9 b5 fe ff ff       	jmp    80101cdb <namex+0x4b>
      iunlock(ip);
80101e26:	83 ec 0c             	sub    $0xc,%esp
80101e29:	56                   	push   %esi
80101e2a:	e8 61 f9 ff ff       	call   80101790 <iunlock>
      return ip;
80101e2f:	83 c4 10             	add    $0x10,%esp
}
80101e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e35:	89 f0                	mov    %esi,%eax
80101e37:	5b                   	pop    %ebx
80101e38:	5e                   	pop    %esi
80101e39:	5f                   	pop    %edi
80101e3a:	5d                   	pop    %ebp
80101e3b:	c3                   	ret    
    iput(ip);
80101e3c:	83 ec 0c             	sub    $0xc,%esp
80101e3f:	56                   	push   %esi
    return 0;
80101e40:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e42:	e8 99 f9 ff ff       	call   801017e0 <iput>
    return 0;
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	eb 93                	jmp    80101ddf <namex+0x14f>
80101e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e50 <dirlink>:
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	83 ec 20             	sub    $0x20,%esp
80101e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e5c:	6a 00                	push   $0x0
80101e5e:	ff 75 0c             	pushl  0xc(%ebp)
80101e61:	53                   	push   %ebx
80101e62:	e8 79 fd ff ff       	call   80101be0 <dirlookup>
80101e67:	83 c4 10             	add    $0x10,%esp
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	75 67                	jne    80101ed5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e6e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e71:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e74:	85 ff                	test   %edi,%edi
80101e76:	74 29                	je     80101ea1 <dirlink+0x51>
80101e78:	31 ff                	xor    %edi,%edi
80101e7a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e7d:	eb 09                	jmp    80101e88 <dirlink+0x38>
80101e7f:	90                   	nop
80101e80:	83 c7 10             	add    $0x10,%edi
80101e83:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e86:	73 19                	jae    80101ea1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e88:	6a 10                	push   $0x10
80101e8a:	57                   	push   %edi
80101e8b:	56                   	push   %esi
80101e8c:	53                   	push   %ebx
80101e8d:	e8 fe fa ff ff       	call   80101990 <readi>
80101e92:	83 c4 10             	add    $0x10,%esp
80101e95:	83 f8 10             	cmp    $0x10,%eax
80101e98:	75 4e                	jne    80101ee8 <dirlink+0x98>
    if(de.inum == 0)
80101e9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e9f:	75 df                	jne    80101e80 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101ea1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ea4:	83 ec 04             	sub    $0x4,%esp
80101ea7:	6a 0e                	push   $0xe
80101ea9:	ff 75 0c             	pushl  0xc(%ebp)
80101eac:	50                   	push   %eax
80101ead:	e8 7e 2d 00 00       	call   80104c30 <strncpy>
  de.inum = inum;
80101eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eb5:	6a 10                	push   $0x10
80101eb7:	57                   	push   %edi
80101eb8:	56                   	push   %esi
80101eb9:	53                   	push   %ebx
  de.inum = inum;
80101eba:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ebe:	e8 cd fb ff ff       	call   80101a90 <writei>
80101ec3:	83 c4 20             	add    $0x20,%esp
80101ec6:	83 f8 10             	cmp    $0x10,%eax
80101ec9:	75 2a                	jne    80101ef5 <dirlink+0xa5>
  return 0;
80101ecb:	31 c0                	xor    %eax,%eax
}
80101ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
    iput(ip);
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	50                   	push   %eax
80101ed9:	e8 02 f9 ff ff       	call   801017e0 <iput>
    return -1;
80101ede:	83 c4 10             	add    $0x10,%esp
80101ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ee6:	eb e5                	jmp    80101ecd <dirlink+0x7d>
      panic("dirlink read");
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	68 68 77 10 80       	push   $0x80107768
80101ef0:	e8 9b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ef5:	83 ec 0c             	sub    $0xc,%esp
80101ef8:	68 2a 7e 10 80       	push   $0x80107e2a
80101efd:	e8 8e e4 ff ff       	call   80100390 <panic>
80101f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <namei>:

struct inode*
namei(char *path)
{
80101f10:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f11:	31 d2                	xor    %edx,%edx
{
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f1e:	e8 6d fd ff ff       	call   80101c90 <namex>
}
80101f23:	c9                   	leave  
80101f24:	c3                   	ret    
80101f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f30:	55                   	push   %ebp
  return namex(path, 1, name);
80101f31:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f36:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f3e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f3f:	e9 4c fd ff ff       	jmp    80101c90 <namex>
80101f44:	66 90                	xchg   %ax,%ax
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	66 90                	xchg   %ax,%ax
80101f4a:	66 90                	xchg   %ax,%ax
80101f4c:	66 90                	xchg   %ax,%ax
80101f4e:	66 90                	xchg   %ax,%ax

80101f50 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	57                   	push   %edi
80101f54:	56                   	push   %esi
80101f55:	53                   	push   %ebx
80101f56:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f59:	85 c0                	test   %eax,%eax
80101f5b:	0f 84 b4 00 00 00    	je     80102015 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f61:	8b 58 08             	mov    0x8(%eax),%ebx
80101f64:	89 c6                	mov    %eax,%esi
80101f66:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f6c:	0f 87 96 00 00 00    	ja     80102008 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f72:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f77:	89 f6                	mov    %esi,%esi
80101f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f80:	89 ca                	mov    %ecx,%edx
80101f82:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f83:	83 e0 c0             	and    $0xffffffc0,%eax
80101f86:	3c 40                	cmp    $0x40,%al
80101f88:	75 f6                	jne    80101f80 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f8a:	31 ff                	xor    %edi,%edi
80101f8c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f91:	89 f8                	mov    %edi,%eax
80101f93:	ee                   	out    %al,(%dx)
80101f94:	b8 01 00 00 00       	mov    $0x1,%eax
80101f99:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f9e:	ee                   	out    %al,(%dx)
80101f9f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101fa4:	89 d8                	mov    %ebx,%eax
80101fa6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fa7:	89 d8                	mov    %ebx,%eax
80101fa9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101fae:	c1 f8 08             	sar    $0x8,%eax
80101fb1:	ee                   	out    %al,(%dx)
80101fb2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fb7:	89 f8                	mov    %edi,%eax
80101fb9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fba:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fbe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fc3:	c1 e0 04             	shl    $0x4,%eax
80101fc6:	83 e0 10             	and    $0x10,%eax
80101fc9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fcc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fcd:	f6 06 04             	testb  $0x4,(%esi)
80101fd0:	75 16                	jne    80101fe8 <idestart+0x98>
80101fd2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fd7:	89 ca                	mov    %ecx,%edx
80101fd9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fdd:	5b                   	pop    %ebx
80101fde:	5e                   	pop    %esi
80101fdf:	5f                   	pop    %edi
80101fe0:	5d                   	pop    %ebp
80101fe1:	c3                   	ret    
80101fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fe8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fed:	89 ca                	mov    %ecx,%edx
80101fef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101ff0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101ff5:	83 c6 5c             	add    $0x5c,%esi
80101ff8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ffd:	fc                   	cld    
80101ffe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102000:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102003:	5b                   	pop    %ebx
80102004:	5e                   	pop    %esi
80102005:	5f                   	pop    %edi
80102006:	5d                   	pop    %ebp
80102007:	c3                   	ret    
    panic("incorrect blockno");
80102008:	83 ec 0c             	sub    $0xc,%esp
8010200b:	68 d4 77 10 80       	push   $0x801077d4
80102010:	e8 7b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102015:	83 ec 0c             	sub    $0xc,%esp
80102018:	68 cb 77 10 80       	push   $0x801077cb
8010201d:	e8 6e e3 ff ff       	call   80100390 <panic>
80102022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <ideinit>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102036:	68 e6 77 10 80       	push   $0x801077e6
8010203b:	68 80 b5 10 80       	push   $0x8010b580
80102040:	e8 1b 28 00 00       	call   80104860 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102045:	58                   	pop    %eax
80102046:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010204b:	5a                   	pop    %edx
8010204c:	83 e8 01             	sub    $0x1,%eax
8010204f:	50                   	push   %eax
80102050:	6a 0e                	push   $0xe
80102052:	e8 b9 02 00 00       	call   80102310 <ioapicenable>
80102057:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010205a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205f:	90                   	nop
80102060:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102061:	83 e0 c0             	and    $0xffffffc0,%eax
80102064:	3c 40                	cmp    $0x40,%al
80102066:	75 f8                	jne    80102060 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102068:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010206d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102072:	ee                   	out    %al,(%dx)
80102073:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102078:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010207d:	eb 06                	jmp    80102085 <ideinit+0x55>
8010207f:	90                   	nop
  for(i=0; i<1000; i++){
80102080:	83 e9 01             	sub    $0x1,%ecx
80102083:	74 0f                	je     80102094 <ideinit+0x64>
80102085:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102086:	84 c0                	test   %al,%al
80102088:	74 f6                	je     80102080 <ideinit+0x50>
      havedisk1 = 1;
8010208a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102091:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102094:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102099:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010209e:	ee                   	out    %al,(%dx)
}
8010209f:	c9                   	leave  
801020a0:	c3                   	ret    
801020a1:	eb 0d                	jmp    801020b0 <ideintr>
801020a3:	90                   	nop
801020a4:	90                   	nop
801020a5:	90                   	nop
801020a6:	90                   	nop
801020a7:	90                   	nop
801020a8:	90                   	nop
801020a9:	90                   	nop
801020aa:	90                   	nop
801020ab:	90                   	nop
801020ac:	90                   	nop
801020ad:	90                   	nop
801020ae:	90                   	nop
801020af:	90                   	nop

801020b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	57                   	push   %edi
801020b4:	56                   	push   %esi
801020b5:	53                   	push   %ebx
801020b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020b9:	68 80 b5 10 80       	push   $0x8010b580
801020be:	e8 dd 28 00 00       	call   801049a0 <acquire>

  if((b = idequeue) == 0){
801020c3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020c9:	83 c4 10             	add    $0x10,%esp
801020cc:	85 db                	test   %ebx,%ebx
801020ce:	74 67                	je     80102137 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020d0:	8b 43 58             	mov    0x58(%ebx),%eax
801020d3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020d8:	8b 3b                	mov    (%ebx),%edi
801020da:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020e0:	75 31                	jne    80102113 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020e7:	89 f6                	mov    %esi,%esi
801020e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f1:	89 c6                	mov    %eax,%esi
801020f3:	83 e6 c0             	and    $0xffffffc0,%esi
801020f6:	89 f1                	mov    %esi,%ecx
801020f8:	80 f9 40             	cmp    $0x40,%cl
801020fb:	75 f3                	jne    801020f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020fd:	a8 21                	test   $0x21,%al
801020ff:	75 12                	jne    80102113 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102101:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102104:	b9 80 00 00 00       	mov    $0x80,%ecx
80102109:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010210e:	fc                   	cld    
8010210f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102111:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102113:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102116:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102119:	89 f9                	mov    %edi,%ecx
8010211b:	83 c9 02             	or     $0x2,%ecx
8010211e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102120:	53                   	push   %ebx
80102121:	e8 0a 21 00 00       	call   80104230 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102126:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010212b:	83 c4 10             	add    $0x10,%esp
8010212e:	85 c0                	test   %eax,%eax
80102130:	74 05                	je     80102137 <ideintr+0x87>
    idestart(idequeue);
80102132:	e8 19 fe ff ff       	call   80101f50 <idestart>
    release(&idelock);
80102137:	83 ec 0c             	sub    $0xc,%esp
8010213a:	68 80 b5 10 80       	push   $0x8010b580
8010213f:	e8 1c 29 00 00       	call   80104a60 <release>

  release(&idelock);
}
80102144:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102147:	5b                   	pop    %ebx
80102148:	5e                   	pop    %esi
80102149:	5f                   	pop    %edi
8010214a:	5d                   	pop    %ebp
8010214b:	c3                   	ret    
8010214c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102150 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	53                   	push   %ebx
80102154:	83 ec 10             	sub    $0x10,%esp
80102157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010215a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010215d:	50                   	push   %eax
8010215e:	e8 ad 26 00 00       	call   80104810 <holdingsleep>
80102163:	83 c4 10             	add    $0x10,%esp
80102166:	85 c0                	test   %eax,%eax
80102168:	0f 84 c6 00 00 00    	je     80102234 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 e0 06             	and    $0x6,%eax
80102173:	83 f8 02             	cmp    $0x2,%eax
80102176:	0f 84 ab 00 00 00    	je     80102227 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010217c:	8b 53 04             	mov    0x4(%ebx),%edx
8010217f:	85 d2                	test   %edx,%edx
80102181:	74 0d                	je     80102190 <iderw+0x40>
80102183:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102188:	85 c0                	test   %eax,%eax
8010218a:	0f 84 b1 00 00 00    	je     80102241 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102190:	83 ec 0c             	sub    $0xc,%esp
80102193:	68 80 b5 10 80       	push   $0x8010b580
80102198:	e8 03 28 00 00       	call   801049a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801021a3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801021a6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ad:	85 d2                	test   %edx,%edx
801021af:	75 09                	jne    801021ba <iderw+0x6a>
801021b1:	eb 6d                	jmp    80102220 <iderw+0xd0>
801021b3:	90                   	nop
801021b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021b8:	89 c2                	mov    %eax,%edx
801021ba:	8b 42 58             	mov    0x58(%edx),%eax
801021bd:	85 c0                	test   %eax,%eax
801021bf:	75 f7                	jne    801021b8 <iderw+0x68>
801021c1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021c4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021c6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801021cc:	74 42                	je     80102210 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 e0 06             	and    $0x6,%eax
801021d3:	83 f8 02             	cmp    $0x2,%eax
801021d6:	74 23                	je     801021fb <iderw+0xab>
801021d8:	90                   	nop
801021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021e0:	83 ec 08             	sub    $0x8,%esp
801021e3:	68 80 b5 10 80       	push   $0x8010b580
801021e8:	53                   	push   %ebx
801021e9:	e8 92 1f 00 00       	call   80104180 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ee:	8b 03                	mov    (%ebx),%eax
801021f0:	83 c4 10             	add    $0x10,%esp
801021f3:	83 e0 06             	and    $0x6,%eax
801021f6:	83 f8 02             	cmp    $0x2,%eax
801021f9:	75 e5                	jne    801021e0 <iderw+0x90>
  }


  release(&idelock);
801021fb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102205:	c9                   	leave  
  release(&idelock);
80102206:	e9 55 28 00 00       	jmp    80104a60 <release>
8010220b:	90                   	nop
8010220c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102210:	89 d8                	mov    %ebx,%eax
80102212:	e8 39 fd ff ff       	call   80101f50 <idestart>
80102217:	eb b5                	jmp    801021ce <iderw+0x7e>
80102219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102220:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102225:	eb 9d                	jmp    801021c4 <iderw+0x74>
    panic("iderw: nothing to do");
80102227:	83 ec 0c             	sub    $0xc,%esp
8010222a:	68 00 78 10 80       	push   $0x80107800
8010222f:	e8 5c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102234:	83 ec 0c             	sub    $0xc,%esp
80102237:	68 ea 77 10 80       	push   $0x801077ea
8010223c:	e8 4f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102241:	83 ec 0c             	sub    $0xc,%esp
80102244:	68 15 78 10 80       	push   $0x80107815
80102249:	e8 42 e1 ff ff       	call   80100390 <panic>

8010224e <injected_call_beginning>:
.globl injected_call_beginning
.globl injected_call_end


injected_call_beginning: #this lets me save the address of the beginning of the call that I want to later inject
    movl $SYS_sigret, %eax
8010224e:	b8 18 00 00 00       	mov    $0x18,%eax
    int $T_SYSCALL
80102253:	cd 40                	int    $0x40

80102255 <injected_call_end>:
80102255:	66 90                	xchg   %ax,%ax
80102257:	66 90                	xchg   %ax,%ax
80102259:	66 90                	xchg   %ax,%ax
8010225b:	66 90                	xchg   %ax,%ax
8010225d:	66 90                	xchg   %ax,%ax
8010225f:	90                   	nop

80102260 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102260:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102261:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102268:	00 c0 fe 
{
8010226b:	89 e5                	mov    %esp,%ebp
8010226d:	56                   	push   %esi
8010226e:	53                   	push   %ebx
  ioapic->reg = reg;
8010226f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102276:	00 00 00 
  return ioapic->data;
80102279:	a1 34 36 11 80       	mov    0x80113634,%eax
8010227e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102281:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102287:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010228d:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102294:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102297:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010229a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010229d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801022a0:	39 c2                	cmp    %eax,%edx
801022a2:	74 16                	je     801022ba <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022a4:	83 ec 0c             	sub    $0xc,%esp
801022a7:	68 34 78 10 80       	push   $0x80107834
801022ac:	e8 af e3 ff ff       	call   80100660 <cprintf>
801022b1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	83 c3 21             	add    $0x21,%ebx
{
801022bd:	ba 10 00 00 00       	mov    $0x10,%edx
801022c2:	b8 20 00 00 00       	mov    $0x20,%eax
801022c7:	89 f6                	mov    %esi,%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022d0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022d2:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022d8:	89 c6                	mov    %eax,%esi
801022da:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022e0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022e3:	89 71 10             	mov    %esi,0x10(%ecx)
801022e6:	8d 72 01             	lea    0x1(%edx),%esi
801022e9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ec:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ee:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022f0:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801022f6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022fd:	75 d1                	jne    801022d0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102302:	5b                   	pop    %ebx
80102303:	5e                   	pop    %esi
80102304:	5d                   	pop    %ebp
80102305:	c3                   	ret    
80102306:	8d 76 00             	lea    0x0(%esi),%esi
80102309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102310 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102310:	55                   	push   %ebp
  ioapic->reg = reg;
80102311:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
80102317:	89 e5                	mov    %esp,%ebp
80102319:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010231c:	8d 50 20             	lea    0x20(%eax),%edx
8010231f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102323:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102325:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010232b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010232e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102331:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102334:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102336:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010233b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010233e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102341:	5d                   	pop    %ebp
80102342:	c3                   	ret    
80102343:	66 90                	xchg   %ax,%ax
80102345:	66 90                	xchg   %ax,%ax
80102347:	66 90                	xchg   %ax,%ax
80102349:	66 90                	xchg   %ax,%ax
8010234b:	66 90                	xchg   %ax,%ax
8010234d:	66 90                	xchg   %ax,%ax
8010234f:	90                   	nop

80102350 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	53                   	push   %ebx
80102354:	83 ec 04             	sub    $0x4,%esp
80102357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010235a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102360:	75 70                	jne    801023d2 <kfree+0x82>
80102362:	81 fb a8 89 11 80    	cmp    $0x801189a8,%ebx
80102368:	72 68                	jb     801023d2 <kfree+0x82>
8010236a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102370:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102375:	77 5b                	ja     801023d2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102377:	83 ec 04             	sub    $0x4,%esp
8010237a:	68 00 10 00 00       	push   $0x1000
8010237f:	6a 01                	push   $0x1
80102381:	53                   	push   %ebx
80102382:	e8 29 27 00 00       	call   80104ab0 <memset>
  if(kmem.use_lock)
80102387:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	85 d2                	test   %edx,%edx
80102392:	75 2c                	jne    801023c0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102394:	a1 78 36 11 80       	mov    0x80113678,%eax
80102399:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010239b:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801023a0:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801023a6:	85 c0                	test   %eax,%eax
801023a8:	75 06                	jne    801023b0 <kfree+0x60>
    release(&kmem.lock);
}
801023aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ad:	c9                   	leave  
801023ae:	c3                   	ret    
801023af:	90                   	nop
    release(&kmem.lock);
801023b0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801023b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ba:	c9                   	leave  
    release(&kmem.lock);
801023bb:	e9 a0 26 00 00       	jmp    80104a60 <release>
    acquire(&kmem.lock);
801023c0:	83 ec 0c             	sub    $0xc,%esp
801023c3:	68 40 36 11 80       	push   $0x80113640
801023c8:	e8 d3 25 00 00       	call   801049a0 <acquire>
801023cd:	83 c4 10             	add    $0x10,%esp
801023d0:	eb c2                	jmp    80102394 <kfree+0x44>
    panic("kfree");
801023d2:	83 ec 0c             	sub    $0xc,%esp
801023d5:	68 66 78 10 80       	push   $0x80107866
801023da:	e8 b1 df ff ff       	call   80100390 <panic>
801023df:	90                   	nop

801023e0 <freerange>:
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801023f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023fd:	39 de                	cmp    %ebx,%esi
801023ff:	72 23                	jb     80102424 <freerange+0x44>
80102401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102408:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010240e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102411:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102417:	50                   	push   %eax
80102418:	e8 33 ff ff ff       	call   80102350 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	39 f3                	cmp    %esi,%ebx
80102422:	76 e4                	jbe    80102408 <freerange+0x28>
}
80102424:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102427:	5b                   	pop    %ebx
80102428:	5e                   	pop    %esi
80102429:	5d                   	pop    %ebp
8010242a:	c3                   	ret    
8010242b:	90                   	nop
8010242c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102430 <kinit1>:
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx
80102435:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102438:	83 ec 08             	sub    $0x8,%esp
8010243b:	68 6c 78 10 80       	push   $0x8010786c
80102440:	68 40 36 11 80       	push   $0x80113640
80102445:	e8 16 24 00 00       	call   80104860 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010244a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010244d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102450:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102457:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010245a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102460:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102466:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010246c:	39 de                	cmp    %ebx,%esi
8010246e:	72 1c                	jb     8010248c <kinit1+0x5c>
    kfree(p);
80102470:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102476:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102479:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010247f:	50                   	push   %eax
80102480:	e8 cb fe ff ff       	call   80102350 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102485:	83 c4 10             	add    $0x10,%esp
80102488:	39 de                	cmp    %ebx,%esi
8010248a:	73 e4                	jae    80102470 <kinit1+0x40>
}
8010248c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010248f:	5b                   	pop    %ebx
80102490:	5e                   	pop    %esi
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret    
80102493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <kinit2>:
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801024ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801024b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024bd:	39 de                	cmp    %ebx,%esi
801024bf:	72 23                	jb     801024e4 <kinit2+0x44>
801024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801024d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024d7:	50                   	push   %eax
801024d8:	e8 73 fe ff ff       	call   80102350 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801024dd:	83 c4 10             	add    $0x10,%esp
801024e0:	39 de                	cmp    %ebx,%esi
801024e2:	73 e4                	jae    801024c8 <kinit2+0x28>
  kmem.use_lock = 1;
801024e4:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
801024eb:	00 00 00 
}
801024ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024f1:	5b                   	pop    %ebx
801024f2:	5e                   	pop    %esi
801024f3:	5d                   	pop    %ebp
801024f4:	c3                   	ret    
801024f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102500 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102500:	a1 74 36 11 80       	mov    0x80113674,%eax
80102505:	85 c0                	test   %eax,%eax
80102507:	75 1f                	jne    80102528 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102509:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010250e:	85 c0                	test   %eax,%eax
80102510:	74 0e                	je     80102520 <kalloc+0x20>
    kmem.freelist = r->next;
80102512:	8b 10                	mov    (%eax),%edx
80102514:	89 15 78 36 11 80    	mov    %edx,0x80113678
8010251a:	c3                   	ret    
8010251b:	90                   	nop
8010251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102520:	f3 c3                	repz ret 
80102522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102528:	55                   	push   %ebp
80102529:	89 e5                	mov    %esp,%ebp
8010252b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010252e:	68 40 36 11 80       	push   $0x80113640
80102533:	e8 68 24 00 00       	call   801049a0 <acquire>
  r = kmem.freelist;
80102538:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102546:	85 c0                	test   %eax,%eax
80102548:	74 08                	je     80102552 <kalloc+0x52>
    kmem.freelist = r->next;
8010254a:	8b 08                	mov    (%eax),%ecx
8010254c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102552:	85 d2                	test   %edx,%edx
80102554:	74 16                	je     8010256c <kalloc+0x6c>
    release(&kmem.lock);
80102556:	83 ec 0c             	sub    $0xc,%esp
80102559:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010255c:	68 40 36 11 80       	push   $0x80113640
80102561:	e8 fa 24 00 00       	call   80104a60 <release>
  return (char*)r;
80102566:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102569:	83 c4 10             	add    $0x10,%esp
}
8010256c:	c9                   	leave  
8010256d:	c3                   	ret    
8010256e:	66 90                	xchg   %ax,%ax

80102570 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102570:	ba 64 00 00 00       	mov    $0x64,%edx
80102575:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102576:	a8 01                	test   $0x1,%al
80102578:	0f 84 c2 00 00 00    	je     80102640 <kbdgetc+0xd0>
8010257e:	ba 60 00 00 00       	mov    $0x60,%edx
80102583:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102584:	0f b6 d0             	movzbl %al,%edx
80102587:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010258d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102593:	0f 84 7f 00 00 00    	je     80102618 <kbdgetc+0xa8>
{
80102599:	55                   	push   %ebp
8010259a:	89 e5                	mov    %esp,%ebp
8010259c:	53                   	push   %ebx
8010259d:	89 cb                	mov    %ecx,%ebx
8010259f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025a2:	84 c0                	test   %al,%al
801025a4:	78 4a                	js     801025f0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025a6:	85 db                	test   %ebx,%ebx
801025a8:	74 09                	je     801025b3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025aa:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025ad:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801025b0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801025b3:	0f b6 82 a0 79 10 80 	movzbl -0x7fef8660(%edx),%eax
801025ba:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025bc:	0f b6 82 a0 78 10 80 	movzbl -0x7fef8760(%edx),%eax
801025c3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025c5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025c7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025cd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025d0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025d3:	8b 04 85 80 78 10 80 	mov    -0x7fef8780(,%eax,4),%eax
801025da:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025de:	74 31                	je     80102611 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025e0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025e3:	83 fa 19             	cmp    $0x19,%edx
801025e6:	77 40                	ja     80102628 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025e8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025eb:	5b                   	pop    %ebx
801025ec:	5d                   	pop    %ebp
801025ed:	c3                   	ret    
801025ee:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025f0:	83 e0 7f             	and    $0x7f,%eax
801025f3:	85 db                	test   %ebx,%ebx
801025f5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025f8:	0f b6 82 a0 79 10 80 	movzbl -0x7fef8660(%edx),%eax
801025ff:	83 c8 40             	or     $0x40,%eax
80102602:	0f b6 c0             	movzbl %al,%eax
80102605:	f7 d0                	not    %eax
80102607:	21 c1                	and    %eax,%ecx
    return 0;
80102609:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010260b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102611:	5b                   	pop    %ebx
80102612:	5d                   	pop    %ebp
80102613:	c3                   	ret    
80102614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102618:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010261b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010261d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102623:	c3                   	ret    
80102624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102628:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010262b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010262e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010262f:	83 f9 1a             	cmp    $0x1a,%ecx
80102632:	0f 42 c2             	cmovb  %edx,%eax
}
80102635:	5d                   	pop    %ebp
80102636:	c3                   	ret    
80102637:	89 f6                	mov    %esi,%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102645:	c3                   	ret    
80102646:	8d 76 00             	lea    0x0(%esi),%esi
80102649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102650 <kbdintr>:

void
kbdintr(void)
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102656:	68 70 25 10 80       	push   $0x80102570
8010265b:	e8 b0 e1 ff ff       	call   80100810 <consoleintr>
}
80102660:	83 c4 10             	add    $0x10,%esp
80102663:	c9                   	leave  
80102664:	c3                   	ret    
80102665:	66 90                	xchg   %ax,%ax
80102667:	66 90                	xchg   %ax,%ax
80102669:	66 90                	xchg   %ax,%ax
8010266b:	66 90                	xchg   %ax,%ax
8010266d:	66 90                	xchg   %ax,%ax
8010266f:	90                   	nop

80102670 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102670:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102678:	85 c0                	test   %eax,%eax
8010267a:	0f 84 c8 00 00 00    	je     80102748 <lapicinit+0xd8>
  lapic[index] = value;
80102680:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102687:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010268d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102694:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010269a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026a1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026bb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ce:	8b 50 30             	mov    0x30(%eax),%edx
801026d1:	c1 ea 10             	shr    $0x10,%edx
801026d4:	80 fa 03             	cmp    $0x3,%dl
801026d7:	77 77                	ja     80102750 <lapicinit+0xe0>
  lapic[index] = value;
801026d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102700:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102707:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010270d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102714:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102717:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010271a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102721:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102724:	8b 50 20             	mov    0x20(%eax),%edx
80102727:	89 f6                	mov    %esi,%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102730:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102736:	80 e6 10             	and    $0x10,%dh
80102739:	75 f5                	jne    80102730 <lapicinit+0xc0>
  lapic[index] = value;
8010273b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102742:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102745:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102748:	5d                   	pop    %ebp
80102749:	c3                   	ret    
8010274a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102750:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102757:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010275a:	8b 50 20             	mov    0x20(%eax),%edx
8010275d:	e9 77 ff ff ff       	jmp    801026d9 <lapicinit+0x69>
80102762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102770:	8b 15 7c 36 11 80    	mov    0x8011367c,%edx
{
80102776:	55                   	push   %ebp
80102777:	31 c0                	xor    %eax,%eax
80102779:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010277b:	85 d2                	test   %edx,%edx
8010277d:	74 06                	je     80102785 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010277f:	8b 42 20             	mov    0x20(%edx),%eax
80102782:	c1 e8 18             	shr    $0x18,%eax
}
80102785:	5d                   	pop    %ebp
80102786:	c3                   	ret    
80102787:	89 f6                	mov    %esi,%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102790:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0d                	je     801027a9 <lapiceoi+0x19>
  lapic[index] = value;
8010279c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027a3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801027a9:	5d                   	pop    %ebp
801027aa:	c3                   	ret    
801027ab:	90                   	nop
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
}
801027b3:	5d                   	pop    %ebp
801027b4:	c3                   	ret    
801027b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027c6:	ba 70 00 00 00       	mov    $0x70,%edx
801027cb:	89 e5                	mov    %esp,%ebp
801027cd:	53                   	push   %ebx
801027ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027d4:	ee                   	out    %al,(%dx)
801027d5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027da:	ba 71 00 00 00       	mov    $0x71,%edx
801027df:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027e0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027e2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027e5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027eb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ed:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027f0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027f3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027f5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027f8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027fe:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102803:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102809:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010280c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102813:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102816:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102819:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102820:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102823:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102826:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010282c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010282f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102835:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102838:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102847:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010284a:	5b                   	pop    %ebx
8010284b:	5d                   	pop    %ebp
8010284c:	c3                   	ret    
8010284d:	8d 76 00             	lea    0x0(%esi),%esi

80102850 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102850:	55                   	push   %ebp
80102851:	b8 0b 00 00 00       	mov    $0xb,%eax
80102856:	ba 70 00 00 00       	mov    $0x70,%edx
8010285b:	89 e5                	mov    %esp,%ebp
8010285d:	57                   	push   %edi
8010285e:	56                   	push   %esi
8010285f:	53                   	push   %ebx
80102860:	83 ec 4c             	sub    $0x4c,%esp
80102863:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102864:	ba 71 00 00 00       	mov    $0x71,%edx
80102869:	ec                   	in     (%dx),%al
8010286a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010286d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102872:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102875:	8d 76 00             	lea    0x0(%esi),%esi
80102878:	31 c0                	xor    %eax,%eax
8010287a:	89 da                	mov    %ebx,%edx
8010287c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102882:	89 ca                	mov    %ecx,%edx
80102884:	ec                   	in     (%dx),%al
80102885:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102888:	89 da                	mov    %ebx,%edx
8010288a:	b8 02 00 00 00       	mov    $0x2,%eax
8010288f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102890:	89 ca                	mov    %ecx,%edx
80102892:	ec                   	in     (%dx),%al
80102893:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102896:	89 da                	mov    %ebx,%edx
80102898:	b8 04 00 00 00       	mov    $0x4,%eax
8010289d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289e:	89 ca                	mov    %ecx,%edx
801028a0:	ec                   	in     (%dx),%al
801028a1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a4:	89 da                	mov    %ebx,%edx
801028a6:	b8 07 00 00 00       	mov    $0x7,%eax
801028ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ac:	89 ca                	mov    %ecx,%edx
801028ae:	ec                   	in     (%dx),%al
801028af:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b2:	89 da                	mov    %ebx,%edx
801028b4:	b8 08 00 00 00       	mov    $0x8,%eax
801028b9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ba:	89 ca                	mov    %ecx,%edx
801028bc:	ec                   	in     (%dx),%al
801028bd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028bf:	89 da                	mov    %ebx,%edx
801028c1:	b8 09 00 00 00       	mov    $0x9,%eax
801028c6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c7:	89 ca                	mov    %ecx,%edx
801028c9:	ec                   	in     (%dx),%al
801028ca:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028cc:	89 da                	mov    %ebx,%edx
801028ce:	b8 0a 00 00 00       	mov    $0xa,%eax
801028d3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d4:	89 ca                	mov    %ecx,%edx
801028d6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028d7:	84 c0                	test   %al,%al
801028d9:	78 9d                	js     80102878 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028db:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028df:	89 fa                	mov    %edi,%edx
801028e1:	0f b6 fa             	movzbl %dl,%edi
801028e4:	89 f2                	mov    %esi,%edx
801028e6:	0f b6 f2             	movzbl %dl,%esi
801028e9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ec:	89 da                	mov    %ebx,%edx
801028ee:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028f1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028f4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028f8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028fb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028ff:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102902:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102906:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102909:	31 c0                	xor    %eax,%eax
8010290b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290c:	89 ca                	mov    %ecx,%edx
8010290e:	ec                   	in     (%dx),%al
8010290f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102912:	89 da                	mov    %ebx,%edx
80102914:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102917:	b8 02 00 00 00       	mov    $0x2,%eax
8010291c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291d:	89 ca                	mov    %ecx,%edx
8010291f:	ec                   	in     (%dx),%al
80102920:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102923:	89 da                	mov    %ebx,%edx
80102925:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102928:	b8 04 00 00 00       	mov    $0x4,%eax
8010292d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292e:	89 ca                	mov    %ecx,%edx
80102930:	ec                   	in     (%dx),%al
80102931:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102934:	89 da                	mov    %ebx,%edx
80102936:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102939:	b8 07 00 00 00       	mov    $0x7,%eax
8010293e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293f:	89 ca                	mov    %ecx,%edx
80102941:	ec                   	in     (%dx),%al
80102942:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102945:	89 da                	mov    %ebx,%edx
80102947:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010294a:	b8 08 00 00 00       	mov    $0x8,%eax
8010294f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102950:	89 ca                	mov    %ecx,%edx
80102952:	ec                   	in     (%dx),%al
80102953:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102956:	89 da                	mov    %ebx,%edx
80102958:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010295b:	b8 09 00 00 00       	mov    $0x9,%eax
80102960:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102961:	89 ca                	mov    %ecx,%edx
80102963:	ec                   	in     (%dx),%al
80102964:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102967:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010296a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010296d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102970:	6a 18                	push   $0x18
80102972:	50                   	push   %eax
80102973:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102976:	50                   	push   %eax
80102977:	e8 84 21 00 00       	call   80104b00 <memcmp>
8010297c:	83 c4 10             	add    $0x10,%esp
8010297f:	85 c0                	test   %eax,%eax
80102981:	0f 85 f1 fe ff ff    	jne    80102878 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102987:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010298b:	75 78                	jne    80102a05 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010298d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102990:	89 c2                	mov    %eax,%edx
80102992:	83 e0 0f             	and    $0xf,%eax
80102995:	c1 ea 04             	shr    $0x4,%edx
80102998:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010299b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801029a1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029a4:	89 c2                	mov    %eax,%edx
801029a6:	83 e0 0f             	and    $0xf,%eax
801029a9:	c1 ea 04             	shr    $0x4,%edx
801029ac:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029af:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029b8:	89 c2                	mov    %eax,%edx
801029ba:	83 e0 0f             	and    $0xf,%eax
801029bd:	c1 ea 04             	shr    $0x4,%edx
801029c0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029c9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029cc:	89 c2                	mov    %eax,%edx
801029ce:	83 e0 0f             	and    $0xf,%eax
801029d1:	c1 ea 04             	shr    $0x4,%edx
801029d4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029d7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e0:	89 c2                	mov    %eax,%edx
801029e2:	83 e0 0f             	and    $0xf,%eax
801029e5:	c1 ea 04             	shr    $0x4,%edx
801029e8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029eb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f4:	89 c2                	mov    %eax,%edx
801029f6:	83 e0 0f             	and    $0xf,%eax
801029f9:	c1 ea 04             	shr    $0x4,%edx
801029fc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a02:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a05:	8b 75 08             	mov    0x8(%ebp),%esi
80102a08:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a0b:	89 06                	mov    %eax,(%esi)
80102a0d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a10:	89 46 04             	mov    %eax,0x4(%esi)
80102a13:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a16:	89 46 08             	mov    %eax,0x8(%esi)
80102a19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a1c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a22:	89 46 10             	mov    %eax,0x10(%esi)
80102a25:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a28:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a2b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a35:	5b                   	pop    %ebx
80102a36:	5e                   	pop    %esi
80102a37:	5f                   	pop    %edi
80102a38:	5d                   	pop    %ebp
80102a39:	c3                   	ret    
80102a3a:	66 90                	xchg   %ax,%ax
80102a3c:	66 90                	xchg   %ax,%ax
80102a3e:	66 90                	xchg   %ax,%ax

80102a40 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a40:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102a46:	85 c9                	test   %ecx,%ecx
80102a48:	0f 8e 8a 00 00 00    	jle    80102ad8 <install_trans+0x98>
{
80102a4e:	55                   	push   %ebp
80102a4f:	89 e5                	mov    %esp,%ebp
80102a51:	57                   	push   %edi
80102a52:	56                   	push   %esi
80102a53:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a54:	31 db                	xor    %ebx,%ebx
{
80102a56:	83 ec 0c             	sub    $0xc,%esp
80102a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a60:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a65:	83 ec 08             	sub    $0x8,%esp
80102a68:	01 d8                	add    %ebx,%eax
80102a6a:	83 c0 01             	add    $0x1,%eax
80102a6d:	50                   	push   %eax
80102a6e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102a74:	e8 57 d6 ff ff       	call   801000d0 <bread>
80102a79:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a7b:	58                   	pop    %eax
80102a7c:	5a                   	pop    %edx
80102a7d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102a84:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a8a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a8d:	e8 3e d6 ff ff       	call   801000d0 <bread>
80102a92:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a94:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a97:	83 c4 0c             	add    $0xc,%esp
80102a9a:	68 00 02 00 00       	push   $0x200
80102a9f:	50                   	push   %eax
80102aa0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102aa3:	50                   	push   %eax
80102aa4:	e8 b7 20 00 00       	call   80104b60 <memmove>
    bwrite(dbuf);  // write dst to disk
80102aa9:	89 34 24             	mov    %esi,(%esp)
80102aac:	e8 ef d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ab1:	89 3c 24             	mov    %edi,(%esp)
80102ab4:	e8 27 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102ab9:	89 34 24             	mov    %esi,(%esp)
80102abc:	e8 1f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ac1:	83 c4 10             	add    $0x10,%esp
80102ac4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102aca:	7f 94                	jg     80102a60 <install_trans+0x20>
  }
}
80102acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102acf:	5b                   	pop    %ebx
80102ad0:	5e                   	pop    %esi
80102ad1:	5f                   	pop    %edi
80102ad2:	5d                   	pop    %ebp
80102ad3:	c3                   	ret    
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ad8:	f3 c3                	repz ret 
80102ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ae0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ae5:	83 ec 08             	sub    $0x8,%esp
80102ae8:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102aee:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102af4:	e8 d7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102af9:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102aff:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b02:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102b04:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102b06:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b09:	7e 16                	jle    80102b21 <write_head+0x41>
80102b0b:	c1 e3 02             	shl    $0x2,%ebx
80102b0e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b10:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102b16:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102b1a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b1d:	39 da                	cmp    %ebx,%edx
80102b1f:	75 ef                	jne    80102b10 <write_head+0x30>
  }
  bwrite(buf);
80102b21:	83 ec 0c             	sub    $0xc,%esp
80102b24:	56                   	push   %esi
80102b25:	e8 76 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b2a:	89 34 24             	mov    %esi,(%esp)
80102b2d:	e8 ae d6 ff ff       	call   801001e0 <brelse>
}
80102b32:	83 c4 10             	add    $0x10,%esp
80102b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b38:	5b                   	pop    %ebx
80102b39:	5e                   	pop    %esi
80102b3a:	5d                   	pop    %ebp
80102b3b:	c3                   	ret    
80102b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b40 <initlog>:
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	53                   	push   %ebx
80102b44:	83 ec 2c             	sub    $0x2c,%esp
80102b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b4a:	68 a0 7a 10 80       	push   $0x80107aa0
80102b4f:	68 80 36 11 80       	push   $0x80113680
80102b54:	e8 07 1d 00 00       	call   80104860 <initlock>
  readsb(dev, &sb);
80102b59:	58                   	pop    %eax
80102b5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b5d:	5a                   	pop    %edx
80102b5e:	50                   	push   %eax
80102b5f:	53                   	push   %ebx
80102b60:	e8 0b e9 ff ff       	call   80101470 <readsb>
  log.size = sb.nlog;
80102b65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b6b:	59                   	pop    %ecx
  log.dev = dev;
80102b6c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102b72:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  log.start = sb.logstart;
80102b78:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  struct buf *buf = bread(log.dev, log.start);
80102b7d:	5a                   	pop    %edx
80102b7e:	50                   	push   %eax
80102b7f:	53                   	push   %ebx
80102b80:	e8 4b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b85:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b88:	83 c4 10             	add    $0x10,%esp
80102b8b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b8d:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102b93:	7e 1c                	jle    80102bb1 <initlog+0x71>
80102b95:	c1 e3 02             	shl    $0x2,%ebx
80102b98:	31 d2                	xor    %edx,%edx
80102b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102ba0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ba4:	83 c2 04             	add    $0x4,%edx
80102ba7:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102bad:	39 d3                	cmp    %edx,%ebx
80102baf:	75 ef                	jne    80102ba0 <initlog+0x60>
  brelse(buf);
80102bb1:	83 ec 0c             	sub    $0xc,%esp
80102bb4:	50                   	push   %eax
80102bb5:	e8 26 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bba:	e8 81 fe ff ff       	call   80102a40 <install_trans>
  log.lh.n = 0;
80102bbf:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102bc6:	00 00 00 
  write_head(); // clear the log
80102bc9:	e8 12 ff ff ff       	call   80102ae0 <write_head>
}
80102bce:	83 c4 10             	add    $0x10,%esp
80102bd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bd4:	c9                   	leave  
80102bd5:	c3                   	ret    
80102bd6:	8d 76 00             	lea    0x0(%esi),%esi
80102bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102be0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
80102be3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102be6:	68 80 36 11 80       	push   $0x80113680
80102beb:	e8 b0 1d 00 00       	call   801049a0 <acquire>
80102bf0:	83 c4 10             	add    $0x10,%esp
80102bf3:	eb 18                	jmp    80102c0d <begin_op+0x2d>
80102bf5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bf8:	83 ec 08             	sub    $0x8,%esp
80102bfb:	68 80 36 11 80       	push   $0x80113680
80102c00:	68 80 36 11 80       	push   $0x80113680
80102c05:	e8 76 15 00 00       	call   80104180 <sleep>
80102c0a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c0d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102c12:	85 c0                	test   %eax,%eax
80102c14:	75 e2                	jne    80102bf8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c16:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102c1b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102c21:	83 c0 01             	add    $0x1,%eax
80102c24:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c27:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c2a:	83 fa 1e             	cmp    $0x1e,%edx
80102c2d:	7f c9                	jg     80102bf8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c2f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c32:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102c37:	68 80 36 11 80       	push   $0x80113680
80102c3c:	e8 1f 1e 00 00       	call   80104a60 <release>
      break;
    }
  }
}
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	c9                   	leave  
80102c45:	c3                   	ret    
80102c46:	8d 76 00             	lea    0x0(%esi),%esi
80102c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	57                   	push   %edi
80102c54:	56                   	push   %esi
80102c55:	53                   	push   %ebx
80102c56:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c59:	68 80 36 11 80       	push   $0x80113680
80102c5e:	e8 3d 1d 00 00       	call   801049a0 <acquire>
  log.outstanding -= 1;
80102c63:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102c68:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102c6e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c71:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c74:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c76:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102c7c:	0f 85 1a 01 00 00    	jne    80102d9c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c82:	85 db                	test   %ebx,%ebx
80102c84:	0f 85 ee 00 00 00    	jne    80102d78 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c8a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c8d:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102c94:	00 00 00 
  release(&log.lock);
80102c97:	68 80 36 11 80       	push   $0x80113680
80102c9c:	e8 bf 1d 00 00       	call   80104a60 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ca1:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102ca7:	83 c4 10             	add    $0x10,%esp
80102caa:	85 c9                	test   %ecx,%ecx
80102cac:	0f 8e 85 00 00 00    	jle    80102d37 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102cb2:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102cb7:	83 ec 08             	sub    $0x8,%esp
80102cba:	01 d8                	add    %ebx,%eax
80102cbc:	83 c0 01             	add    $0x1,%eax
80102cbf:	50                   	push   %eax
80102cc0:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102cc6:	e8 05 d4 ff ff       	call   801000d0 <bread>
80102ccb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ccd:	58                   	pop    %eax
80102cce:	5a                   	pop    %edx
80102ccf:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102cd6:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cdc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cdf:	e8 ec d3 ff ff       	call   801000d0 <bread>
80102ce4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ce6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ce9:	83 c4 0c             	add    $0xc,%esp
80102cec:	68 00 02 00 00       	push   $0x200
80102cf1:	50                   	push   %eax
80102cf2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cf5:	50                   	push   %eax
80102cf6:	e8 65 1e 00 00       	call   80104b60 <memmove>
    bwrite(to);  // write the log
80102cfb:	89 34 24             	mov    %esi,(%esp)
80102cfe:	e8 9d d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d03:	89 3c 24             	mov    %edi,(%esp)
80102d06:	e8 d5 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d0b:	89 34 24             	mov    %esi,(%esp)
80102d0e:	e8 cd d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d13:	83 c4 10             	add    $0x10,%esp
80102d16:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102d1c:	7c 94                	jl     80102cb2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d1e:	e8 bd fd ff ff       	call   80102ae0 <write_head>
    install_trans(); // Now install writes to home locations
80102d23:	e8 18 fd ff ff       	call   80102a40 <install_trans>
    log.lh.n = 0;
80102d28:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d2f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d32:	e8 a9 fd ff ff       	call   80102ae0 <write_head>
    acquire(&log.lock);
80102d37:	83 ec 0c             	sub    $0xc,%esp
80102d3a:	68 80 36 11 80       	push   $0x80113680
80102d3f:	e8 5c 1c 00 00       	call   801049a0 <acquire>
    wakeup(&log);
80102d44:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102d4b:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102d52:	00 00 00 
    wakeup(&log);
80102d55:	e8 d6 14 00 00       	call   80104230 <wakeup>
    release(&log.lock);
80102d5a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d61:	e8 fa 1c 00 00       	call   80104a60 <release>
80102d66:	83 c4 10             	add    $0x10,%esp
}
80102d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d6c:	5b                   	pop    %ebx
80102d6d:	5e                   	pop    %esi
80102d6e:	5f                   	pop    %edi
80102d6f:	5d                   	pop    %ebp
80102d70:	c3                   	ret    
80102d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d78:	83 ec 0c             	sub    $0xc,%esp
80102d7b:	68 80 36 11 80       	push   $0x80113680
80102d80:	e8 ab 14 00 00       	call   80104230 <wakeup>
  release(&log.lock);
80102d85:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d8c:	e8 cf 1c 00 00       	call   80104a60 <release>
80102d91:	83 c4 10             	add    $0x10,%esp
}
80102d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d97:	5b                   	pop    %ebx
80102d98:	5e                   	pop    %esi
80102d99:	5f                   	pop    %edi
80102d9a:	5d                   	pop    %ebp
80102d9b:	c3                   	ret    
    panic("log.committing");
80102d9c:	83 ec 0c             	sub    $0xc,%esp
80102d9f:	68 a4 7a 10 80       	push   $0x80107aa4
80102da4:	e8 e7 d5 ff ff       	call   80100390 <panic>
80102da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102db0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	53                   	push   %ebx
80102db4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102db7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102dbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102dc0:	83 fa 1d             	cmp    $0x1d,%edx
80102dc3:	0f 8f 9d 00 00 00    	jg     80102e66 <log_write+0xb6>
80102dc9:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102dce:	83 e8 01             	sub    $0x1,%eax
80102dd1:	39 c2                	cmp    %eax,%edx
80102dd3:	0f 8d 8d 00 00 00    	jge    80102e66 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102dd9:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102dde:	85 c0                	test   %eax,%eax
80102de0:	0f 8e 8d 00 00 00    	jle    80102e73 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102de6:	83 ec 0c             	sub    $0xc,%esp
80102de9:	68 80 36 11 80       	push   $0x80113680
80102dee:	e8 ad 1b 00 00       	call   801049a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102df3:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102df9:	83 c4 10             	add    $0x10,%esp
80102dfc:	83 f9 00             	cmp    $0x0,%ecx
80102dff:	7e 57                	jle    80102e58 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e01:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102e04:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e06:	3b 15 cc 36 11 80    	cmp    0x801136cc,%edx
80102e0c:	75 0b                	jne    80102e19 <log_write+0x69>
80102e0e:	eb 38                	jmp    80102e48 <log_write+0x98>
80102e10:	39 14 85 cc 36 11 80 	cmp    %edx,-0x7feec934(,%eax,4)
80102e17:	74 2f                	je     80102e48 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e19:	83 c0 01             	add    $0x1,%eax
80102e1c:	39 c1                	cmp    %eax,%ecx
80102e1e:	75 f0                	jne    80102e10 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e20:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e27:	83 c0 01             	add    $0x1,%eax
80102e2a:	a3 c8 36 11 80       	mov    %eax,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80102e2f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e32:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102e39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e3c:	c9                   	leave  
  release(&log.lock);
80102e3d:	e9 1e 1c 00 00       	jmp    80104a60 <release>
80102e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e48:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
80102e4f:	eb de                	jmp    80102e2f <log_write+0x7f>
80102e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e58:	8b 43 08             	mov    0x8(%ebx),%eax
80102e5b:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102e60:	75 cd                	jne    80102e2f <log_write+0x7f>
80102e62:	31 c0                	xor    %eax,%eax
80102e64:	eb c1                	jmp    80102e27 <log_write+0x77>
    panic("too big a transaction");
80102e66:	83 ec 0c             	sub    $0xc,%esp
80102e69:	68 b3 7a 10 80       	push   $0x80107ab3
80102e6e:	e8 1d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e73:	83 ec 0c             	sub    $0xc,%esp
80102e76:	68 c9 7a 10 80       	push   $0x80107ac9
80102e7b:	e8 10 d5 ff ff       	call   80100390 <panic>

80102e80 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	53                   	push   %ebx
80102e84:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e87:	e8 74 0a 00 00       	call   80103900 <cpuid>
80102e8c:	89 c3                	mov    %eax,%ebx
80102e8e:	e8 6d 0a 00 00       	call   80103900 <cpuid>
80102e93:	83 ec 04             	sub    $0x4,%esp
80102e96:	53                   	push   %ebx
80102e97:	50                   	push   %eax
80102e98:	68 e4 7a 10 80       	push   $0x80107ae4
80102e9d:	e8 be d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ea2:	e8 79 2f 00 00       	call   80105e20 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ea7:	e8 d4 09 00 00       	call   80103880 <mycpu>
80102eac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102eae:	b8 01 00 00 00       	mov    $0x1,%eax
80102eb3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eba:	e8 f1 0d 00 00       	call   80103cb0 <scheduler>
80102ebf:	90                   	nop

80102ec0 <mpenter>:
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ec6:	e8 45 40 00 00       	call   80106f10 <switchkvm>
  seginit();
80102ecb:	e8 b0 3f 00 00       	call   80106e80 <seginit>
  lapicinit();
80102ed0:	e8 9b f7 ff ff       	call   80102670 <lapicinit>
  mpmain();
80102ed5:	e8 a6 ff ff ff       	call   80102e80 <mpmain>
80102eda:	66 90                	xchg   %ax,%ax
80102edc:	66 90                	xchg   %ax,%ax
80102ede:	66 90                	xchg   %ax,%ax

80102ee0 <main>:
{
80102ee0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ee4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ee7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eea:	55                   	push   %ebp
80102eeb:	89 e5                	mov    %esp,%ebp
80102eed:	53                   	push   %ebx
80102eee:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eef:	83 ec 08             	sub    $0x8,%esp
80102ef2:	68 00 00 40 80       	push   $0x80400000
80102ef7:	68 a8 89 11 80       	push   $0x801189a8
80102efc:	e8 2f f5 ff ff       	call   80102430 <kinit1>
  kvmalloc();      // kernel page table
80102f01:	e8 da 44 00 00       	call   801073e0 <kvmalloc>
  mpinit();        // detect other processors
80102f06:	e8 75 01 00 00       	call   80103080 <mpinit>
  lapicinit();     // interrupt controller
80102f0b:	e8 60 f7 ff ff       	call   80102670 <lapicinit>
  seginit();       // segment descriptors
80102f10:	e8 6b 3f 00 00       	call   80106e80 <seginit>
  picinit();       // disable pic
80102f15:	e8 46 03 00 00       	call   80103260 <picinit>
  ioapicinit();    // another interrupt controller
80102f1a:	e8 41 f3 ff ff       	call   80102260 <ioapicinit>
  consoleinit();   // console hardware
80102f1f:	e8 9c da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f24:	e8 27 32 00 00       	call   80106150 <uartinit>
  pinit();         // process table
80102f29:	e8 32 09 00 00       	call   80103860 <pinit>
  tvinit();        // trap vectors
80102f2e:	e8 6d 2e 00 00       	call   80105da0 <tvinit>
  binit();         // buffer cache
80102f33:	e8 08 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f38:	e8 53 de ff ff       	call   80100d90 <fileinit>
  ideinit();       // disk 
80102f3d:	e8 ee f0 ff ff       	call   80102030 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f42:	83 c4 0c             	add    $0xc,%esp
80102f45:	68 8a 00 00 00       	push   $0x8a
80102f4a:	68 8c b4 10 80       	push   $0x8010b48c
80102f4f:	68 00 70 00 80       	push   $0x80007000
80102f54:	e8 07 1c 00 00       	call   80104b60 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f59:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102f60:	00 00 00 
80102f63:	83 c4 10             	add    $0x10,%esp
80102f66:	05 80 37 11 80       	add    $0x80113780,%eax
80102f6b:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80102f70:	76 71                	jbe    80102fe3 <main+0x103>
80102f72:	bb 80 37 11 80       	mov    $0x80113780,%ebx
80102f77:	89 f6                	mov    %esi,%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f80:	e8 fb 08 00 00       	call   80103880 <mycpu>
80102f85:	39 d8                	cmp    %ebx,%eax
80102f87:	74 41                	je     80102fca <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f89:	e8 72 f5 ff ff       	call   80102500 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f8e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f93:	c7 05 f8 6f 00 80 c0 	movl   $0x80102ec0,0x80006ff8
80102f9a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f9d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102fa4:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fa7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102fac:	0f b6 03             	movzbl (%ebx),%eax
80102faf:	83 ec 08             	sub    $0x8,%esp
80102fb2:	68 00 70 00 00       	push   $0x7000
80102fb7:	50                   	push   %eax
80102fb8:	e8 03 f8 ff ff       	call   801027c0 <lapicstartap>
80102fbd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fc0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fc6:	85 c0                	test   %eax,%eax
80102fc8:	74 f6                	je     80102fc0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102fca:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102fd1:	00 00 00 
80102fd4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fda:	05 80 37 11 80       	add    $0x80113780,%eax
80102fdf:	39 c3                	cmp    %eax,%ebx
80102fe1:	72 9d                	jb     80102f80 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fe3:	83 ec 08             	sub    $0x8,%esp
80102fe6:	68 00 00 00 8e       	push   $0x8e000000
80102feb:	68 00 00 40 80       	push   $0x80400000
80102ff0:	e8 ab f4 ff ff       	call   801024a0 <kinit2>
  userinit();      // first user process
80102ff5:	e8 86 09 00 00       	call   80103980 <userinit>
  mpmain();        // finish this processor's setup
80102ffa:	e8 81 fe ff ff       	call   80102e80 <mpmain>
80102fff:	90                   	nop

80103000 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103005:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010300b:	53                   	push   %ebx
  e = addr+len;
8010300c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010300f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103012:	39 de                	cmp    %ebx,%esi
80103014:	72 10                	jb     80103026 <mpsearch1+0x26>
80103016:	eb 50                	jmp    80103068 <mpsearch1+0x68>
80103018:	90                   	nop
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103020:	39 fb                	cmp    %edi,%ebx
80103022:	89 fe                	mov    %edi,%esi
80103024:	76 42                	jbe    80103068 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103026:	83 ec 04             	sub    $0x4,%esp
80103029:	8d 7e 10             	lea    0x10(%esi),%edi
8010302c:	6a 04                	push   $0x4
8010302e:	68 f8 7a 10 80       	push   $0x80107af8
80103033:	56                   	push   %esi
80103034:	e8 c7 1a 00 00       	call   80104b00 <memcmp>
80103039:	83 c4 10             	add    $0x10,%esp
8010303c:	85 c0                	test   %eax,%eax
8010303e:	75 e0                	jne    80103020 <mpsearch1+0x20>
80103040:	89 f1                	mov    %esi,%ecx
80103042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103048:	0f b6 11             	movzbl (%ecx),%edx
8010304b:	83 c1 01             	add    $0x1,%ecx
8010304e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103050:	39 f9                	cmp    %edi,%ecx
80103052:	75 f4                	jne    80103048 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103054:	84 c0                	test   %al,%al
80103056:	75 c8                	jne    80103020 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103058:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010305b:	89 f0                	mov    %esi,%eax
8010305d:	5b                   	pop    %ebx
8010305e:	5e                   	pop    %esi
8010305f:	5f                   	pop    %edi
80103060:	5d                   	pop    %ebp
80103061:	c3                   	ret    
80103062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103068:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010306b:	31 f6                	xor    %esi,%esi
}
8010306d:	89 f0                	mov    %esi,%eax
8010306f:	5b                   	pop    %ebx
80103070:	5e                   	pop    %esi
80103071:	5f                   	pop    %edi
80103072:	5d                   	pop    %ebp
80103073:	c3                   	ret    
80103074:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010307a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103080 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	57                   	push   %edi
80103084:	56                   	push   %esi
80103085:	53                   	push   %ebx
80103086:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103089:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103090:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103097:	c1 e0 08             	shl    $0x8,%eax
8010309a:	09 d0                	or     %edx,%eax
8010309c:	c1 e0 04             	shl    $0x4,%eax
8010309f:	85 c0                	test   %eax,%eax
801030a1:	75 1b                	jne    801030be <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801030a3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030aa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030b1:	c1 e0 08             	shl    $0x8,%eax
801030b4:	09 d0                	or     %edx,%eax
801030b6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030b9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030be:	ba 00 04 00 00       	mov    $0x400,%edx
801030c3:	e8 38 ff ff ff       	call   80103000 <mpsearch1>
801030c8:	85 c0                	test   %eax,%eax
801030ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030cd:	0f 84 3d 01 00 00    	je     80103210 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030d6:	8b 58 04             	mov    0x4(%eax),%ebx
801030d9:	85 db                	test   %ebx,%ebx
801030db:	0f 84 4f 01 00 00    	je     80103230 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030e1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030e7:	83 ec 04             	sub    $0x4,%esp
801030ea:	6a 04                	push   $0x4
801030ec:	68 15 7b 10 80       	push   $0x80107b15
801030f1:	56                   	push   %esi
801030f2:	e8 09 1a 00 00       	call   80104b00 <memcmp>
801030f7:	83 c4 10             	add    $0x10,%esp
801030fa:	85 c0                	test   %eax,%eax
801030fc:	0f 85 2e 01 00 00    	jne    80103230 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103102:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103109:	3c 01                	cmp    $0x1,%al
8010310b:	0f 95 c2             	setne  %dl
8010310e:	3c 04                	cmp    $0x4,%al
80103110:	0f 95 c0             	setne  %al
80103113:	20 c2                	and    %al,%dl
80103115:	0f 85 15 01 00 00    	jne    80103230 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010311b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103122:	66 85 ff             	test   %di,%di
80103125:	74 1a                	je     80103141 <mpinit+0xc1>
80103127:	89 f0                	mov    %esi,%eax
80103129:	01 f7                	add    %esi,%edi
  sum = 0;
8010312b:	31 d2                	xor    %edx,%edx
8010312d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103130:	0f b6 08             	movzbl (%eax),%ecx
80103133:	83 c0 01             	add    $0x1,%eax
80103136:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103138:	39 c7                	cmp    %eax,%edi
8010313a:	75 f4                	jne    80103130 <mpinit+0xb0>
8010313c:	84 d2                	test   %dl,%dl
8010313e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103141:	85 f6                	test   %esi,%esi
80103143:	0f 84 e7 00 00 00    	je     80103230 <mpinit+0x1b0>
80103149:	84 d2                	test   %dl,%dl
8010314b:	0f 85 df 00 00 00    	jne    80103230 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103151:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103157:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010315c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103163:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103169:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010316e:	01 d6                	add    %edx,%esi
80103170:	39 c6                	cmp    %eax,%esi
80103172:	76 23                	jbe    80103197 <mpinit+0x117>
    switch(*p){
80103174:	0f b6 10             	movzbl (%eax),%edx
80103177:	80 fa 04             	cmp    $0x4,%dl
8010317a:	0f 87 ca 00 00 00    	ja     8010324a <mpinit+0x1ca>
80103180:	ff 24 95 3c 7b 10 80 	jmp    *-0x7fef84c4(,%edx,4)
80103187:	89 f6                	mov    %esi,%esi
80103189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103190:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103193:	39 c6                	cmp    %eax,%esi
80103195:	77 dd                	ja     80103174 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103197:	85 db                	test   %ebx,%ebx
80103199:	0f 84 9e 00 00 00    	je     8010323d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031a2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031a6:	74 15                	je     801031bd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031a8:	b8 70 00 00 00       	mov    $0x70,%eax
801031ad:	ba 22 00 00 00       	mov    $0x22,%edx
801031b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b3:	ba 23 00 00 00       	mov    $0x23,%edx
801031b8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031b9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031bc:	ee                   	out    %al,(%dx)
  }
}
801031bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031c0:	5b                   	pop    %ebx
801031c1:	5e                   	pop    %esi
801031c2:	5f                   	pop    %edi
801031c3:	5d                   	pop    %ebp
801031c4:	c3                   	ret    
801031c5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031c8:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
801031ce:	83 f9 07             	cmp    $0x7,%ecx
801031d1:	7f 19                	jg     801031ec <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031d7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031dd:	83 c1 01             	add    $0x1,%ecx
801031e0:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031e6:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
801031ec:	83 c0 14             	add    $0x14,%eax
      continue;
801031ef:	e9 7c ff ff ff       	jmp    80103170 <mpinit+0xf0>
801031f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031fc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031ff:	88 15 60 37 11 80    	mov    %dl,0x80113760
      continue;
80103205:	e9 66 ff ff ff       	jmp    80103170 <mpinit+0xf0>
8010320a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103210:	ba 00 00 01 00       	mov    $0x10000,%edx
80103215:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010321a:	e8 e1 fd ff ff       	call   80103000 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010321f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103221:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103224:	0f 85 a9 fe ff ff    	jne    801030d3 <mpinit+0x53>
8010322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103230:	83 ec 0c             	sub    $0xc,%esp
80103233:	68 fd 7a 10 80       	push   $0x80107afd
80103238:	e8 53 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010323d:	83 ec 0c             	sub    $0xc,%esp
80103240:	68 1c 7b 10 80       	push   $0x80107b1c
80103245:	e8 46 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010324a:	31 db                	xor    %ebx,%ebx
8010324c:	e9 26 ff ff ff       	jmp    80103177 <mpinit+0xf7>
80103251:	66 90                	xchg   %ax,%ax
80103253:	66 90                	xchg   %ax,%ax
80103255:	66 90                	xchg   %ax,%ax
80103257:	66 90                	xchg   %ax,%ax
80103259:	66 90                	xchg   %ax,%ax
8010325b:	66 90                	xchg   %ax,%ax
8010325d:	66 90                	xchg   %ax,%ax
8010325f:	90                   	nop

80103260 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103260:	55                   	push   %ebp
80103261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103266:	ba 21 00 00 00       	mov    $0x21,%edx
8010326b:	89 e5                	mov    %esp,%ebp
8010326d:	ee                   	out    %al,(%dx)
8010326e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103273:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103274:	5d                   	pop    %ebp
80103275:	c3                   	ret    
80103276:	66 90                	xchg   %ax,%ax
80103278:	66 90                	xchg   %ax,%ax
8010327a:	66 90                	xchg   %ax,%ax
8010327c:	66 90                	xchg   %ax,%ax
8010327e:	66 90                	xchg   %ax,%ax

80103280 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	57                   	push   %edi
80103284:	56                   	push   %esi
80103285:	53                   	push   %ebx
80103286:	83 ec 0c             	sub    $0xc,%esp
80103289:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010328c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010328f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103295:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010329b:	e8 10 db ff ff       	call   80100db0 <filealloc>
801032a0:	85 c0                	test   %eax,%eax
801032a2:	89 03                	mov    %eax,(%ebx)
801032a4:	74 22                	je     801032c8 <pipealloc+0x48>
801032a6:	e8 05 db ff ff       	call   80100db0 <filealloc>
801032ab:	85 c0                	test   %eax,%eax
801032ad:	89 06                	mov    %eax,(%esi)
801032af:	74 3f                	je     801032f0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032b1:	e8 4a f2 ff ff       	call   80102500 <kalloc>
801032b6:	85 c0                	test   %eax,%eax
801032b8:	89 c7                	mov    %eax,%edi
801032ba:	75 54                	jne    80103310 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032bc:	8b 03                	mov    (%ebx),%eax
801032be:	85 c0                	test   %eax,%eax
801032c0:	75 34                	jne    801032f6 <pipealloc+0x76>
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032c8:	8b 06                	mov    (%esi),%eax
801032ca:	85 c0                	test   %eax,%eax
801032cc:	74 0c                	je     801032da <pipealloc+0x5a>
    fileclose(*f1);
801032ce:	83 ec 0c             	sub    $0xc,%esp
801032d1:	50                   	push   %eax
801032d2:	e8 99 db ff ff       	call   80100e70 <fileclose>
801032d7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032e2:	5b                   	pop    %ebx
801032e3:	5e                   	pop    %esi
801032e4:	5f                   	pop    %edi
801032e5:	5d                   	pop    %ebp
801032e6:	c3                   	ret    
801032e7:	89 f6                	mov    %esi,%esi
801032e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032f0:	8b 03                	mov    (%ebx),%eax
801032f2:	85 c0                	test   %eax,%eax
801032f4:	74 e4                	je     801032da <pipealloc+0x5a>
    fileclose(*f0);
801032f6:	83 ec 0c             	sub    $0xc,%esp
801032f9:	50                   	push   %eax
801032fa:	e8 71 db ff ff       	call   80100e70 <fileclose>
  if(*f1)
801032ff:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103301:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103304:	85 c0                	test   %eax,%eax
80103306:	75 c6                	jne    801032ce <pipealloc+0x4e>
80103308:	eb d0                	jmp    801032da <pipealloc+0x5a>
8010330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103310:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103313:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010331a:	00 00 00 
  p->writeopen = 1;
8010331d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103324:	00 00 00 
  p->nwrite = 0;
80103327:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010332e:	00 00 00 
  p->nread = 0;
80103331:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103338:	00 00 00 
  initlock(&p->lock, "pipe");
8010333b:	68 50 7b 10 80       	push   $0x80107b50
80103340:	50                   	push   %eax
80103341:	e8 1a 15 00 00       	call   80104860 <initlock>
  (*f0)->type = FD_PIPE;
80103346:	8b 03                	mov    (%ebx),%eax
  return 0;
80103348:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010334b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103351:	8b 03                	mov    (%ebx),%eax
80103353:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103357:	8b 03                	mov    (%ebx),%eax
80103359:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010335d:	8b 03                	mov    (%ebx),%eax
8010335f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103362:	8b 06                	mov    (%esi),%eax
80103364:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010336a:	8b 06                	mov    (%esi),%eax
8010336c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103370:	8b 06                	mov    (%esi),%eax
80103372:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103376:	8b 06                	mov    (%esi),%eax
80103378:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010337b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010337e:	31 c0                	xor    %eax,%eax
}
80103380:	5b                   	pop    %ebx
80103381:	5e                   	pop    %esi
80103382:	5f                   	pop    %edi
80103383:	5d                   	pop    %ebp
80103384:	c3                   	ret    
80103385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103390 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	56                   	push   %esi
80103394:	53                   	push   %ebx
80103395:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103398:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010339b:	83 ec 0c             	sub    $0xc,%esp
8010339e:	53                   	push   %ebx
8010339f:	e8 fc 15 00 00       	call   801049a0 <acquire>
  if(writable){
801033a4:	83 c4 10             	add    $0x10,%esp
801033a7:	85 f6                	test   %esi,%esi
801033a9:	74 45                	je     801033f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801033ab:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033b1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033bb:	00 00 00 
    wakeup(&p->nread);
801033be:	50                   	push   %eax
801033bf:	e8 6c 0e 00 00       	call   80104230 <wakeup>
801033c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033cd:	85 d2                	test   %edx,%edx
801033cf:	75 0a                	jne    801033db <pipeclose+0x4b>
801033d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033d7:	85 c0                	test   %eax,%eax
801033d9:	74 35                	je     80103410 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e1:	5b                   	pop    %ebx
801033e2:	5e                   	pop    %esi
801033e3:	5d                   	pop    %ebp
    release(&p->lock);
801033e4:	e9 77 16 00 00       	jmp    80104a60 <release>
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033f6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103400:	00 00 00 
    wakeup(&p->nwrite);
80103403:	50                   	push   %eax
80103404:	e8 27 0e 00 00       	call   80104230 <wakeup>
80103409:	83 c4 10             	add    $0x10,%esp
8010340c:	eb b9                	jmp    801033c7 <pipeclose+0x37>
8010340e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	53                   	push   %ebx
80103414:	e8 47 16 00 00       	call   80104a60 <release>
    kfree((char*)p);
80103419:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010341c:	83 c4 10             	add    $0x10,%esp
}
8010341f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103422:	5b                   	pop    %ebx
80103423:	5e                   	pop    %esi
80103424:	5d                   	pop    %ebp
    kfree((char*)p);
80103425:	e9 26 ef ff ff       	jmp    80102350 <kfree>
8010342a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103430 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 28             	sub    $0x28,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010343c:	53                   	push   %ebx
8010343d:	e8 5e 15 00 00       	call   801049a0 <acquire>
  for(i = 0; i < n; i++){
80103442:	8b 45 10             	mov    0x10(%ebp),%eax
80103445:	83 c4 10             	add    $0x10,%esp
80103448:	85 c0                	test   %eax,%eax
8010344a:	0f 8e c9 00 00 00    	jle    80103519 <pipewrite+0xe9>
80103450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103453:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103459:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010345f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103462:	03 4d 10             	add    0x10(%ebp),%ecx
80103465:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103468:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010346e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103474:	39 d0                	cmp    %edx,%eax
80103476:	75 71                	jne    801034e9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103478:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010347e:	85 c0                	test   %eax,%eax
80103480:	74 4e                	je     801034d0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103482:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103488:	eb 3a                	jmp    801034c4 <pipewrite+0x94>
8010348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	57                   	push   %edi
80103494:	e8 97 0d 00 00       	call   80104230 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103499:	5a                   	pop    %edx
8010349a:	59                   	pop    %ecx
8010349b:	53                   	push   %ebx
8010349c:	56                   	push   %esi
8010349d:	e8 de 0c 00 00       	call   80104180 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034a8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034ae:	83 c4 10             	add    $0x10,%esp
801034b1:	05 00 02 00 00       	add    $0x200,%eax
801034b6:	39 c2                	cmp    %eax,%edx
801034b8:	75 36                	jne    801034f0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034ba:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034c0:	85 c0                	test   %eax,%eax
801034c2:	74 0c                	je     801034d0 <pipewrite+0xa0>
801034c4:	e8 57 04 00 00       	call   80103920 <myproc>
801034c9:	8b 40 24             	mov    0x24(%eax),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 c0                	je     80103490 <pipewrite+0x60>
        release(&p->lock);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	53                   	push   %ebx
801034d4:	e8 87 15 00 00       	call   80104a60 <release>
        return -1;
801034d9:	83 c4 10             	add    $0x10,%esp
801034dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034e4:	5b                   	pop    %ebx
801034e5:	5e                   	pop    %esi
801034e6:	5f                   	pop    %edi
801034e7:	5d                   	pop    %ebp
801034e8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034e9:	89 c2                	mov    %eax,%edx
801034eb:	90                   	nop
801034ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034f0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034f3:	8d 42 01             	lea    0x1(%edx),%eax
801034f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034fc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103502:	83 c6 01             	add    $0x1,%esi
80103505:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103509:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010350c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010350f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103513:	0f 85 4f ff ff ff    	jne    80103468 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103519:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	50                   	push   %eax
80103523:	e8 08 0d 00 00       	call   80104230 <wakeup>
  release(&p->lock);
80103528:	89 1c 24             	mov    %ebx,(%esp)
8010352b:	e8 30 15 00 00       	call   80104a60 <release>
  return n;
80103530:	83 c4 10             	add    $0x10,%esp
80103533:	8b 45 10             	mov    0x10(%ebp),%eax
80103536:	eb a9                	jmp    801034e1 <pipewrite+0xb1>
80103538:	90                   	nop
80103539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103540 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
80103545:	53                   	push   %ebx
80103546:	83 ec 18             	sub    $0x18,%esp
80103549:	8b 75 08             	mov    0x8(%ebp),%esi
8010354c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010354f:	56                   	push   %esi
80103550:	e8 4b 14 00 00       	call   801049a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103555:	83 c4 10             	add    $0x10,%esp
80103558:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010355e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103564:	75 6a                	jne    801035d0 <piperead+0x90>
80103566:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010356c:	85 db                	test   %ebx,%ebx
8010356e:	0f 84 c4 00 00 00    	je     80103638 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103574:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010357a:	eb 2d                	jmp    801035a9 <piperead+0x69>
8010357c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103580:	83 ec 08             	sub    $0x8,%esp
80103583:	56                   	push   %esi
80103584:	53                   	push   %ebx
80103585:	e8 f6 0b 00 00       	call   80104180 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010358a:	83 c4 10             	add    $0x10,%esp
8010358d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103593:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103599:	75 35                	jne    801035d0 <piperead+0x90>
8010359b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035a1:	85 d2                	test   %edx,%edx
801035a3:	0f 84 8f 00 00 00    	je     80103638 <piperead+0xf8>
    if(myproc()->killed){
801035a9:	e8 72 03 00 00       	call   80103920 <myproc>
801035ae:	8b 48 24             	mov    0x24(%eax),%ecx
801035b1:	85 c9                	test   %ecx,%ecx
801035b3:	74 cb                	je     80103580 <piperead+0x40>
      release(&p->lock);
801035b5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035bd:	56                   	push   %esi
801035be:	e8 9d 14 00 00       	call   80104a60 <release>
      return -1;
801035c3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035c9:	89 d8                	mov    %ebx,%eax
801035cb:	5b                   	pop    %ebx
801035cc:	5e                   	pop    %esi
801035cd:	5f                   	pop    %edi
801035ce:	5d                   	pop    %ebp
801035cf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d0:	8b 45 10             	mov    0x10(%ebp),%eax
801035d3:	85 c0                	test   %eax,%eax
801035d5:	7e 61                	jle    80103638 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035d7:	31 db                	xor    %ebx,%ebx
801035d9:	eb 13                	jmp    801035ee <piperead+0xae>
801035db:	90                   	nop
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035e0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035e6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ec:	74 1f                	je     8010360d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ee:	8d 41 01             	lea    0x1(%ecx),%eax
801035f1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035f7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035fd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103602:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103605:	83 c3 01             	add    $0x1,%ebx
80103608:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010360b:	75 d3                	jne    801035e0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010360d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103613:	83 ec 0c             	sub    $0xc,%esp
80103616:	50                   	push   %eax
80103617:	e8 14 0c 00 00       	call   80104230 <wakeup>
  release(&p->lock);
8010361c:	89 34 24             	mov    %esi,(%esp)
8010361f:	e8 3c 14 00 00       	call   80104a60 <release>
  return i;
80103624:	83 c4 10             	add    $0x10,%esp
}
80103627:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010362a:	89 d8                	mov    %ebx,%eax
8010362c:	5b                   	pop    %ebx
8010362d:	5e                   	pop    %esi
8010362e:	5f                   	pop    %edi
8010362f:	5d                   	pop    %ebp
80103630:	c3                   	ret    
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103638:	31 db                	xor    %ebx,%ebx
8010363a:	eb d1                	jmp    8010360d <piperead+0xcd>
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	57                   	push   %edi
80103644:	56                   	push   %esi
80103645:	53                   	push   %ebx
  ushort padding6;
};

static inline int cas(volatile void *addr, int expected, int newval){
  int ret;
    asm volatile("movl %2 , %%eax\n\t"
80103646:	be 05 00 00 00       	mov    $0x5,%esi
8010364b:	89 c3                	mov    %eax,%ebx
8010364d:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  pushcli();
80103650:	e8 7b 12 00 00       	call   801048d0 <pushcli>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103655:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
8010365a:	b9 06 00 00 00       	mov    $0x6,%ecx
8010365f:	90                   	nop
    while(p->state == NEG_SLEEPING){}//waiting for this state to change
80103660:	8b 42 0c             	mov    0xc(%edx),%eax
80103663:	83 f8 04             	cmp    $0x4,%eax
80103666:	74 f8                	je     80103660 <wakeup1+0x20>
    if (p->state == SLEEPING && p->chan == chan){
80103668:	8b 7a 0c             	mov    0xc(%edx),%edi
8010366b:	83 ff 03             	cmp    $0x3,%edi
8010366e:	74 20                	je     80103690 <wakeup1+0x50>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103670:	81 c2 10 01 00 00    	add    $0x110,%edx
80103676:	81 fa 54 81 11 80    	cmp    $0x80118154,%edx
8010367c:	72 e2                	jb     80103660 <wakeup1+0x20>
            panic("at waikup1: second cas has failed");
        }
    }
  }
  popcli();
}
8010367e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103681:	5b                   	pop    %ebx
80103682:	5e                   	pop    %esi
80103683:	5f                   	pop    %edi
80103684:	5d                   	pop    %ebp
  popcli();
80103685:	e9 86 12 00 00       	jmp    80104910 <popcli>
8010368a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (p->state == SLEEPING && p->chan == chan){
80103690:	39 5a 20             	cmp    %ebx,0x20(%edx)
80103693:	75 db                	jne    80103670 <wakeup1+0x30>
80103695:	89 f8                	mov    %edi,%eax
80103697:	f0 0f b1 4a 0c       	lock cmpxchg %ecx,0xc(%edx)
8010369c:	9c                   	pushf  
8010369d:	5f                   	pop    %edi
8010369e:	83 e7 40             	and    $0x40,%edi
        if(cas(&p->state, SLEEPING, NEG_RUNNABLE)){
801036a1:	85 ff                	test   %edi,%edi
801036a3:	74 cb                	je     80103670 <wakeup1+0x30>
          p->chan=0;
801036a5:	c7 42 20 00 00 00 00 	movl   $0x0,0x20(%edx)
801036ac:	89 c8                	mov    %ecx,%eax
801036ae:	f0 0f b1 72 0c       	lock cmpxchg %esi,0xc(%edx)
801036b3:	9c                   	pushf  
801036b4:	5f                   	pop    %edi
801036b5:	83 e7 40             	and    $0x40,%edi
          if(!cas(&p->state, NEG_RUNNABLE, RUNNABLE))
801036b8:	85 ff                	test   %edi,%edi
801036ba:	75 b4                	jne    80103670 <wakeup1+0x30>
            panic("at waikup1: second cas has failed");
801036bc:	83 ec 0c             	sub    $0xc,%esp
801036bf:	68 58 7b 10 80       	push   $0x80107b58
801036c4:	e8 c7 cc ff ff       	call   80100390 <panic>
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036d0 <allocproc>:
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801036d9:	e8 f2 11 00 00       	call   801048d0 <pushcli>
801036de:	31 c9                	xor    %ecx,%ecx
801036e0:	ba 02 00 00 00       	mov    $0x2,%edx
801036e5:	8d 76 00             	lea    0x0(%esi),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036e8:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801036ed:	eb 0f                	jmp    801036fe <allocproc+0x2e>
801036ef:	90                   	nop
801036f0:	81 c3 10 01 00 00    	add    $0x110,%ebx
801036f6:	81 fb 54 81 11 80    	cmp    $0x80118154,%ebx
801036fc:	73 07                	jae    80103705 <allocproc+0x35>
      if (p->state == UNUSED)
801036fe:	8b 43 0c             	mov    0xc(%ebx),%eax
80103701:	85 c0                	test   %eax,%eax
80103703:	75 eb                	jne    801036f0 <allocproc+0x20>
    if (p == &ptable.proc[NPROC])
80103705:	81 fb 54 81 11 80    	cmp    $0x80118154,%ebx
8010370b:	0f 84 da 00 00 00    	je     801037eb <allocproc+0x11b>
80103711:	89 c8                	mov    %ecx,%eax
80103713:	f0 0f b1 53 0c       	lock cmpxchg %edx,0xc(%ebx)
80103718:	9c                   	pushf  
80103719:	5e                   	pop    %esi
8010371a:	83 e6 40             	and    $0x40,%esi
  } while (!cas(&p->state, UNUSED, EMBRYO)); //changing the state,but in an atomic way
8010371d:	85 f6                	test   %esi,%esi
8010371f:	74 c7                	je     801036e8 <allocproc+0x18>
  popcli();
80103721:	e8 ea 11 00 00       	call   80104910 <popcli>
80103726:	8d 76 00             	lea    0x0(%esi),%esi
80103729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pid = nextpid;
80103730:	8b 0d 04 b0 10 80    	mov    0x8010b004,%ecx
  } while (!cas(&nextpid, pid, pid + 1));
80103736:	8d 51 01             	lea    0x1(%ecx),%edx
80103739:	89 c8                	mov    %ecx,%eax
8010373b:	f0 0f b1 15 04 b0 10 	lock cmpxchg %edx,0x8010b004
80103742:	80 
80103743:	9c                   	pushf  
80103744:	5a                   	pop    %edx
80103745:	83 e2 40             	and    $0x40,%edx
80103748:	85 d2                	test   %edx,%edx
8010374a:	74 e4                	je     80103730 <allocproc+0x60>
  p->pid = allocpid();
8010374c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  if ((p->kstack = kalloc()) == 0)
8010374f:	e8 ac ed ff ff       	call   80102500 <kalloc>
80103754:	85 c0                	test   %eax,%eax
80103756:	89 c7                	mov    %eax,%edi
80103758:	89 43 08             	mov    %eax,0x8(%ebx)
8010375b:	0f 84 9b 00 00 00    	je     801037fc <allocproc+0x12c>
  sp -= sizeof *p->tf;
80103761:	8d 80 b4 0f 00 00    	lea    0xfb4(%eax),%eax
  sp -= sizeof *p->context;
80103767:	8d b7 9c 0f 00 00    	lea    0xf9c(%edi),%esi
  memset(p->context, 0, sizeof *p->context);
8010376d:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->tf;
80103770:	89 43 18             	mov    %eax,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
80103773:	c7 87 b0 0f 00 00 87 	movl   $0x80105d87,0xfb0(%edi)
8010377a:	5d 10 80 
  p->context = (struct context *)sp;
8010377d:	89 73 1c             	mov    %esi,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103780:	6a 14                	push   $0x14
80103782:	6a 00                	push   $0x0
80103784:	56                   	push   %esi
80103785:	e8 26 13 00 00       	call   80104ab0 <memset>
  p->context->eip = (uint)forkret;
8010378a:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010378d:	8d 97 1c 0f 00 00    	lea    0xf1c(%edi),%edx
80103793:	83 c4 10             	add    $0x10,%esp
80103796:	c7 40 10 10 38 10 80 	movl   $0x80103810,0x10(%eax)
8010379d:	8d 83 08 01 00 00    	lea    0x108(%ebx),%eax
801037a3:	90                   	nop
801037a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sp -= (sizeof (struct sigaction *));
801037a8:	83 ee 04             	sub    $0x4,%esi
801037ab:	83 e8 04             	sub    $0x4,%eax
    p->signal_handlers[31-k] = (struct sigaction *)sp;
801037ae:	89 70 04             	mov    %esi,0x4(%eax)
  for(int k = 0; k<32; k++){// allocating space for the new fields and initializing them
801037b1:	39 d6                	cmp    %edx,%esi
801037b3:	75 f3                	jne    801037a8 <allocproc+0xd8>
801037b5:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
801037bb:	8d 8b 0c 01 00 00    	lea    0x10c(%ebx),%ecx
801037c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->signal_handlers[k]->sa_handler = (void *) SIG_DFL;
801037c8:	8b 10                	mov    (%eax),%edx
801037ca:	83 c0 04             	add    $0x4,%eax
801037cd:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
    p->signal_handlers[k]->sigmask = 0;
801037d3:	8b 50 fc             	mov    -0x4(%eax),%edx
  for(int k = 0; k<32; k++){
801037d6:	39 c1                	cmp    %eax,%ecx
    p->signal_handlers[k]->sigmask = 0;
801037d8:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
  for(int k = 0; k<32; k++){
801037df:	75 e7                	jne    801037c8 <allocproc+0xf8>
}
801037e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037e4:	89 d8                	mov    %ebx,%eax
801037e6:	5b                   	pop    %ebx
801037e7:	5e                   	pop    %esi
801037e8:	5f                   	pop    %edi
801037e9:	5d                   	pop    %ebp
801037ea:	c3                   	ret    
      return 0;
801037eb:	31 db                	xor    %ebx,%ebx
      popcli();
801037ed:	e8 1e 11 00 00       	call   80104910 <popcli>
}
801037f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f5:	89 d8                	mov    %ebx,%eax
801037f7:	5b                   	pop    %ebx
801037f8:	5e                   	pop    %esi
801037f9:	5f                   	pop    %edi
801037fa:	5d                   	pop    %ebp
801037fb:	c3                   	ret    
    p->state = UNUSED;
801037fc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103803:	31 db                	xor    %ebx,%ebx
80103805:	eb eb                	jmp    801037f2 <allocproc+0x122>
80103807:	89 f6                	mov    %esi,%esi
80103809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103810 <forkret>:
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	83 ec 08             	sub    $0x8,%esp
  popcli();
80103816:	e8 f5 10 00 00       	call   80104910 <popcli>
  if (first)
8010381b:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103820:	85 c0                	test   %eax,%eax
80103822:	75 0c                	jne    80103830 <forkret+0x20>
}
80103824:	c9                   	leave  
80103825:	c3                   	ret    
80103826:	8d 76 00             	lea    0x0(%esi),%esi
80103829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iinit(ROOTDEV);
80103830:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103833:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010383a:	00 00 00 
    iinit(ROOTDEV);
8010383d:	6a 01                	push   $0x1
8010383f:	e8 6c dc ff ff       	call   801014b0 <iinit>
    initlog(ROOTDEV);
80103844:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010384b:	e8 f0 f2 ff ff       	call   80102b40 <initlog>
80103850:	83 c4 10             	add    $0x10,%esp
}
80103853:	c9                   	leave  
80103854:	c3                   	ret    
80103855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103860 <pinit>:
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103866:	68 d7 7b 10 80       	push   $0x80107bd7
8010386b:	68 20 3d 11 80       	push   $0x80113d20
80103870:	e8 eb 0f 00 00       	call   80104860 <initlock>
}
80103875:	83 c4 10             	add    $0x10,%esp
80103878:	c9                   	leave  
80103879:	c3                   	ret    
8010387a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103880 <mycpu>:
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	56                   	push   %esi
80103884:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103885:	9c                   	pushf  
80103886:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103887:	f6 c4 02             	test   $0x2,%ah
8010388a:	75 5e                	jne    801038ea <mycpu+0x6a>
  apicid = lapicid();
8010388c:	e8 df ee ff ff       	call   80102770 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103891:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103897:	85 f6                	test   %esi,%esi
80103899:	7e 42                	jle    801038dd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010389b:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
801038a2:	39 d0                	cmp    %edx,%eax
801038a4:	74 30                	je     801038d6 <mycpu+0x56>
801038a6:	b9 30 38 11 80       	mov    $0x80113830,%ecx
  for (i = 0; i < ncpu; ++i)
801038ab:	31 d2                	xor    %edx,%edx
801038ad:	8d 76 00             	lea    0x0(%esi),%esi
801038b0:	83 c2 01             	add    $0x1,%edx
801038b3:	39 f2                	cmp    %esi,%edx
801038b5:	74 26                	je     801038dd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801038b7:	0f b6 19             	movzbl (%ecx),%ebx
801038ba:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801038c0:	39 c3                	cmp    %eax,%ebx
801038c2:	75 ec                	jne    801038b0 <mycpu+0x30>
801038c4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801038ca:	05 80 37 11 80       	add    $0x80113780,%eax
}
801038cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038d2:	5b                   	pop    %ebx
801038d3:	5e                   	pop    %esi
801038d4:	5d                   	pop    %ebp
801038d5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801038d6:	b8 80 37 11 80       	mov    $0x80113780,%eax
      return &cpus[i];
801038db:	eb f2                	jmp    801038cf <mycpu+0x4f>
  panic("unknown apicid\n");
801038dd:	83 ec 0c             	sub    $0xc,%esp
801038e0:	68 de 7b 10 80       	push   $0x80107bde
801038e5:	e8 a6 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801038ea:	83 ec 0c             	sub    $0xc,%esp
801038ed:	68 7c 7b 10 80       	push   $0x80107b7c
801038f2:	e8 99 ca ff ff       	call   80100390 <panic>
801038f7:	89 f6                	mov    %esi,%esi
801038f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103900 <cpuid>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80103906:	e8 75 ff ff ff       	call   80103880 <mycpu>
8010390b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103910:	c9                   	leave  
  return mycpu() - cpus;
80103911:	c1 f8 04             	sar    $0x4,%eax
80103914:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010391a:	c3                   	ret    
8010391b:	90                   	nop
8010391c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103920 <myproc>:
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	53                   	push   %ebx
80103924:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103927:	e8 a4 0f 00 00       	call   801048d0 <pushcli>
  c = mycpu();
8010392c:	e8 4f ff ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103931:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103937:	e8 d4 0f 00 00       	call   80104910 <popcli>
}
8010393c:	83 c4 04             	add    $0x4,%esp
8010393f:	89 d8                	mov    %ebx,%eax
80103941:	5b                   	pop    %ebx
80103942:	5d                   	pop    %ebp
80103943:	c3                   	ret    
80103944:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010394a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103950 <allocpid>:
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	90                   	nop
80103954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pid = nextpid;
80103958:	8b 0d 04 b0 10 80    	mov    0x8010b004,%ecx
  } while (!cas(&nextpid, pid, pid + 1));
8010395e:	8d 51 01             	lea    0x1(%ecx),%edx
    asm volatile("movl %2 , %%eax\n\t"
80103961:	89 c8                	mov    %ecx,%eax
80103963:	f0 0f b1 15 04 b0 10 	lock cmpxchg %edx,0x8010b004
8010396a:	80 
8010396b:	9c                   	pushf  
8010396c:	5a                   	pop    %edx
8010396d:	83 e2 40             	and    $0x40,%edx
80103970:	85 d2                	test   %edx,%edx
80103972:	74 e4                	je     80103958 <allocpid+0x8>
}
80103974:	89 c8                	mov    %ecx,%eax
80103976:	5d                   	pop    %ebp
80103977:	c3                   	ret    
80103978:	90                   	nop
80103979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103980 <userinit>:
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
80103984:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103987:	e8 44 fd ff ff       	call   801036d0 <allocproc>
8010398c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010398e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if ((p->pgdir = setupkvm()) == 0)
80103993:	e8 c8 39 00 00       	call   80107360 <setupkvm>
80103998:	85 c0                	test   %eax,%eax
8010399a:	89 43 04             	mov    %eax,0x4(%ebx)
8010399d:	0f 84 06 01 00 00    	je     80103aa9 <userinit+0x129>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039a3:	83 ec 04             	sub    $0x4,%esp
801039a6:	68 2c 00 00 00       	push   $0x2c
801039ab:	68 60 b4 10 80       	push   $0x8010b460
801039b0:	50                   	push   %eax
801039b1:	e8 8a 36 00 00       	call   80107040 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039b6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039b9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039bf:	6a 4c                	push   $0x4c
801039c1:	6a 00                	push   $0x0
801039c3:	ff 73 18             	pushl  0x18(%ebx)
801039c6:	e8 e5 10 00 00       	call   80104ab0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039cb:	8b 43 18             	mov    0x18(%ebx),%eax
801039ce:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039d3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039d8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039db:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039df:	8b 43 18             	mov    0x18(%ebx),%eax
801039e2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039e6:	8b 43 18             	mov    0x18(%ebx),%eax
801039e9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039ed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039f1:	8b 43 18             	mov    0x18(%ebx),%eax
801039f4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039f8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039fc:	8b 43 18             	mov    0x18(%ebx),%eax
801039ff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a06:	8b 43 18             	mov    0x18(%ebx),%eax
80103a09:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103a10:	8b 43 18             	mov    0x18(%ebx),%eax
80103a13:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a1a:	8d 43 70             	lea    0x70(%ebx),%eax
80103a1d:	6a 10                	push   $0x10
80103a1f:	68 07 7c 10 80       	push   $0x80107c07
80103a24:	50                   	push   %eax
80103a25:	e8 66 12 00 00       	call   80104c90 <safestrcpy>
  p->cwd = namei("/");
80103a2a:	c7 04 24 10 7c 10 80 	movl   $0x80107c10,(%esp)
80103a31:	e8 da e4 ff ff       	call   80101f10 <namei>
80103a36:	89 43 6c             	mov    %eax,0x6c(%ebx)
  pushcli();
80103a39:	e8 92 0e 00 00       	call   801048d0 <pushcli>
80103a3e:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
80103a44:	8d 8b 0c 01 00 00    	lea    0x10c(%ebx),%ecx
  p->stopped = 0;
80103a4a:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
  p->killed = 0;
80103a51:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
  p->pending_signals = 0;
80103a58:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103a5f:	00 00 00 
80103a62:	83 c4 10             	add    $0x10,%esp
  p->signal_mask = 0;
80103a65:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103a6c:	00 00 00 
  p->userspace_trapframe_backup = 0;
80103a6f:	c7 83 0c 01 00 00 00 	movl   $0x0,0x10c(%ebx)
80103a76:	00 00 00 
80103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->signal_handlers[i]->sa_handler = (void *)SIG_DFL;
80103a80:	8b 10                	mov    (%eax),%edx
80103a82:	83 c0 04             	add    $0x4,%eax
80103a85:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
    p->signal_handlers[i]->sigmask = 0;
80103a8b:	8b 50 fc             	mov    -0x4(%eax),%edx
  for (int i = 0; i < 32; i++)
80103a8e:	39 c8                	cmp    %ecx,%eax
    p->signal_handlers[i]->sigmask = 0;
80103a90:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
  for (int i = 0; i < 32; i++)
80103a97:	75 e7                	jne    80103a80 <userinit+0x100>
  p->state = RUNNABLE; //now, the proccess is ready
80103a99:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
}
80103aa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aa3:	c9                   	leave  
  popcli();
80103aa4:	e9 67 0e 00 00       	jmp    80104910 <popcli>
    panic("userinit: out of memory?");
80103aa9:	83 ec 0c             	sub    $0xc,%esp
80103aac:	68 ee 7b 10 80       	push   $0x80107bee
80103ab1:	e8 da c8 ff ff       	call   80100390 <panic>
80103ab6:	8d 76 00             	lea    0x0(%esi),%esi
80103ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ac0 <growproc>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
80103ac5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ac8:	e8 03 0e 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80103acd:	e8 ae fd ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103ad2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad8:	e8 33 0e 00 00       	call   80104910 <popcli>
  if (n > 0)
80103add:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103ae0:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80103ae2:	7f 1c                	jg     80103b00 <growproc+0x40>
  else if (n < 0)
80103ae4:	75 3a                	jne    80103b20 <growproc+0x60>
  switchuvm(curproc);
80103ae6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ae9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aeb:	53                   	push   %ebx
80103aec:	e8 3f 34 00 00       	call   80106f30 <switchuvm>
  return 0;
80103af1:	83 c4 10             	add    $0x10,%esp
80103af4:	31 c0                	xor    %eax,%eax
}
80103af6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103af9:	5b                   	pop    %ebx
80103afa:	5e                   	pop    %esi
80103afb:	5d                   	pop    %ebp
80103afc:	c3                   	ret    
80103afd:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b00:	83 ec 04             	sub    $0x4,%esp
80103b03:	01 c6                	add    %eax,%esi
80103b05:	56                   	push   %esi
80103b06:	50                   	push   %eax
80103b07:	ff 73 04             	pushl  0x4(%ebx)
80103b0a:	e8 71 36 00 00       	call   80107180 <allocuvm>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 d0                	jne    80103ae6 <growproc+0x26>
      return -1;
80103b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b1b:	eb d9                	jmp    80103af6 <growproc+0x36>
80103b1d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b20:	83 ec 04             	sub    $0x4,%esp
80103b23:	01 c6                	add    %eax,%esi
80103b25:	56                   	push   %esi
80103b26:	50                   	push   %eax
80103b27:	ff 73 04             	pushl  0x4(%ebx)
80103b2a:	e8 81 37 00 00       	call   801072b0 <deallocuvm>
80103b2f:	83 c4 10             	add    $0x10,%esp
80103b32:	85 c0                	test   %eax,%eax
80103b34:	75 b0                	jne    80103ae6 <growproc+0x26>
80103b36:	eb de                	jmp    80103b16 <growproc+0x56>
80103b38:	90                   	nop
80103b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b40 <fork>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	57                   	push   %edi
80103b44:	56                   	push   %esi
80103b45:	53                   	push   %ebx
80103b46:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b49:	e8 82 0d 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80103b4e:	e8 2d fd ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103b53:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b59:	e8 b2 0d 00 00       	call   80104910 <popcli>
  if ((np = allocproc()) == 0)
80103b5e:	e8 6d fb ff ff       	call   801036d0 <allocproc>
80103b63:	85 c0                	test   %eax,%eax
80103b65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b68:	0f 84 fe 00 00 00    	je     80103c6c <fork+0x12c>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80103b6e:	83 ec 08             	sub    $0x8,%esp
80103b71:	ff 33                	pushl  (%ebx)
80103b73:	ff 73 04             	pushl  0x4(%ebx)
80103b76:	e8 b5 38 00 00       	call   80107430 <copyuvm>
80103b7b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b7e:	83 c4 10             	add    $0x10,%esp
80103b81:	85 c0                	test   %eax,%eax
80103b83:	89 42 04             	mov    %eax,0x4(%edx)
80103b86:	0f 84 e7 00 00 00    	je     80103c73 <fork+0x133>
  np->sz = curproc->sz;
80103b8c:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80103b8e:	8b 7a 18             	mov    0x18(%edx),%edi
80103b91:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
80103b96:	89 5a 14             	mov    %ebx,0x14(%edx)
  np->sz = curproc->sz;
80103b99:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80103b9b:	8b 73 18             	mov    0x18(%ebx),%esi
80103b9e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80103ba0:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ba2:	8b 42 18             	mov    0x18(%edx),%eax
80103ba5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[i])
80103bb0:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103bb4:	85 c0                	test   %eax,%eax
80103bb6:	74 16                	je     80103bce <fork+0x8e>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bb8:	83 ec 0c             	sub    $0xc,%esp
80103bbb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103bbe:	50                   	push   %eax
80103bbf:	e8 5c d2 ff ff       	call   80100e20 <filedup>
80103bc4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bc7:	83 c4 10             	add    $0x10,%esp
80103bca:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for (i = 0; i < NOFILE; i++)
80103bce:	83 c6 01             	add    $0x1,%esi
80103bd1:	83 fe 10             	cmp    $0x10,%esi
80103bd4:	75 da                	jne    80103bb0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103bd6:	83 ec 0c             	sub    $0xc,%esp
80103bd9:	ff 73 6c             	pushl  0x6c(%ebx)
80103bdc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103bdf:	e8 9c da ff ff       	call   80101680 <idup>
80103be4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103be7:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bea:	89 42 6c             	mov    %eax,0x6c(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bed:	8d 43 70             	lea    0x70(%ebx),%eax
80103bf0:	6a 10                	push   $0x10
80103bf2:	50                   	push   %eax
80103bf3:	8d 42 70             	lea    0x70(%edx),%eax
80103bf6:	50                   	push   %eax
80103bf7:	e8 94 10 00 00       	call   80104c90 <safestrcpy>
  pid = np->pid;
80103bfc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bff:	83 c4 10             	add    $0x10,%esp
  for (j = 0; j < 32; j++)
80103c02:	31 c0                	xor    %eax,%eax
  pid = np->pid;
80103c04:	8b 72 10             	mov    0x10(%edx),%esi
80103c07:	89 f6                	mov    %esi,%esi
80103c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    np->signal_handlers[j] = curproc->signal_handlers[j];
80103c10:	8b 8c 83 8c 00 00 00 	mov    0x8c(%ebx,%eax,4),%ecx
80103c17:	89 8c 82 8c 00 00 00 	mov    %ecx,0x8c(%edx,%eax,4)
  for (j = 0; j < 32; j++)
80103c1e:	83 c0 01             	add    $0x1,%eax
80103c21:	83 f8 20             	cmp    $0x20,%eax
80103c24:	75 ea                	jne    80103c10 <fork+0xd0>
  np->signal_mask = curproc->signal_mask;
80103c26:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  np->pending_signals = 0;
80103c2c:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
80103c33:	00 00 00 
80103c36:	bb 05 00 00 00       	mov    $0x5,%ebx
80103c3b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  np->signal_mask = curproc->signal_mask;
80103c3e:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  pushcli();
80103c44:	e8 87 0c 00 00       	call   801048d0 <pushcli>
80103c49:	b9 02 00 00 00       	mov    $0x2,%ecx
80103c4e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c51:	89 c8                	mov    %ecx,%eax
80103c53:	f0 0f b1 5a 0c       	lock cmpxchg %ebx,0xc(%edx)
80103c58:	9c                   	pushf  
80103c59:	59                   	pop    %ecx
80103c5a:	83 e1 40             	and    $0x40,%ecx
  popcli();
80103c5d:	e8 ae 0c 00 00       	call   80104910 <popcli>
}
80103c62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c65:	89 f0                	mov    %esi,%eax
80103c67:	5b                   	pop    %ebx
80103c68:	5e                   	pop    %esi
80103c69:	5f                   	pop    %edi
80103c6a:	5d                   	pop    %ebp
80103c6b:	c3                   	ret    
    return -1;
80103c6c:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103c71:	eb ef                	jmp    80103c62 <fork+0x122>
    pushcli();
80103c73:	e8 58 0c 00 00       	call   801048d0 <pushcli>
    kfree(np->kstack);
80103c78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c7b:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103c7e:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103c83:	ff 72 08             	pushl  0x8(%edx)
80103c86:	e8 c5 e6 ff ff       	call   80102350 <kfree>
    np->kstack = 0;
80103c8b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c8e:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
80103c95:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    popcli();
80103c9c:	e8 6f 0c 00 00       	call   80104910 <popcli>
    return -1;
80103ca1:	83 c4 10             	add    $0x10,%esp
80103ca4:	eb bc                	jmp    80103c62 <fork+0x122>
80103ca6:	8d 76 00             	lea    0x0(%esi),%esi
80103ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cb0 <scheduler>:
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	57                   	push   %edi
80103cb4:	56                   	push   %esi
80103cb5:	53                   	push   %ebx
80103cb6:	bf 05 00 00 00       	mov    $0x5,%edi
80103cbb:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103cbe:	e8 bd fb ff ff       	call   80103880 <mycpu>
  c->proc = 0;
80103cc3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103cca:	00 00 00 
  struct cpu *c = mycpu();
80103ccd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103cd0:	83 c0 04             	add    $0x4,%eax
80103cd3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103cd6:	8d 76 00             	lea    0x0(%esi),%esi
80103cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  asm volatile("sti");
80103ce0:	fb                   	sti    
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ce1:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
    pushcli();
80103ce6:	e8 e5 0b 00 00       	call   801048d0 <pushcli>
80103ceb:	eb 22                	jmp    80103d0f <scheduler+0x5f>
80103ced:	8d 76 00             	lea    0x0(%esi),%esi
      c->proc = 0;
80103cf0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103cf3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103cfa:	00 00 00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cfd:	81 c3 10 01 00 00    	add    $0x110,%ebx
80103d03:	81 fb 54 81 11 80    	cmp    $0x80118154,%ebx
80103d09:	0f 83 d1 00 00 00    	jae    80103de0 <scheduler+0x130>
80103d0f:	8d 73 0c             	lea    0xc(%ebx),%esi
    asm volatile("movl %2 , %%eax\n\t"
80103d12:	b9 08 00 00 00       	mov    $0x8,%ecx
80103d17:	89 f8                	mov    %edi,%eax
80103d19:	f0 0f b1 4b 0c       	lock cmpxchg %ecx,0xc(%ebx)
80103d1e:	9c                   	pushf  
80103d1f:	5a                   	pop    %edx
80103d20:	83 e2 40             	and    $0x40,%edx
      if (!cas(&(p->state), RUNNABLE, NEG_RUNNING)) //if we couldnt change it's state
80103d23:	85 d2                	test   %edx,%edx
80103d25:	74 d6                	je     80103cfd <scheduler+0x4d>
      c->proc = p;
80103d27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d2a:	ba 07 00 00 00       	mov    $0x7,%edx
80103d2f:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
80103d35:	89 c8                	mov    %ecx,%eax
80103d37:	f0 0f b1 53 0c       	lock cmpxchg %edx,0xc(%ebx)
80103d3c:	9c                   	pushf  
80103d3d:	5a                   	pop    %edx
80103d3e:	83 e2 40             	and    $0x40,%edx
      switchuvm(p);
80103d41:	83 ec 0c             	sub    $0xc,%esp
80103d44:	53                   	push   %ebx
80103d45:	e8 e6 31 00 00       	call   80106f30 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d4a:	58                   	pop    %eax
80103d4b:	5a                   	pop    %edx
80103d4c:	ff 73 1c             	pushl  0x1c(%ebx)
80103d4f:	ff 75 e0             	pushl  -0x20(%ebp)
80103d52:	e8 94 0f 00 00       	call   80104ceb <swtch>
      switchkvm();
80103d57:	e8 b4 31 00 00       	call   80106f10 <switchkvm>
80103d5c:	ba 06 00 00 00       	mov    $0x6,%edx
80103d61:	89 d0                	mov    %edx,%eax
80103d63:	f0 0f b1 7b 0c       	lock cmpxchg %edi,0xc(%ebx)
80103d68:	9c                   	pushf  
80103d69:	5a                   	pop    %edx
80103d6a:	83 e2 40             	and    $0x40,%edx
80103d6d:	b9 03 00 00 00       	mov    $0x3,%ecx
80103d72:	ba 04 00 00 00       	mov    $0x4,%edx
80103d77:	89 d0                	mov    %edx,%eax
80103d79:	f0 0f b1 4b 0c       	lock cmpxchg %ecx,0xc(%ebx)
80103d7e:	9c                   	pushf  
80103d7f:	5a                   	pop    %edx
80103d80:	83 e2 40             	and    $0x40,%edx
      if (cas(&(p->state), NEG_SLEEPING, SLEEPING))
80103d83:	83 c4 10             	add    $0x10,%esp
80103d86:	85 d2                	test   %edx,%edx
80103d88:	74 16                	je     80103da0 <scheduler+0xf0>
        if (p->killed == 1)
80103d8a:	83 7b 24 01          	cmpl   $0x1,0x24(%ebx)
80103d8e:	75 10                	jne    80103da0 <scheduler+0xf0>
80103d90:	89 c8                	mov    %ecx,%eax
80103d92:	f0 0f b1 3e          	lock cmpxchg %edi,(%esi)
80103d96:	9c                   	pushf  
80103d97:	59                   	pop    %ecx
80103d98:	83 e1 40             	and    $0x40,%ecx
80103d9b:	90                   	nop
80103d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103da0:	ba 06 00 00 00       	mov    $0x6,%edx
80103da5:	89 d0                	mov    %edx,%eax
80103da7:	f0 0f b1 3e          	lock cmpxchg %edi,(%esi)
80103dab:	9c                   	pushf  
80103dac:	5a                   	pop    %edx
80103dad:	83 e2 40             	and    $0x40,%edx
80103db0:	ba 0a 00 00 00       	mov    $0xa,%edx
80103db5:	b9 09 00 00 00       	mov    $0x9,%ecx
80103dba:	89 d0                	mov    %edx,%eax
80103dbc:	f0 0f b1 0e          	lock cmpxchg %ecx,(%esi)
80103dc0:	9c                   	pushf  
80103dc1:	5a                   	pop    %edx
80103dc2:	83 e2 40             	and    $0x40,%edx
      if (cas(&(p->state), NEG_ZOMBIE, ZOMBIE))
80103dc5:	85 d2                	test   %edx,%edx
80103dc7:	0f 84 23 ff ff ff    	je     80103cf0 <scheduler+0x40>
        wakeup1(p->parent);
80103dcd:	8b 43 14             	mov    0x14(%ebx),%eax
80103dd0:	e8 6b f8 ff ff       	call   80103640 <wakeup1>
80103dd5:	e9 16 ff ff ff       	jmp    80103cf0 <scheduler+0x40>
80103dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    popcli();
80103de0:	e8 2b 0b 00 00       	call   80104910 <popcli>
    sti();
80103de5:	e9 f6 fe ff ff       	jmp    80103ce0 <scheduler+0x30>
80103dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103df0 <sched>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	56                   	push   %esi
80103df4:	53                   	push   %ebx
  pushcli();
80103df5:	e8 d6 0a 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80103dfa:	e8 81 fa ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103dff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e05:	e8 06 0b 00 00       	call   80104910 <popcli>
  if (mycpu()->ncli != 1)
80103e0a:	e8 71 fa ff ff       	call   80103880 <mycpu>
80103e0f:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e16:	75 43                	jne    80103e5b <sched+0x6b>
  if (p->state == RUNNING)
80103e18:	8b 43 0c             	mov    0xc(%ebx),%eax
80103e1b:	83 f8 07             	cmp    $0x7,%eax
80103e1e:	74 55                	je     80103e75 <sched+0x85>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e20:	9c                   	pushf  
80103e21:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103e22:	f6 c4 02             	test   $0x2,%ah
80103e25:	75 41                	jne    80103e68 <sched+0x78>
  intena = mycpu()->intena;
80103e27:	e8 54 fa ff ff       	call   80103880 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e2c:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e2f:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e35:	e8 46 fa ff ff       	call   80103880 <mycpu>
80103e3a:	83 ec 08             	sub    $0x8,%esp
80103e3d:	ff 70 04             	pushl  0x4(%eax)
80103e40:	53                   	push   %ebx
80103e41:	e8 a5 0e 00 00       	call   80104ceb <swtch>
  mycpu()->intena = intena;
80103e46:	e8 35 fa ff ff       	call   80103880 <mycpu>
}
80103e4b:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e4e:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e57:	5b                   	pop    %ebx
80103e58:	5e                   	pop    %esi
80103e59:	5d                   	pop    %ebp
80103e5a:	c3                   	ret    
    panic("sched locks");
80103e5b:	83 ec 0c             	sub    $0xc,%esp
80103e5e:	68 12 7c 10 80       	push   $0x80107c12
80103e63:	e8 28 c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103e68:	83 ec 0c             	sub    $0xc,%esp
80103e6b:	68 2c 7c 10 80       	push   $0x80107c2c
80103e70:	e8 1b c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103e75:	83 ec 0c             	sub    $0xc,%esp
80103e78:	68 1e 7c 10 80       	push   $0x80107c1e
80103e7d:	e8 0e c5 ff ff       	call   80100390 <panic>
80103e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e90 <exit>:
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	57                   	push   %edi
80103e94:	56                   	push   %esi
80103e95:	53                   	push   %ebx
80103e96:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103e99:	e8 32 0a 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80103e9e:	e8 dd f9 ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103ea3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ea9:	e8 62 0a 00 00       	call   80104910 <popcli>
  if (curproc == initproc)
80103eae:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103eb4:	8d 5e 2c             	lea    0x2c(%esi),%ebx
80103eb7:	8d 7e 6c             	lea    0x6c(%esi),%edi
80103eba:	0f 84 cd 00 00 00    	je     80103f8d <exit+0xfd>
    if (curproc->ofile[fd])
80103ec0:	8b 03                	mov    (%ebx),%eax
80103ec2:	85 c0                	test   %eax,%eax
80103ec4:	74 12                	je     80103ed8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103ec6:	83 ec 0c             	sub    $0xc,%esp
80103ec9:	50                   	push   %eax
80103eca:	e8 a1 cf ff ff       	call   80100e70 <fileclose>
      curproc->ofile[fd] = 0;
80103ecf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103ed5:	83 c4 10             	add    $0x10,%esp
80103ed8:	83 c3 04             	add    $0x4,%ebx
  for (fd = 0; fd < NOFILE; fd++)
80103edb:	39 df                	cmp    %ebx,%edi
80103edd:	75 e1                	jne    80103ec0 <exit+0x30>
  begin_op();
80103edf:	e8 fc ec ff ff       	call   80102be0 <begin_op>
  iput(curproc->cwd);
80103ee4:	83 ec 0c             	sub    $0xc,%esp
80103ee7:	ff 76 6c             	pushl  0x6c(%esi)
80103eea:	e8 f1 d8 ff ff       	call   801017e0 <iput>
  end_op();
80103eef:	e8 5c ed ff ff       	call   80102c50 <end_op>
  curproc->cwd = 0;
80103ef4:	c7 46 6c 00 00 00 00 	movl   $0x0,0x6c(%esi)
  pushcli();
80103efb:	e8 d0 09 00 00       	call   801048d0 <pushcli>
    asm volatile("movl %2 , %%eax\n\t"
80103f00:	ba 07 00 00 00       	mov    $0x7,%edx
80103f05:	b9 0a 00 00 00       	mov    $0xa,%ecx
80103f0a:	89 d0                	mov    %edx,%eax
80103f0c:	f0 0f b1 4e 0c       	lock cmpxchg %ecx,0xc(%esi)
80103f11:	9c                   	pushf  
80103f12:	5a                   	pop    %edx
80103f13:	83 e2 40             	and    $0x40,%edx
  if(!cas(&curproc->state, RUNNING, NEG_ZOMBIE)){
80103f16:	83 c4 10             	add    $0x10,%esp
80103f19:	85 d2                	test   %edx,%edx
80103f1b:	74 63                	je     80103f80 <exit+0xf0>
    wakeup1(curproc->parent);
80103f1d:	8b 46 14             	mov    0x14(%esi),%eax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f20:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
    wakeup1(curproc->parent);
80103f25:	e8 16 f7 ff ff       	call   80103640 <wakeup1>
80103f2a:	eb 12                	jmp    80103f3e <exit+0xae>
80103f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f30:	81 c3 10 01 00 00    	add    $0x110,%ebx
80103f36:	81 fb 54 81 11 80    	cmp    $0x80118154,%ebx
80103f3c:	73 30                	jae    80103f6e <exit+0xde>
    if (p->parent == curproc)
80103f3e:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f41:	75 ed                	jne    80103f30 <exit+0xa0>
      if(p->state == ZOMBIE || p->state == NEG_ZOMBIE)
80103f43:	8b 53 0c             	mov    0xc(%ebx),%edx
      p->parent = initproc;
80103f46:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
      if(p->state == ZOMBIE || p->state == NEG_ZOMBIE)
80103f4b:	83 fa 09             	cmp    $0x9,%edx
      p->parent = initproc;
80103f4e:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE || p->state == NEG_ZOMBIE)
80103f51:	74 08                	je     80103f5b <exit+0xcb>
80103f53:	8b 53 0c             	mov    0xc(%ebx),%edx
80103f56:	83 fa 0a             	cmp    $0xa,%edx
80103f59:	75 d5                	jne    80103f30 <exit+0xa0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f5b:	81 c3 10 01 00 00    	add    $0x110,%ebx
        wakeup1(initproc);
80103f61:	e8 da f6 ff ff       	call   80103640 <wakeup1>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f66:	81 fb 54 81 11 80    	cmp    $0x80118154,%ebx
80103f6c:	72 d0                	jb     80103f3e <exit+0xae>
  sched();
80103f6e:	e8 7d fe ff ff       	call   80103df0 <sched>
  panic("zombie exit");
80103f73:	83 ec 0c             	sub    $0xc,%esp
80103f76:	68 65 7c 10 80       	push   $0x80107c65
80103f7b:	e8 10 c4 ff ff       	call   80100390 <panic>
    panic("in exit: cas has failed");
80103f80:	83 ec 0c             	sub    $0xc,%esp
80103f83:	68 4d 7c 10 80       	push   $0x80107c4d
80103f88:	e8 03 c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103f8d:	83 ec 0c             	sub    $0xc,%esp
80103f90:	68 40 7c 10 80       	push   $0x80107c40
80103f95:	e8 f6 c3 ff ff       	call   80100390 <panic>
80103f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103fa0 <wait>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	57                   	push   %edi
80103fa4:	56                   	push   %esi
80103fa5:	53                   	push   %ebx
80103fa6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103fa9:	e8 22 09 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80103fae:	e8 cd f8 ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103fb3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fb9:	e8 52 09 00 00       	call   80104910 <popcli>
  pushcli();
80103fbe:	e8 0d 09 00 00       	call   801048d0 <pushcli>
    if(!cas(&curproc->state, RUNNING, NEG_SLEEPING)){
80103fc3:	8d 46 0c             	lea    0xc(%esi),%eax
80103fc6:	ba 07 00 00 00       	mov    $0x7,%edx
80103fcb:	b9 04 00 00 00       	mov    $0x4,%ecx
80103fd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103fd3:	89 d0                	mov    %edx,%eax
80103fd5:	f0 0f b1 4e 0c       	lock cmpxchg %ecx,0xc(%esi)
80103fda:	9c                   	pushf  
80103fdb:	5a                   	pop    %edx
80103fdc:	83 e2 40             	and    $0x40,%edx
80103fdf:	85 d2                	test   %edx,%edx
80103fe1:	0f 84 87 00 00 00    	je     8010406e <wait+0xce>
    havekids = 0;
80103fe7:	31 ff                	xor    %edi,%edi
    curproc->chan = curproc;
80103fe9:	89 76 20             	mov    %esi,0x20(%esi)
    havekids = 0;
80103fec:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fee:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103ff3:	ba 09 00 00 00       	mov    $0x9,%edx
80103ff8:	eb 14                	jmp    8010400e <wait+0x6e>
80103ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104000:	81 c3 10 01 00 00    	add    $0x110,%ebx
80104006:	81 fb 54 81 11 80    	cmp    $0x80118154,%ebx
8010400c:	73 28                	jae    80104036 <wait+0x96>
      if (p->parent != curproc)
8010400e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104011:	75 ed                	jne    80104000 <wait+0x60>
80104013:	89 d0                	mov    %edx,%eax
80104015:	f0 0f b1 7b 0c       	lock cmpxchg %edi,0xc(%ebx)
8010401a:	9c                   	pushf  
8010401b:	59                   	pop    %ecx
8010401c:	83 e1 40             	and    $0x40,%ecx
      if (cas(&p->state, ZOMBIE, UNUSED))
8010401f:	85 c9                	test   %ecx,%ecx
80104021:	75 5d                	jne    80104080 <wait+0xe0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104023:	81 c3 10 01 00 00    	add    $0x110,%ebx
      havekids = 1;
80104029:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010402e:	81 fb 54 81 11 80    	cmp    $0x80118154,%ebx
80104034:	72 d8                	jb     8010400e <wait+0x6e>
    if (!havekids || curproc->killed)
80104036:	85 c0                	test   %eax,%eax
80104038:	0f 84 a8 00 00 00    	je     801040e6 <wait+0x146>
8010403e:	8b 46 24             	mov    0x24(%esi),%eax
80104041:	85 c0                	test   %eax,%eax
80104043:	0f 85 9d 00 00 00    	jne    801040e6 <wait+0x146>
    sched();
80104049:	e8 a2 fd ff ff       	call   80103df0 <sched>
8010404e:	ba 07 00 00 00       	mov    $0x7,%edx
80104053:	b9 04 00 00 00       	mov    $0x4,%ecx
80104058:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010405b:	89 d0                	mov    %edx,%eax
8010405d:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80104061:	9c                   	pushf  
80104062:	5a                   	pop    %edx
80104063:	83 e2 40             	and    $0x40,%edx
    if(!cas(&curproc->state, RUNNING, NEG_SLEEPING)){
80104066:	85 d2                	test   %edx,%edx
80104068:	0f 85 7b ff ff ff    	jne    80103fe9 <wait+0x49>
      panic("at wait: cas has faiiled");
8010406e:	83 ec 0c             	sub    $0xc,%esp
80104071:	68 71 7c 10 80       	push   $0x80107c71
80104076:	e8 15 c3 ff ff       	call   80100390 <panic>
8010407b:	90                   	nop
8010407c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104080:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104083:	8b 7b 10             	mov    0x10(%ebx),%edi
        kfree(p->kstack);
80104086:	ff 73 08             	pushl  0x8(%ebx)
80104089:	e8 c2 e2 ff ff       	call   80102350 <kfree>
        p->kstack = 0;
8010408e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104095:	5a                   	pop    %edx
80104096:	ff 73 04             	pushl  0x4(%ebx)
80104099:	e8 42 32 00 00       	call   801072e0 <freevm>
        p->pid = 0;
8010409e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040a5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
801040ac:	ba 04 00 00 00       	mov    $0x4,%edx
        p->name[0] = 0;
801040b1:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
801040b5:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
801040bc:	b9 07 00 00 00       	mov    $0x7,%ecx
        curproc->chan=0;
801040c1:	c7 46 20 00 00 00 00 	movl   $0x0,0x20(%esi)
801040c8:	89 d0                	mov    %edx,%eax
801040ca:	f0 0f b1 4e 0c       	lock cmpxchg %ecx,0xc(%esi)
801040cf:	9c                   	pushf  
801040d0:	5a                   	pop    %edx
801040d1:	83 e2 40             	and    $0x40,%edx
        popcli();
801040d4:	e8 37 08 00 00       	call   80104910 <popcli>
        return pid;
801040d9:	83 c4 10             	add    $0x10,%esp
}
801040dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040df:	89 f8                	mov    %edi,%eax
801040e1:	5b                   	pop    %ebx
801040e2:	5e                   	pop    %esi
801040e3:	5f                   	pop    %edi
801040e4:	5d                   	pop    %ebp
801040e5:	c3                   	ret    
      curproc->chan=0;
801040e6:	c7 46 20 00 00 00 00 	movl   $0x0,0x20(%esi)
801040ed:	ba 04 00 00 00       	mov    $0x4,%edx
801040f2:	b9 07 00 00 00       	mov    $0x7,%ecx
801040f7:	89 d0                	mov    %edx,%eax
801040f9:	f0 0f b1 4e 0c       	lock cmpxchg %ecx,0xc(%esi)
801040fe:	9c                   	pushf  
801040ff:	5a                   	pop    %edx
80104100:	83 e2 40             	and    $0x40,%edx
      if(!cas(&curproc->state, NEG_SLEEPING, RUNNING)){
80104103:	85 d2                	test   %edx,%edx
80104105:	74 0c                	je     80104113 <wait+0x173>
      popcli();
80104107:	e8 04 08 00 00       	call   80104910 <popcli>
      return -1;
8010410c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104111:	eb c9                	jmp    801040dc <wait+0x13c>
        panic("at wait: couldn't switch from -SLEEPING to RUNNING");
80104113:	83 ec 0c             	sub    $0xc,%esp
80104116:	68 a4 7b 10 80       	push   $0x80107ba4
8010411b:	e8 70 c2 ff ff       	call   80100390 <panic>

80104120 <yield>:
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
80104124:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104127:	e8 a4 07 00 00       	call   801048d0 <pushcli>
  c = mycpu();
8010412c:	e8 4f f7 ff ff       	call   80103880 <mycpu>
  p = c->proc;
80104131:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104137:	e8 d4 07 00 00       	call   80104910 <popcli>
  pushcli();
8010413c:	e8 8f 07 00 00       	call   801048d0 <pushcli>
80104141:	ba 07 00 00 00       	mov    $0x7,%edx
80104146:	b9 06 00 00 00       	mov    $0x6,%ecx
8010414b:	89 d0                	mov    %edx,%eax
8010414d:	f0 0f b1 4b 0c       	lock cmpxchg %ecx,0xc(%ebx)
80104152:	9c                   	pushf  
80104153:	5a                   	pop    %edx
80104154:	83 e2 40             	and    $0x40,%edx
  if (!cas(&curproc->state, RUNNING, NEG_RUNNABLE))
80104157:	85 d2                	test   %edx,%edx
80104159:	74 0e                	je     80104169 <yield+0x49>
  sched();
8010415b:	e8 90 fc ff ff       	call   80103df0 <sched>
}
80104160:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104163:	c9                   	leave  
  popcli();
80104164:	e9 a7 07 00 00       	jmp    80104910 <popcli>
    panic("In yield: the cas has failed");
80104169:	83 ec 0c             	sub    $0xc,%esp
8010416c:	68 8a 7c 10 80       	push   $0x80107c8a
80104171:	e8 1a c2 ff ff       	call   80100390 <panic>
80104176:	8d 76 00             	lea    0x0(%esi),%esi
80104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104180 <sleep>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	57                   	push   %edi
80104184:	56                   	push   %esi
80104185:	53                   	push   %ebx
80104186:	83 ec 0c             	sub    $0xc,%esp
80104189:	8b 7d 08             	mov    0x8(%ebp),%edi
8010418c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010418f:	e8 3c 07 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80104194:	e8 e7 f6 ff ff       	call   80103880 <mycpu>
  p = c->proc;
80104199:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010419f:	e8 6c 07 00 00       	call   80104910 <popcli>
  if (p == 0)
801041a4:	85 db                	test   %ebx,%ebx
801041a6:	74 52                	je     801041fa <sleep+0x7a>
  if (lk == 0)
801041a8:	85 f6                	test   %esi,%esi
801041aa:	74 68                	je     80104214 <sleep+0x94>
  pushcli();
801041ac:	e8 1f 07 00 00       	call   801048d0 <pushcli>
801041b1:	ba 07 00 00 00       	mov    $0x7,%edx
801041b6:	b9 04 00 00 00       	mov    $0x4,%ecx
801041bb:	89 d0                	mov    %edx,%eax
801041bd:	f0 0f b1 4b 0c       	lock cmpxchg %ecx,0xc(%ebx)
801041c2:	9c                   	pushf  
801041c3:	5a                   	pop    %edx
801041c4:	83 e2 40             	and    $0x40,%edx
  if(!cas(&p->state, RUNNING, NEG_SLEEPING))
801041c7:	85 d2                	test   %edx,%edx
801041c9:	74 3c                	je     80104207 <sleep+0x87>
  release(lk);
801041cb:	83 ec 0c             	sub    $0xc,%esp
801041ce:	56                   	push   %esi
801041cf:	e8 8c 08 00 00       	call   80104a60 <release>
  p->chan = chan;
801041d4:	89 7b 20             	mov    %edi,0x20(%ebx)
  sched();
801041d7:	e8 14 fc ff ff       	call   80103df0 <sched>
  p->chan=0;
801041dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  popcli();
801041e3:	e8 28 07 00 00       	call   80104910 <popcli>
  acquire(lk);
801041e8:	89 75 08             	mov    %esi,0x8(%ebp)
801041eb:	83 c4 10             	add    $0x10,%esp
}
801041ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041f1:	5b                   	pop    %ebx
801041f2:	5e                   	pop    %esi
801041f3:	5f                   	pop    %edi
801041f4:	5d                   	pop    %ebp
  acquire(lk);
801041f5:	e9 a6 07 00 00       	jmp    801049a0 <acquire>
    panic("sleep");
801041fa:	83 ec 0c             	sub    $0xc,%esp
801041fd:	68 a7 7c 10 80       	push   $0x80107ca7
80104202:	e8 89 c1 ff ff       	call   80100390 <panic>
    panic("in sleep: cas failed");
80104207:	83 ec 0c             	sub    $0xc,%esp
8010420a:	68 be 7c 10 80       	push   $0x80107cbe
8010420f:	e8 7c c1 ff ff       	call   80100390 <panic>
    panic("sleep without lk");
80104214:	83 ec 0c             	sub    $0xc,%esp
80104217:	68 ad 7c 10 80       	push   $0x80107cad
8010421c:	e8 6f c1 ff ff       	call   80100390 <panic>
80104221:	eb 0d                	jmp    80104230 <wakeup>
80104223:	90                   	nop
80104224:	90                   	nop
80104225:	90                   	nop
80104226:	90                   	nop
80104227:	90                   	nop
80104228:	90                   	nop
80104229:	90                   	nop
8010422a:	90                   	nop
8010422b:	90                   	nop
8010422c:	90                   	nop
8010422d:	90                   	nop
8010422e:	90                   	nop
8010422f:	90                   	nop

80104230 <wakeup>:

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	53                   	push   %ebx
80104234:	83 ec 04             	sub    $0x4,%esp
80104237:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //acquire(&ptable.lock);
  pushcli();
8010423a:	e8 91 06 00 00       	call   801048d0 <pushcli>
  wakeup1(chan);
8010423f:	89 d8                	mov    %ebx,%eax
80104241:	e8 fa f3 ff ff       	call   80103640 <wakeup1>
  //release(&ptable.lock);
  popcli();
}
80104246:	83 c4 04             	add    $0x4,%esp
80104249:	5b                   	pop    %ebx
8010424a:	5d                   	pop    %ebp
  popcli();
8010424b:	e9 c0 06 00 00       	jmp    80104910 <popcli>

80104250 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid, int signum)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	56                   	push   %esi
80104254:	53                   	push   %ebx
80104255:	8b 75 0c             	mov    0xc(%ebp),%esi
80104258:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  pushcli(); // preventing interruptions
8010425b:	e8 70 06 00 00       	call   801048d0 <pushcli>

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104260:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80104265:	eb 1b                	jmp    80104282 <kill+0x32>
80104267:	89 f6                	mov    %esi,%esi
80104269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104270:	81 c2 10 01 00 00    	add    $0x110,%edx
80104276:	81 fa 54 81 11 80    	cmp    $0x80118154,%edx
8010427c:	0f 83 96 00 00 00    	jae    80104318 <kill+0xc8>
  {

    if (p->pid == pid)
80104282:	39 5a 10             	cmp    %ebx,0x10(%edx)
80104285:	75 e9                	jne    80104270 <kill+0x20>
    {
      switch (signum)
80104287:	83 fe 11             	cmp    $0x11,%esi
8010428a:	74 74                	je     80104300 <kill+0xb0>
8010428c:	83 fe 13             	cmp    $0x13,%esi
8010428f:	74 27                	je     801042b8 <kill+0x68>
80104291:	83 fe 09             	cmp    $0x9,%esi
80104294:	74 42                	je     801042d8 <kill+0x88>
        }
        popcli();  //the 'else' case
        return -1; // continue was sent but the proccess is not pn stopped

      default:
        p->pending_signals = p->pending_signals | (1 << (32 - signum));
80104296:	b9 20 00 00 00       	mov    $0x20,%ecx
8010429b:	b8 01 00 00 00       	mov    $0x1,%eax
801042a0:	29 f1                	sub    %esi,%ecx
801042a2:	d3 e0                	shl    %cl,%eax
801042a4:	09 82 80 00 00 00    	or     %eax,0x80(%edx)
        popcli();
801042aa:	e8 61 06 00 00       	call   80104910 <popcli>
    }
  }
  //release(&ptable.lock);
  popcli();
  return -1;
}
801042af:	5b                   	pop    %ebx
        return 0;
801042b0:	31 c0                	xor    %eax,%eax
}
801042b2:	5e                   	pop    %esi
801042b3:	5d                   	pop    %ebp
801042b4:	c3                   	ret    
801042b5:	8d 76 00             	lea    0x0(%esi),%esi
        if (p->stopped == 1)
801042b8:	83 7a 28 01          	cmpl   $0x1,0x28(%edx)
801042bc:	75 5a                	jne    80104318 <kill+0xc8>
          p->pending_signals = p->pending_signals | (1 << (32 - signum));
801042be:	81 8a 80 00 00 00 00 	orl    $0x2000,0x80(%edx)
801042c5:	20 00 00 
          popcli();
801042c8:	e8 43 06 00 00       	call   80104910 <popcli>
}
801042cd:	5b                   	pop    %ebx
          return 0;
801042ce:	31 c0                	xor    %eax,%eax
}
801042d0:	5e                   	pop    %esi
801042d1:	5d                   	pop    %ebp
801042d2:	c3                   	ret    
801042d3:	90                   	nop
801042d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->killed = 1;
801042d8:	c7 42 24 01 00 00 00 	movl   $0x1,0x24(%edx)
801042df:	b9 03 00 00 00       	mov    $0x3,%ecx
801042e4:	bb 05 00 00 00       	mov    $0x5,%ebx
801042e9:	89 c8                	mov    %ecx,%eax
801042eb:	f0 0f b1 5a 0c       	lock cmpxchg %ebx,0xc(%edx)
801042f0:	9c                   	pushf  
801042f1:	59                   	pop    %ecx
801042f2:	83 e1 40             	and    $0x40,%ecx
        popcli();
801042f5:	e8 16 06 00 00       	call   80104910 <popcli>
}
801042fa:	5b                   	pop    %ebx
        return 0;
801042fb:	31 c0                	xor    %eax,%eax
}
801042fd:	5e                   	pop    %esi
801042fe:	5d                   	pop    %ebp
801042ff:	c3                   	ret    
        p->stopped = 1;
80104300:	c7 42 28 01 00 00 00 	movl   $0x1,0x28(%edx)
        popcli();
80104307:	e8 04 06 00 00       	call   80104910 <popcli>
}
8010430c:	5b                   	pop    %ebx
        return 0;
8010430d:	31 c0                	xor    %eax,%eax
}
8010430f:	5e                   	pop    %esi
80104310:	5d                   	pop    %ebp
80104311:	c3                   	ret    
80104312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        popcli();  //the 'else' case
80104318:	e8 f3 05 00 00       	call   80104910 <popcli>
}
8010431d:	5b                   	pop    %ebx
        return -1; // continue was sent but the proccess is not pn stopped
8010431e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104323:	5e                   	pop    %esi
80104324:	5d                   	pop    %ebp
80104325:	c3                   	ret    
80104326:	8d 76 00             	lea    0x0(%esi),%esi
80104329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104330 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	56                   	push   %esi
80104335:	53                   	push   %ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104336:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
8010433b:	83 ec 3c             	sub    $0x3c,%esp
8010433e:	eb 22                	jmp    80104362 <procdump+0x32>
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104340:	83 ec 0c             	sub    $0xc,%esp
80104343:	68 43 80 10 80       	push   $0x80108043
80104348:	e8 13 c3 ff ff       	call   80100660 <cprintf>
8010434d:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104350:	81 c3 10 01 00 00    	add    $0x110,%ebx
80104356:	81 fb 54 81 11 80    	cmp    $0x80118154,%ebx
8010435c:	0f 83 9e 00 00 00    	jae    80104400 <procdump+0xd0>
    if (p->state == UNUSED)
80104362:	8b 43 0c             	mov    0xc(%ebx),%eax
80104365:	85 c0                	test   %eax,%eax
80104367:	74 e7                	je     80104350 <procdump+0x20>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104369:	8b 43 0c             	mov    0xc(%ebx),%eax
8010436c:	8b 53 0c             	mov    0xc(%ebx),%edx
      state = "???";
8010436f:	b8 d3 7c 10 80       	mov    $0x80107cd3,%eax
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104374:	83 fa 09             	cmp    $0x9,%edx
80104377:	77 18                	ja     80104391 <procdump+0x61>
80104379:	8b 53 0c             	mov    0xc(%ebx),%edx
8010437c:	8b 14 95 20 7d 10 80 	mov    -0x7fef82e0(,%edx,4),%edx
80104383:	85 d2                	test   %edx,%edx
80104385:	74 0a                	je     80104391 <procdump+0x61>
      state = states[p->state];
80104387:	8b 43 0c             	mov    0xc(%ebx),%eax
8010438a:	8b 04 85 20 7d 10 80 	mov    -0x7fef82e0(,%eax,4),%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80104391:	8d 53 70             	lea    0x70(%ebx),%edx
80104394:	52                   	push   %edx
80104395:	50                   	push   %eax
80104396:	ff 73 10             	pushl  0x10(%ebx)
80104399:	68 d7 7c 10 80       	push   $0x80107cd7
8010439e:	e8 bd c2 ff ff       	call   80100660 <cprintf>
    if (p->state == SLEEPING)
801043a3:	8b 43 0c             	mov    0xc(%ebx),%eax
801043a6:	83 c4 10             	add    $0x10,%esp
801043a9:	83 f8 03             	cmp    $0x3,%eax
801043ac:	75 92                	jne    80104340 <procdump+0x10>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
801043ae:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043b1:	83 ec 08             	sub    $0x8,%esp
801043b4:	8d 75 c0             	lea    -0x40(%ebp),%esi
801043b7:	8d 7d e8             	lea    -0x18(%ebp),%edi
801043ba:	50                   	push   %eax
801043bb:	8b 43 1c             	mov    0x1c(%ebx),%eax
801043be:	8b 40 0c             	mov    0xc(%eax),%eax
801043c1:	83 c0 08             	add    $0x8,%eax
801043c4:	50                   	push   %eax
801043c5:	e8 b6 04 00 00       	call   80104880 <getcallerpcs>
801043ca:	83 c4 10             	add    $0x10,%esp
801043cd:	8d 76 00             	lea    0x0(%esi),%esi
      for (i = 0; i < 10 && pc[i] != 0; i++)
801043d0:	8b 16                	mov    (%esi),%edx
801043d2:	85 d2                	test   %edx,%edx
801043d4:	0f 84 66 ff ff ff    	je     80104340 <procdump+0x10>
        cprintf(" %p", pc[i]);
801043da:	83 ec 08             	sub    $0x8,%esp
801043dd:	83 c6 04             	add    $0x4,%esi
801043e0:	52                   	push   %edx
801043e1:	68 41 76 10 80       	push   $0x80107641
801043e6:	e8 75 c2 ff ff       	call   80100660 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
801043eb:	83 c4 10             	add    $0x10,%esp
801043ee:	39 f7                	cmp    %esi,%edi
801043f0:	75 de                	jne    801043d0 <procdump+0xa0>
801043f2:	e9 49 ff ff ff       	jmp    80104340 <procdump+0x10>
801043f7:	89 f6                	mov    %esi,%esi
801043f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }
}
80104400:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104403:	5b                   	pop    %ebx
80104404:	5e                   	pop    %esi
80104405:	5f                   	pop    %edi
80104406:	5d                   	pop    %ebp
80104407:	c3                   	ret    
80104408:	90                   	nop
80104409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104410 <sigaction>:

int sigaction(int signum, const struct sigaction *act, struct sigaction *oldact)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	57                   	push   %edi
80104414:	56                   	push   %esi
80104415:	53                   	push   %ebx
80104416:	83 ec 0c             	sub    $0xc,%esp
80104419:	8b 75 10             	mov    0x10(%ebp),%esi
8010441c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  pushcli();
8010441f:	e8 ac 04 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80104424:	e8 57 f4 ff ff       	call   80103880 <mycpu>
  p = c->proc;
80104429:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
8010442f:	e8 dc 04 00 00       	call   80104910 <popcli>
  struct proc *p = myproc();
  if (oldact != null)
80104434:	85 f6                	test   %esi,%esi
80104436:	74 1c                	je     80104454 <sigaction+0x44>
80104438:	8b 45 08             	mov    0x8(%ebp),%eax
8010443b:	8d 14 87             	lea    (%edi,%eax,4),%edx
  {
    oldact->sa_handler = p->signal_handlers[signum - 1]->sa_handler;
8010443e:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80104444:	8b 09                	mov    (%ecx),%ecx
80104446:	89 0e                	mov    %ecx,(%esi)
    oldact->sigmask = p->signal_handlers[signum - 1]->sigmask;
80104448:	8b 92 88 00 00 00    	mov    0x88(%edx),%edx
8010444e:	8b 52 04             	mov    0x4(%edx),%edx
80104451:	89 56 04             	mov    %edx,0x4(%esi)
  }
  if (act->sigmask <= 0)
80104454:	8b 43 04             	mov    0x4(%ebx),%eax
80104457:	85 c0                	test   %eax,%eax
80104459:	74 2d                	je     80104488 <sigaction+0x78>
8010445b:	8b 45 08             	mov    0x8(%ebp),%eax
    return -1;

  p->signal_handlers[signum - 1]->sa_handler = act->sa_handler;
8010445e:	8b 0b                	mov    (%ebx),%ecx
80104460:	8d 04 87             	lea    (%edi,%eax,4),%eax
80104463:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80104469:	89 0a                	mov    %ecx,(%edx)
  p->signal_handlers[signum - 1]->sigmask = act->sigmask;
8010446b:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104471:	8b 53 04             	mov    0x4(%ebx),%edx
80104474:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80104477:	31 c0                	xor    %eax,%eax
}
80104479:	83 c4 0c             	add    $0xc,%esp
8010447c:	5b                   	pop    %ebx
8010447d:	5e                   	pop    %esi
8010447e:	5f                   	pop    %edi
8010447f:	5d                   	pop    %ebp
80104480:	c3                   	ret    
80104481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010448d:	eb ea                	jmp    80104479 <sigaction+0x69>
8010448f:	90                   	nop

80104490 <sigret>:
    break;
  }
}

void sigret(void)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	53                   	push   %ebx
80104494:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104497:	e8 34 04 00 00       	call   801048d0 <pushcli>
  c = mycpu();
8010449c:	e8 df f3 ff ff       	call   80103880 <mycpu>
  p = c->proc;
801044a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044a7:	e8 64 04 00 00       	call   80104910 <popcli>
  struct proc *curproc = myproc();

  pushcli(); // for interrupts
801044ac:	e8 1f 04 00 00       	call   801048d0 <pushcli>

  memmove(curproc->tf, curproc->userspace_trapframe_backup, sizeof(struct trapframe)); //restoring the backup by updating the tf with the backup we saved in the checkS function
801044b1:	83 ec 04             	sub    $0x4,%esp
801044b4:	6a 4c                	push   $0x4c
801044b6:	ff b3 0c 01 00 00    	pushl  0x10c(%ebx)
801044bc:	ff 73 18             	pushl  0x18(%ebx)
801044bf:	e8 9c 06 00 00       	call   80104b60 <memmove>
  curproc->tf->esp = curproc->tf->esp + sizeof(struct trapframe);                      //representing popping out the backup we saved in the stack
801044c4:	8b 43 18             	mov    0x18(%ebx),%eax
  curproc->signal_mask = curproc->signal_mask_backup;                                  //restoring the mask back to where it was before handling the signal (part of preventing nested user-level signal handling)
  popcli();
801044c7:	83 c4 10             	add    $0x10,%esp
  curproc->tf->esp = curproc->tf->esp + sizeof(struct trapframe);                      //representing popping out the backup we saved in the stack
801044ca:	83 40 44 4c          	addl   $0x4c,0x44(%eax)
  curproc->signal_mask = curproc->signal_mask_backup;                                  //restoring the mask back to where it was before handling the signal (part of preventing nested user-level signal handling)
801044ce:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801044d4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
}
801044da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044dd:	c9                   	leave  
  popcli();
801044de:	e9 2d 04 00 00       	jmp    80104910 <popcli>
801044e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044f0 <sigprocmask>:

uint sigprocmask(uint sigmask)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	56                   	push   %esi
801044f4:	53                   	push   %ebx
  pushcli();
801044f5:	e8 d6 03 00 00       	call   801048d0 <pushcli>
  c = mycpu();
801044fa:	e8 81 f3 ff ff       	call   80103880 <mycpu>
  p = c->proc;
801044ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104505:	e8 06 04 00 00       	call   80104910 <popcli>
  uint oldmask = myproc()->signal_mask;
8010450a:	8b 9b 84 00 00 00    	mov    0x84(%ebx),%ebx
  pushcli();
80104510:	e8 bb 03 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80104515:	e8 66 f3 ff ff       	call   80103880 <mycpu>
  p = c->proc;
8010451a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104520:	e8 eb 03 00 00       	call   80104910 <popcli>
  myproc()->signal_mask = sigmask;
80104525:	8b 45 08             	mov    0x8(%ebp),%eax
80104528:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
  return oldmask;
8010452e:	89 d8                	mov    %ebx,%eax
80104530:	5b                   	pop    %ebx
80104531:	5e                   	pop    %esi
80104532:	5d                   	pop    %ebp
80104533:	c3                   	ret    
80104534:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010453a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104540 <checkS>:
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	57                   	push   %edi
80104544:	56                   	push   %esi
80104545:	53                   	push   %ebx
80104546:	83 ec 0c             	sub    $0xc,%esp
80104549:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010454c:	e8 7f 03 00 00       	call   801048d0 <pushcli>
  c = mycpu();
80104551:	e8 2a f3 ff ff       	call   80103880 <mycpu>
  p = c->proc;
80104556:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010455c:	e8 af 03 00 00       	call   80104910 <popcli>
  if(curproc == 0){
80104561:	85 db                	test   %ebx,%ebx
80104563:	0f 84 07 01 00 00    	je     80104670 <checkS+0x130>
  if(curproc->pending_signals == 0)
80104569:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010456f:	85 c0                	test   %eax,%eax
80104571:	0f 84 f9 00 00 00    	je     80104670 <checkS+0x130>
  if(((trap_frame->cs & 3) != DPL_USER)){
80104577:	0f b7 56 3c          	movzwl 0x3c(%esi),%edx
8010457b:	83 e2 03             	and    $0x3,%edx
8010457e:	66 83 fa 03          	cmp    $0x3,%dx
80104582:	0f 85 70 01 00 00    	jne    801046f8 <checkS+0x1b8>
  if (curproc->stopped)
80104588:	8b 53 28             	mov    0x28(%ebx),%edx
8010458b:	85 d2                	test   %edx,%edx
8010458d:	0f 85 ed 00 00 00    	jne    80104680 <checkS+0x140>
{
80104593:	be 01 00 00 00       	mov    $0x1,%esi
    int pending = (curproc->pending_signals & (1 << (32 - i)));
80104598:	bf 01 00 00 00       	mov    $0x1,%edi
8010459d:	b9 20 00 00 00       	mov    $0x20,%ecx
801045a2:	89 fa                	mov    %edi,%edx
801045a4:	29 f1                	sub    %esi,%ecx
801045a6:	d3 e2                	shl    %cl,%edx
    if (!pending || ((curproc->signal_mask) & (1 << (32 - i)))) //this proccess is not pending or should be ignored (the second option is to check if the bit in the mask is on or not)
801045a8:	85 c2                	test   %eax,%edx
    int pending = (curproc->pending_signals & (1 << (32 - i)));
801045aa:	89 d1                	mov    %edx,%ecx
    if (!pending || ((curproc->signal_mask) & (1 << (32 - i)))) //this proccess is not pending or should be ignored (the second option is to check if the bit in the mask is on or not)
801045ac:	0f 84 2e 01 00 00    	je     801046e0 <checkS+0x1a0>
801045b2:	85 93 84 00 00 00    	test   %edx,0x84(%ebx)
801045b8:	0f 85 22 01 00 00    	jne    801046e0 <checkS+0x1a0>
    curproc->pending_signals = curproc->pending_signals ^ (1 << (32 - i));
801045be:	31 c1                	xor    %eax,%ecx
801045c0:	89 8b 80 00 00 00    	mov    %ecx,0x80(%ebx)
    if (curproc->signal_handlers[i - 1]->sa_handler == (void *)SIG_IGN)
801045c6:	8b 8c b3 88 00 00 00 	mov    0x88(%ebx,%esi,4),%ecx
801045cd:	8b 09                	mov    (%ecx),%ecx
801045cf:	83 f9 01             	cmp    $0x1,%ecx
801045d2:	0f 84 00 01 00 00    	je     801046d8 <checkS+0x198>
    if (curproc->signal_handlers[i - 1]->sa_handler == (void *)SIGCONT)
801045d8:	83 f9 13             	cmp    $0x13,%ecx
801045db:	0f 84 ff 00 00 00    	je     801046e0 <checkS+0x1a0>
    if (curproc->signal_handlers[i - 1]->sa_handler == (void *)SIG_DFL || curproc->signal_handlers[i - 1]->sa_handler == (void *)SIGKILL)
801045e1:	83 f9 09             	cmp    $0x9,%ecx
801045e4:	0f 84 26 01 00 00    	je     80104710 <checkS+0x1d0>
    curproc->signal_mask_backup = sigprocmask(curproc->signal_handlers[i]->sigmask); // updating the mask while keeping a copy of the old one (preventing support of nested user-level signal handling)
801045ea:	8b 84 b3 8c 00 00 00 	mov    0x8c(%ebx,%esi,4),%eax
801045f1:	83 ec 0c             	sub    $0xc,%esp
801045f4:	ff 70 04             	pushl  0x4(%eax)
801045f7:	e8 f4 fe ff ff       	call   801044f0 <sigprocmask>
801045fc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
    curproc->tf->esp -= sizeof(struct trapframe);                               // reserve space in the stack for the backup we are about to create
80104602:	8b 43 18             	mov    0x18(%ebx),%eax
    memmove((void *)(curproc->tf->esp), curproc->tf, sizeof(struct trapframe)); //copy the trapframe into the reserved space in the stack
80104605:	83 c4 0c             	add    $0xc,%esp
    curproc->tf->esp -= sizeof(struct trapframe);                               // reserve space in the stack for the backup we are about to create
80104608:	83 68 44 4c          	subl   $0x4c,0x44(%eax)
    memmove((void *)(curproc->tf->esp), curproc->tf, sizeof(struct trapframe)); //copy the trapframe into the reserved space in the stack
8010460c:	8b 43 18             	mov    0x18(%ebx),%eax
8010460f:	6a 4c                	push   $0x4c
80104611:	50                   	push   %eax
80104612:	ff 70 44             	pushl  0x44(%eax)
80104615:	e8 46 05 00 00       	call   80104b60 <memmove>
    curproc->userspace_trapframe_backup = (void *)(curproc->tf->esp);           //esp now points at the beginning of the backup we copied into the stack
8010461a:	8b 53 18             	mov    0x18(%ebx),%edx
    memmove((void *)(curproc->tf->esp), injected_call_beginning, call_size);    //injecting call into the stack
8010461d:	83 c4 0c             	add    $0xc,%esp
    curproc->userspace_trapframe_backup = (void *)(curproc->tf->esp);           //esp now points at the beginning of the backup we copied into the stack
80104620:	8b 42 44             	mov    0x44(%edx),%eax
80104623:	89 83 0c 01 00 00    	mov    %eax,0x10c(%ebx)
    uint call_size = (uint)&injected_call_end - (uint)&injected_call_beginning; // with these we can find the size of the call to sigret that we want to push into the stack (return address). variables can be found in the 'injected_call.S' file
80104629:	b8 55 22 10 80       	mov    $0x80102255,%eax
8010462e:	2d 4e 22 10 80       	sub    $0x8010224e,%eax
    curproc->tf->esp -= call_size;                                              //reserving space in stack
80104633:	29 42 44             	sub    %eax,0x44(%edx)
    memmove((void *)(curproc->tf->esp), injected_call_beginning, call_size);    //injecting call into the stack
80104636:	50                   	push   %eax
80104637:	68 4e 22 10 80       	push   $0x8010224e
8010463c:	8b 43 18             	mov    0x18(%ebx),%eax
8010463f:	ff 70 44             	pushl  0x44(%eax)
80104642:	e8 19 05 00 00       	call   80104b60 <memmove>
    *((int *)(curproc->tf->esp - 4)) = i;                // pushing the first parameter- signum
80104647:	8b 43 18             	mov    0x18(%ebx),%eax
    break;
8010464a:	83 c4 10             	add    $0x10,%esp
    *((int *)(curproc->tf->esp - 4)) = i;                // pushing the first parameter- signum
8010464d:	8b 40 44             	mov    0x44(%eax),%eax
80104650:	89 70 fc             	mov    %esi,-0x4(%eax)
    *((int *)(curproc->tf->esp - 8)) = curproc->tf->esp; //the return address (actually the sigret we injected)
80104653:	8b 43 18             	mov    0x18(%ebx),%eax
80104656:	8b 40 44             	mov    0x44(%eax),%eax
80104659:	89 40 f8             	mov    %eax,-0x8(%eax)
    curproc->tf->esp -= 8; // updating esp
8010465c:	8b 43 18             	mov    0x18(%ebx),%eax
8010465f:	83 68 44 08          	subl   $0x8,0x44(%eax)
    curproc->tf->eip = (uint)curproc->signal_handlers[i - 1];
80104663:	8b 43 18             	mov    0x18(%ebx),%eax
80104666:	8b 94 b3 88 00 00 00 	mov    0x88(%ebx,%esi,4),%edx
8010466d:	89 50 38             	mov    %edx,0x38(%eax)
}
80104670:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104673:	5b                   	pop    %ebx
80104674:	5e                   	pop    %esi
80104675:	5f                   	pop    %edi
80104676:	5d                   	pop    %ebp
80104677:	c3                   	ret    
80104678:	90                   	nop
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (is_pending)
80104680:	f6 c4 20             	test   $0x20,%ah
80104683:	75 11                	jne    80104696 <checkS+0x156>
80104685:	8d 76 00             	lea    0x0(%esi),%esi
        yield(); // didn't get cont yet, give back the cpu time
80104688:	e8 93 fa ff ff       	call   80104120 <yield>
      if (is_pending)
8010468d:	f6 83 81 00 00 00 20 	testb  $0x20,0x81(%ebx)
80104694:	74 f2                	je     80104688 <checkS+0x148>
        pushcli(); //for interrupts
80104696:	e8 35 02 00 00       	call   801048d0 <pushcli>
8010469b:	ba 01 00 00 00       	mov    $0x1,%edx
801046a0:	31 c9                	xor    %ecx,%ecx
801046a2:	89 d0                	mov    %edx,%eax
801046a4:	f0 0f b1 4b 28       	lock cmpxchg %ecx,0x28(%ebx)
801046a9:	9c                   	pushf  
801046aa:	5a                   	pop    %edx
801046ab:	83 e2 40             	and    $0x40,%edx
        if (cas(&curproc->stopped, 1, 0))
801046ae:	85 d2                	test   %edx,%edx
801046b0:	74 0a                	je     801046bc <checkS+0x17c>
          curproc->pending_signals = curproc->pending_signals ^ (1 << (32 - SIGCONT)); // to turn off the continue bit
801046b2:	81 b3 80 00 00 00 00 	xorl   $0x2000,0x80(%ebx)
801046b9:	20 00 00 
        popcli();
801046bc:	e8 4f 02 00 00       	call   80104910 <popcli>
  if (curproc->stopped)
801046c1:	8b 43 28             	mov    0x28(%ebx),%eax
801046c4:	85 c0                	test   %eax,%eax
801046c6:	75 a8                	jne    80104670 <checkS+0x130>
801046c8:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801046ce:	e9 c0 fe ff ff       	jmp    80104593 <checkS+0x53>
801046d3:	90                   	nop
801046d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->pending_signals = curproc->pending_signals ^ (1 << (32 - i)); //discard the bit
801046d8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
801046de:	66 90                	xchg   %ax,%ax
  for (int i = 1; i <= 32; i++)
801046e0:	83 c6 01             	add    $0x1,%esi
801046e3:	83 fe 21             	cmp    $0x21,%esi
801046e6:	74 88                	je     80104670 <checkS+0x130>
801046e8:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801046ee:	e9 aa fe ff ff       	jmp    8010459d <checkS+0x5d>
801046f3:	90                   	nop
801046f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" if\n");
801046f8:	c7 45 08 e0 7c 10 80 	movl   $0x80107ce0,0x8(%ebp)
}
801046ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104702:	5b                   	pop    %ebx
80104703:	5e                   	pop    %esi
80104704:	5f                   	pop    %edi
80104705:	5d                   	pop    %ebp
    cprintf(" if\n");
80104706:	e9 55 bf ff ff       	jmp    80100660 <cprintf>
8010470b:	90                   	nop
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kill(curproc->pid, SIGKILL); //
80104710:	83 ec 08             	sub    $0x8,%esp
80104713:	6a 09                	push   $0x9
80104715:	ff 73 10             	pushl  0x10(%ebx)
80104718:	e8 33 fb ff ff       	call   80104250 <kill>
      continue;
8010471d:	83 c4 10             	add    $0x10,%esp
80104720:	eb be                	jmp    801046e0 <checkS+0x1a0>
80104722:	66 90                	xchg   %ax,%ax
80104724:	66 90                	xchg   %ax,%ax
80104726:	66 90                	xchg   %ax,%ax
80104728:	66 90                	xchg   %ax,%ax
8010472a:	66 90                	xchg   %ax,%ax
8010472c:	66 90                	xchg   %ax,%ax
8010472e:	66 90                	xchg   %ax,%ax

80104730 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	83 ec 0c             	sub    $0xc,%esp
80104737:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010473a:	68 48 7d 10 80       	push   $0x80107d48
8010473f:	8d 43 04             	lea    0x4(%ebx),%eax
80104742:	50                   	push   %eax
80104743:	e8 18 01 00 00       	call   80104860 <initlock>
  lk->name = name;
80104748:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010474b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104751:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104754:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010475b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010475e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104761:	c9                   	leave  
80104762:	c3                   	ret    
80104763:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104770 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
80104775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104778:	83 ec 0c             	sub    $0xc,%esp
8010477b:	8d 73 04             	lea    0x4(%ebx),%esi
8010477e:	56                   	push   %esi
8010477f:	e8 1c 02 00 00       	call   801049a0 <acquire>
  while (lk->locked) {
80104784:	8b 13                	mov    (%ebx),%edx
80104786:	83 c4 10             	add    $0x10,%esp
80104789:	85 d2                	test   %edx,%edx
8010478b:	74 16                	je     801047a3 <acquiresleep+0x33>
8010478d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104790:	83 ec 08             	sub    $0x8,%esp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
80104795:	e8 e6 f9 ff ff       	call   80104180 <sleep>
  while (lk->locked) {
8010479a:	8b 03                	mov    (%ebx),%eax
8010479c:	83 c4 10             	add    $0x10,%esp
8010479f:	85 c0                	test   %eax,%eax
801047a1:	75 ed                	jne    80104790 <acquiresleep+0x20>
  }
  lk->locked = 1;
801047a3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801047a9:	e8 72 f1 ff ff       	call   80103920 <myproc>
801047ae:	8b 40 10             	mov    0x10(%eax),%eax
801047b1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801047b4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801047b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047ba:	5b                   	pop    %ebx
801047bb:	5e                   	pop    %esi
801047bc:	5d                   	pop    %ebp
  release(&lk->lk);
801047bd:	e9 9e 02 00 00       	jmp    80104a60 <release>
801047c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047d0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	56                   	push   %esi
801047d4:	53                   	push   %ebx
801047d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047d8:	83 ec 0c             	sub    $0xc,%esp
801047db:	8d 73 04             	lea    0x4(%ebx),%esi
801047de:	56                   	push   %esi
801047df:	e8 bc 01 00 00       	call   801049a0 <acquire>
  lk->locked = 0;
801047e4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801047ea:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801047f1:	89 1c 24             	mov    %ebx,(%esp)
801047f4:	e8 37 fa ff ff       	call   80104230 <wakeup>
  release(&lk->lk);
801047f9:	89 75 08             	mov    %esi,0x8(%ebp)
801047fc:	83 c4 10             	add    $0x10,%esp
}
801047ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104802:	5b                   	pop    %ebx
80104803:	5e                   	pop    %esi
80104804:	5d                   	pop    %ebp
  release(&lk->lk);
80104805:	e9 56 02 00 00       	jmp    80104a60 <release>
8010480a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104810 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	57                   	push   %edi
80104814:	56                   	push   %esi
80104815:	53                   	push   %ebx
80104816:	31 ff                	xor    %edi,%edi
80104818:	83 ec 18             	sub    $0x18,%esp
8010481b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010481e:	8d 73 04             	lea    0x4(%ebx),%esi
80104821:	56                   	push   %esi
80104822:	e8 79 01 00 00       	call   801049a0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104827:	8b 03                	mov    (%ebx),%eax
80104829:	83 c4 10             	add    $0x10,%esp
8010482c:	85 c0                	test   %eax,%eax
8010482e:	74 13                	je     80104843 <holdingsleep+0x33>
80104830:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104833:	e8 e8 f0 ff ff       	call   80103920 <myproc>
80104838:	39 58 10             	cmp    %ebx,0x10(%eax)
8010483b:	0f 94 c0             	sete   %al
8010483e:	0f b6 c0             	movzbl %al,%eax
80104841:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104843:	83 ec 0c             	sub    $0xc,%esp
80104846:	56                   	push   %esi
80104847:	e8 14 02 00 00       	call   80104a60 <release>
  return r;
}
8010484c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010484f:	89 f8                	mov    %edi,%eax
80104851:	5b                   	pop    %ebx
80104852:	5e                   	pop    %esi
80104853:	5f                   	pop    %edi
80104854:	5d                   	pop    %ebp
80104855:	c3                   	ret    
80104856:	66 90                	xchg   %ax,%ax
80104858:	66 90                	xchg   %ax,%ax
8010485a:	66 90                	xchg   %ax,%ax
8010485c:	66 90                	xchg   %ax,%ax
8010485e:	66 90                	xchg   %ax,%ax

80104860 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104866:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104869:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010486f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104872:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104879:	5d                   	pop    %ebp
8010487a:	c3                   	ret    
8010487b:	90                   	nop
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104880 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104880:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104881:	31 d2                	xor    %edx,%edx
{
80104883:	89 e5                	mov    %esp,%ebp
80104885:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104886:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104889:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010488c:	83 e8 08             	sub    $0x8,%eax
8010488f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104890:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104896:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010489c:	77 1a                	ja     801048b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010489e:	8b 58 04             	mov    0x4(%eax),%ebx
801048a1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801048a4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801048a7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801048a9:	83 fa 0a             	cmp    $0xa,%edx
801048ac:	75 e2                	jne    80104890 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801048ae:	5b                   	pop    %ebx
801048af:	5d                   	pop    %ebp
801048b0:	c3                   	ret    
801048b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048b8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801048bb:	83 c1 28             	add    $0x28,%ecx
801048be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801048c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801048c6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801048c9:	39 c1                	cmp    %eax,%ecx
801048cb:	75 f3                	jne    801048c0 <getcallerpcs+0x40>
}
801048cd:	5b                   	pop    %ebx
801048ce:	5d                   	pop    %ebp
801048cf:	c3                   	ret    

801048d0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	53                   	push   %ebx
801048d4:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048d7:	9c                   	pushf  
801048d8:	5b                   	pop    %ebx
  asm volatile("cli");
801048d9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801048da:	e8 a1 ef ff ff       	call   80103880 <mycpu>
801048df:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801048e5:	85 c0                	test   %eax,%eax
801048e7:	75 11                	jne    801048fa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801048e9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801048ef:	e8 8c ef ff ff       	call   80103880 <mycpu>
801048f4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801048fa:	e8 81 ef ff ff       	call   80103880 <mycpu>
801048ff:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104906:	83 c4 04             	add    $0x4,%esp
80104909:	5b                   	pop    %ebx
8010490a:	5d                   	pop    %ebp
8010490b:	c3                   	ret    
8010490c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104910 <popcli>:

void
popcli(void)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104916:	9c                   	pushf  
80104917:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104918:	f6 c4 02             	test   $0x2,%ah
8010491b:	75 35                	jne    80104952 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010491d:	e8 5e ef ff ff       	call   80103880 <mycpu>
80104922:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104929:	78 34                	js     8010495f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010492b:	e8 50 ef ff ff       	call   80103880 <mycpu>
80104930:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104936:	85 d2                	test   %edx,%edx
80104938:	74 06                	je     80104940 <popcli+0x30>
    sti();
}
8010493a:	c9                   	leave  
8010493b:	c3                   	ret    
8010493c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104940:	e8 3b ef ff ff       	call   80103880 <mycpu>
80104945:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010494b:	85 c0                	test   %eax,%eax
8010494d:	74 eb                	je     8010493a <popcli+0x2a>
  asm volatile("sti");
8010494f:	fb                   	sti    
}
80104950:	c9                   	leave  
80104951:	c3                   	ret    
    panic("popcli - interruptible");
80104952:	83 ec 0c             	sub    $0xc,%esp
80104955:	68 53 7d 10 80       	push   $0x80107d53
8010495a:	e8 31 ba ff ff       	call   80100390 <panic>
    panic("popcli");
8010495f:	83 ec 0c             	sub    $0xc,%esp
80104962:	68 6a 7d 10 80       	push   $0x80107d6a
80104967:	e8 24 ba ff ff       	call   80100390 <panic>
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104970 <holding>:
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	53                   	push   %ebx
80104975:	8b 75 08             	mov    0x8(%ebp),%esi
80104978:	31 db                	xor    %ebx,%ebx
  pushcli();
8010497a:	e8 51 ff ff ff       	call   801048d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010497f:	8b 06                	mov    (%esi),%eax
80104981:	85 c0                	test   %eax,%eax
80104983:	74 10                	je     80104995 <holding+0x25>
80104985:	8b 5e 08             	mov    0x8(%esi),%ebx
80104988:	e8 f3 ee ff ff       	call   80103880 <mycpu>
8010498d:	39 c3                	cmp    %eax,%ebx
8010498f:	0f 94 c3             	sete   %bl
80104992:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104995:	e8 76 ff ff ff       	call   80104910 <popcli>
}
8010499a:	89 d8                	mov    %ebx,%eax
8010499c:	5b                   	pop    %ebx
8010499d:	5e                   	pop    %esi
8010499e:	5d                   	pop    %ebp
8010499f:	c3                   	ret    

801049a0 <acquire>:
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801049a5:	e8 26 ff ff ff       	call   801048d0 <pushcli>
  if(holding(lk))
801049aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049ad:	83 ec 0c             	sub    $0xc,%esp
801049b0:	53                   	push   %ebx
801049b1:	e8 ba ff ff ff       	call   80104970 <holding>
801049b6:	83 c4 10             	add    $0x10,%esp
801049b9:	85 c0                	test   %eax,%eax
801049bb:	0f 85 83 00 00 00    	jne    80104a44 <acquire+0xa4>
801049c1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801049c3:	ba 01 00 00 00       	mov    $0x1,%edx
801049c8:	eb 09                	jmp    801049d3 <acquire+0x33>
801049ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049d3:	89 d0                	mov    %edx,%eax
801049d5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801049d8:	85 c0                	test   %eax,%eax
801049da:	75 f4                	jne    801049d0 <acquire+0x30>
  __sync_synchronize();
801049dc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801049e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049e4:	e8 97 ee ff ff       	call   80103880 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801049e9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801049ec:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801049ef:	89 e8                	mov    %ebp,%eax
801049f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049f8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801049fe:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104a04:	77 1a                	ja     80104a20 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104a06:	8b 48 04             	mov    0x4(%eax),%ecx
80104a09:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104a0c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104a0f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a11:	83 fe 0a             	cmp    $0xa,%esi
80104a14:	75 e2                	jne    801049f8 <acquire+0x58>
}
80104a16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a19:	5b                   	pop    %ebx
80104a1a:	5e                   	pop    %esi
80104a1b:	5d                   	pop    %ebp
80104a1c:	c3                   	ret    
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
80104a20:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104a23:	83 c2 28             	add    $0x28,%edx
80104a26:	8d 76 00             	lea    0x0(%esi),%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104a30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a36:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104a39:	39 d0                	cmp    %edx,%eax
80104a3b:	75 f3                	jne    80104a30 <acquire+0x90>
}
80104a3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a40:	5b                   	pop    %ebx
80104a41:	5e                   	pop    %esi
80104a42:	5d                   	pop    %ebp
80104a43:	c3                   	ret    
    panic("acquire");
80104a44:	83 ec 0c             	sub    $0xc,%esp
80104a47:	68 71 7d 10 80       	push   $0x80107d71
80104a4c:	e8 3f b9 ff ff       	call   80100390 <panic>
80104a51:	eb 0d                	jmp    80104a60 <release>
80104a53:	90                   	nop
80104a54:	90                   	nop
80104a55:	90                   	nop
80104a56:	90                   	nop
80104a57:	90                   	nop
80104a58:	90                   	nop
80104a59:	90                   	nop
80104a5a:	90                   	nop
80104a5b:	90                   	nop
80104a5c:	90                   	nop
80104a5d:	90                   	nop
80104a5e:	90                   	nop
80104a5f:	90                   	nop

80104a60 <release>:
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	53                   	push   %ebx
80104a64:	83 ec 10             	sub    $0x10,%esp
80104a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104a6a:	53                   	push   %ebx
80104a6b:	e8 00 ff ff ff       	call   80104970 <holding>
80104a70:	83 c4 10             	add    $0x10,%esp
80104a73:	85 c0                	test   %eax,%eax
80104a75:	74 22                	je     80104a99 <release+0x39>
  lk->pcs[0] = 0;
80104a77:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a7e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a85:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a8a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a93:	c9                   	leave  
  popcli();
80104a94:	e9 77 fe ff ff       	jmp    80104910 <popcli>
    panic("release");
80104a99:	83 ec 0c             	sub    $0xc,%esp
80104a9c:	68 79 7d 10 80       	push   $0x80107d79
80104aa1:	e8 ea b8 ff ff       	call   80100390 <panic>
80104aa6:	66 90                	xchg   %ax,%ax
80104aa8:	66 90                	xchg   %ax,%ax
80104aaa:	66 90                	xchg   %ax,%ax
80104aac:	66 90                	xchg   %ax,%ax
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	57                   	push   %edi
80104ab4:	53                   	push   %ebx
80104ab5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ab8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104abb:	f6 c2 03             	test   $0x3,%dl
80104abe:	75 05                	jne    80104ac5 <memset+0x15>
80104ac0:	f6 c1 03             	test   $0x3,%cl
80104ac3:	74 13                	je     80104ad8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104ac5:	89 d7                	mov    %edx,%edi
80104ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aca:	fc                   	cld    
80104acb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104acd:	5b                   	pop    %ebx
80104ace:	89 d0                	mov    %edx,%eax
80104ad0:	5f                   	pop    %edi
80104ad1:	5d                   	pop    %ebp
80104ad2:	c3                   	ret    
80104ad3:	90                   	nop
80104ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104ad8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104adc:	c1 e9 02             	shr    $0x2,%ecx
80104adf:	89 f8                	mov    %edi,%eax
80104ae1:	89 fb                	mov    %edi,%ebx
80104ae3:	c1 e0 18             	shl    $0x18,%eax
80104ae6:	c1 e3 10             	shl    $0x10,%ebx
80104ae9:	09 d8                	or     %ebx,%eax
80104aeb:	09 f8                	or     %edi,%eax
80104aed:	c1 e7 08             	shl    $0x8,%edi
80104af0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104af2:	89 d7                	mov    %edx,%edi
80104af4:	fc                   	cld    
80104af5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104af7:	5b                   	pop    %ebx
80104af8:	89 d0                	mov    %edx,%eax
80104afa:	5f                   	pop    %edi
80104afb:	5d                   	pop    %ebp
80104afc:	c3                   	ret    
80104afd:	8d 76 00             	lea    0x0(%esi),%esi

80104b00 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
80104b05:	53                   	push   %ebx
80104b06:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b09:	8b 75 08             	mov    0x8(%ebp),%esi
80104b0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104b0f:	85 db                	test   %ebx,%ebx
80104b11:	74 29                	je     80104b3c <memcmp+0x3c>
    if(*s1 != *s2)
80104b13:	0f b6 16             	movzbl (%esi),%edx
80104b16:	0f b6 0f             	movzbl (%edi),%ecx
80104b19:	38 d1                	cmp    %dl,%cl
80104b1b:	75 2b                	jne    80104b48 <memcmp+0x48>
80104b1d:	b8 01 00 00 00       	mov    $0x1,%eax
80104b22:	eb 14                	jmp    80104b38 <memcmp+0x38>
80104b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b28:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104b2c:	83 c0 01             	add    $0x1,%eax
80104b2f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104b34:	38 ca                	cmp    %cl,%dl
80104b36:	75 10                	jne    80104b48 <memcmp+0x48>
  while(n-- > 0){
80104b38:	39 d8                	cmp    %ebx,%eax
80104b3a:	75 ec                	jne    80104b28 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104b3c:	5b                   	pop    %ebx
  return 0;
80104b3d:	31 c0                	xor    %eax,%eax
}
80104b3f:	5e                   	pop    %esi
80104b40:	5f                   	pop    %edi
80104b41:	5d                   	pop    %ebp
80104b42:	c3                   	ret    
80104b43:	90                   	nop
80104b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104b48:	0f b6 c2             	movzbl %dl,%eax
}
80104b4b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104b4c:	29 c8                	sub    %ecx,%eax
}
80104b4e:	5e                   	pop    %esi
80104b4f:	5f                   	pop    %edi
80104b50:	5d                   	pop    %ebp
80104b51:	c3                   	ret    
80104b52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
80104b65:	8b 45 08             	mov    0x8(%ebp),%eax
80104b68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b6b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b6e:	39 c3                	cmp    %eax,%ebx
80104b70:	73 26                	jae    80104b98 <memmove+0x38>
80104b72:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104b75:	39 c8                	cmp    %ecx,%eax
80104b77:	73 1f                	jae    80104b98 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104b79:	85 f6                	test   %esi,%esi
80104b7b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104b7e:	74 0f                	je     80104b8f <memmove+0x2f>
      *--d = *--s;
80104b80:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b84:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104b87:	83 ea 01             	sub    $0x1,%edx
80104b8a:	83 fa ff             	cmp    $0xffffffff,%edx
80104b8d:	75 f1                	jne    80104b80 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b8f:	5b                   	pop    %ebx
80104b90:	5e                   	pop    %esi
80104b91:	5d                   	pop    %ebp
80104b92:	c3                   	ret    
80104b93:	90                   	nop
80104b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104b98:	31 d2                	xor    %edx,%edx
80104b9a:	85 f6                	test   %esi,%esi
80104b9c:	74 f1                	je     80104b8f <memmove+0x2f>
80104b9e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104ba0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ba4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ba7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104baa:	39 d6                	cmp    %edx,%esi
80104bac:	75 f2                	jne    80104ba0 <memmove+0x40>
}
80104bae:	5b                   	pop    %ebx
80104baf:	5e                   	pop    %esi
80104bb0:	5d                   	pop    %ebp
80104bb1:	c3                   	ret    
80104bb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104bc3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104bc4:	eb 9a                	jmp    80104b60 <memmove>
80104bc6:	8d 76 00             	lea    0x0(%esi),%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bd0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	56                   	push   %esi
80104bd5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104bd8:	53                   	push   %ebx
80104bd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bdc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104bdf:	85 ff                	test   %edi,%edi
80104be1:	74 2f                	je     80104c12 <strncmp+0x42>
80104be3:	0f b6 01             	movzbl (%ecx),%eax
80104be6:	0f b6 1e             	movzbl (%esi),%ebx
80104be9:	84 c0                	test   %al,%al
80104beb:	74 37                	je     80104c24 <strncmp+0x54>
80104bed:	38 c3                	cmp    %al,%bl
80104bef:	75 33                	jne    80104c24 <strncmp+0x54>
80104bf1:	01 f7                	add    %esi,%edi
80104bf3:	eb 13                	jmp    80104c08 <strncmp+0x38>
80104bf5:	8d 76 00             	lea    0x0(%esi),%esi
80104bf8:	0f b6 01             	movzbl (%ecx),%eax
80104bfb:	84 c0                	test   %al,%al
80104bfd:	74 21                	je     80104c20 <strncmp+0x50>
80104bff:	0f b6 1a             	movzbl (%edx),%ebx
80104c02:	89 d6                	mov    %edx,%esi
80104c04:	38 d8                	cmp    %bl,%al
80104c06:	75 1c                	jne    80104c24 <strncmp+0x54>
    n--, p++, q++;
80104c08:	8d 56 01             	lea    0x1(%esi),%edx
80104c0b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104c0e:	39 fa                	cmp    %edi,%edx
80104c10:	75 e6                	jne    80104bf8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104c12:	5b                   	pop    %ebx
    return 0;
80104c13:	31 c0                	xor    %eax,%eax
}
80104c15:	5e                   	pop    %esi
80104c16:	5f                   	pop    %edi
80104c17:	5d                   	pop    %ebp
80104c18:	c3                   	ret    
80104c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c20:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104c24:	29 d8                	sub    %ebx,%eax
}
80104c26:	5b                   	pop    %ebx
80104c27:	5e                   	pop    %esi
80104c28:	5f                   	pop    %edi
80104c29:	5d                   	pop    %ebp
80104c2a:	c3                   	ret    
80104c2b:	90                   	nop
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c30 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
80104c35:	8b 45 08             	mov    0x8(%ebp),%eax
80104c38:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104c3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104c3e:	89 c2                	mov    %eax,%edx
80104c40:	eb 19                	jmp    80104c5b <strncpy+0x2b>
80104c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c48:	83 c3 01             	add    $0x1,%ebx
80104c4b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104c4f:	83 c2 01             	add    $0x1,%edx
80104c52:	84 c9                	test   %cl,%cl
80104c54:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c57:	74 09                	je     80104c62 <strncpy+0x32>
80104c59:	89 f1                	mov    %esi,%ecx
80104c5b:	85 c9                	test   %ecx,%ecx
80104c5d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104c60:	7f e6                	jg     80104c48 <strncpy+0x18>
    ;
  while(n-- > 0)
80104c62:	31 c9                	xor    %ecx,%ecx
80104c64:	85 f6                	test   %esi,%esi
80104c66:	7e 17                	jle    80104c7f <strncpy+0x4f>
80104c68:	90                   	nop
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c70:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c74:	89 f3                	mov    %esi,%ebx
80104c76:	83 c1 01             	add    $0x1,%ecx
80104c79:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104c7b:	85 db                	test   %ebx,%ebx
80104c7d:	7f f1                	jg     80104c70 <strncpy+0x40>
  return os;
}
80104c7f:	5b                   	pop    %ebx
80104c80:	5e                   	pop    %esi
80104c81:	5d                   	pop    %ebp
80104c82:	c3                   	ret    
80104c83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c90 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
80104c95:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c98:	8b 45 08             	mov    0x8(%ebp),%eax
80104c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104c9e:	85 c9                	test   %ecx,%ecx
80104ca0:	7e 26                	jle    80104cc8 <safestrcpy+0x38>
80104ca2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104ca6:	89 c1                	mov    %eax,%ecx
80104ca8:	eb 17                	jmp    80104cc1 <safestrcpy+0x31>
80104caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104cb0:	83 c2 01             	add    $0x1,%edx
80104cb3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104cb7:	83 c1 01             	add    $0x1,%ecx
80104cba:	84 db                	test   %bl,%bl
80104cbc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104cbf:	74 04                	je     80104cc5 <safestrcpy+0x35>
80104cc1:	39 f2                	cmp    %esi,%edx
80104cc3:	75 eb                	jne    80104cb0 <safestrcpy+0x20>
    ;
  *s = 0;
80104cc5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104cc8:	5b                   	pop    %ebx
80104cc9:	5e                   	pop    %esi
80104cca:	5d                   	pop    %ebp
80104ccb:	c3                   	ret    
80104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cd0 <strlen>:

int
strlen(const char *s)
{
80104cd0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104cd1:	31 c0                	xor    %eax,%eax
{
80104cd3:	89 e5                	mov    %esp,%ebp
80104cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104cd8:	80 3a 00             	cmpb   $0x0,(%edx)
80104cdb:	74 0c                	je     80104ce9 <strlen+0x19>
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi
80104ce0:	83 c0 01             	add    $0x1,%eax
80104ce3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ce7:	75 f7                	jne    80104ce0 <strlen+0x10>
    ;
  return n;
}
80104ce9:	5d                   	pop    %ebp
80104cea:	c3                   	ret    

80104ceb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104ceb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104cef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104cf3:	55                   	push   %ebp
  pushl %ebx
80104cf4:	53                   	push   %ebx
  pushl %esi
80104cf5:	56                   	push   %esi
  pushl %edi
80104cf6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104cf7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104cf9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104cfb:	5f                   	pop    %edi
  popl %esi
80104cfc:	5e                   	pop    %esi
  popl %ebx
80104cfd:	5b                   	pop    %ebx
  popl %ebp
80104cfe:	5d                   	pop    %ebp
  ret
80104cff:	c3                   	ret    

80104d00 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	53                   	push   %ebx
80104d04:	83 ec 04             	sub    $0x4,%esp
80104d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104d0a:	e8 11 ec ff ff       	call   80103920 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d0f:	8b 00                	mov    (%eax),%eax
80104d11:	39 d8                	cmp    %ebx,%eax
80104d13:	76 1b                	jbe    80104d30 <fetchint+0x30>
80104d15:	8d 53 04             	lea    0x4(%ebx),%edx
80104d18:	39 d0                	cmp    %edx,%eax
80104d1a:	72 14                	jb     80104d30 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d1f:	8b 13                	mov    (%ebx),%edx
80104d21:	89 10                	mov    %edx,(%eax)
  return 0;
80104d23:	31 c0                	xor    %eax,%eax
}
80104d25:	83 c4 04             	add    $0x4,%esp
80104d28:	5b                   	pop    %ebx
80104d29:	5d                   	pop    %ebp
80104d2a:	c3                   	ret    
80104d2b:	90                   	nop
80104d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d35:	eb ee                	jmp    80104d25 <fetchint+0x25>
80104d37:	89 f6                	mov    %esi,%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	53                   	push   %ebx
80104d44:	83 ec 04             	sub    $0x4,%esp
80104d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104d4a:	e8 d1 eb ff ff       	call   80103920 <myproc>

  if(addr >= curproc->sz)
80104d4f:	39 18                	cmp    %ebx,(%eax)
80104d51:	76 29                	jbe    80104d7c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104d53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104d56:	89 da                	mov    %ebx,%edx
80104d58:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104d5a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104d5c:	39 c3                	cmp    %eax,%ebx
80104d5e:	73 1c                	jae    80104d7c <fetchstr+0x3c>
    if(*s == 0)
80104d60:	80 3b 00             	cmpb   $0x0,(%ebx)
80104d63:	75 10                	jne    80104d75 <fetchstr+0x35>
80104d65:	eb 39                	jmp    80104da0 <fetchstr+0x60>
80104d67:	89 f6                	mov    %esi,%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d70:	80 3a 00             	cmpb   $0x0,(%edx)
80104d73:	74 1b                	je     80104d90 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104d75:	83 c2 01             	add    $0x1,%edx
80104d78:	39 d0                	cmp    %edx,%eax
80104d7a:	77 f4                	ja     80104d70 <fetchstr+0x30>
    return -1;
80104d7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104d81:	83 c4 04             	add    $0x4,%esp
80104d84:	5b                   	pop    %ebx
80104d85:	5d                   	pop    %ebp
80104d86:	c3                   	ret    
80104d87:	89 f6                	mov    %esi,%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d90:	83 c4 04             	add    $0x4,%esp
80104d93:	89 d0                	mov    %edx,%eax
80104d95:	29 d8                	sub    %ebx,%eax
80104d97:	5b                   	pop    %ebx
80104d98:	5d                   	pop    %ebp
80104d99:	c3                   	ret    
80104d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104da0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104da2:	eb dd                	jmp    80104d81 <fetchstr+0x41>
80104da4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104daa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104db0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	56                   	push   %esi
80104db4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104db5:	e8 66 eb ff ff       	call   80103920 <myproc>
80104dba:	8b 40 18             	mov    0x18(%eax),%eax
80104dbd:	8b 55 08             	mov    0x8(%ebp),%edx
80104dc0:	8b 40 44             	mov    0x44(%eax),%eax
80104dc3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104dc6:	e8 55 eb ff ff       	call   80103920 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dcb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104dcd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dd0:	39 c6                	cmp    %eax,%esi
80104dd2:	73 1c                	jae    80104df0 <argint+0x40>
80104dd4:	8d 53 08             	lea    0x8(%ebx),%edx
80104dd7:	39 d0                	cmp    %edx,%eax
80104dd9:	72 15                	jb     80104df0 <argint+0x40>
  *ip = *(int*)(addr);
80104ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dde:	8b 53 04             	mov    0x4(%ebx),%edx
80104de1:	89 10                	mov    %edx,(%eax)
  return 0;
80104de3:	31 c0                	xor    %eax,%eax
}
80104de5:	5b                   	pop    %ebx
80104de6:	5e                   	pop    %esi
80104de7:	5d                   	pop    %ebp
80104de8:	c3                   	ret    
80104de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104df5:	eb ee                	jmp    80104de5 <argint+0x35>
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	53                   	push   %ebx
80104e05:	83 ec 10             	sub    $0x10,%esp
80104e08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104e0b:	e8 10 eb ff ff       	call   80103920 <myproc>
80104e10:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104e12:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e15:	83 ec 08             	sub    $0x8,%esp
80104e18:	50                   	push   %eax
80104e19:	ff 75 08             	pushl  0x8(%ebp)
80104e1c:	e8 8f ff ff ff       	call   80104db0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e21:	83 c4 10             	add    $0x10,%esp
80104e24:	85 c0                	test   %eax,%eax
80104e26:	78 28                	js     80104e50 <argptr+0x50>
80104e28:	85 db                	test   %ebx,%ebx
80104e2a:	78 24                	js     80104e50 <argptr+0x50>
80104e2c:	8b 16                	mov    (%esi),%edx
80104e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e31:	39 c2                	cmp    %eax,%edx
80104e33:	76 1b                	jbe    80104e50 <argptr+0x50>
80104e35:	01 c3                	add    %eax,%ebx
80104e37:	39 da                	cmp    %ebx,%edx
80104e39:	72 15                	jb     80104e50 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104e3b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e3e:	89 02                	mov    %eax,(%edx)
  return 0;
80104e40:	31 c0                	xor    %eax,%eax
}
80104e42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e45:	5b                   	pop    %ebx
80104e46:	5e                   	pop    %esi
80104e47:	5d                   	pop    %ebp
80104e48:	c3                   	ret    
80104e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e55:	eb eb                	jmp    80104e42 <argptr+0x42>
80104e57:	89 f6                	mov    %esi,%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e60 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104e66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e69:	50                   	push   %eax
80104e6a:	ff 75 08             	pushl  0x8(%ebp)
80104e6d:	e8 3e ff ff ff       	call   80104db0 <argint>
80104e72:	83 c4 10             	add    $0x10,%esp
80104e75:	85 c0                	test   %eax,%eax
80104e77:	78 17                	js     80104e90 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104e79:	83 ec 08             	sub    $0x8,%esp
80104e7c:	ff 75 0c             	pushl  0xc(%ebp)
80104e7f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e82:	e8 b9 fe ff ff       	call   80104d40 <fetchstr>
80104e87:	83 c4 10             	add    $0x10,%esp
}
80104e8a:	c9                   	leave  
80104e8b:	c3                   	ret    
80104e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e95:	c9                   	leave  
80104e96:	c3                   	ret    
80104e97:	89 f6                	mov    %esi,%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <syscall>:
[SYS_sigret]  sys_sigret
};

void
syscall(void)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	53                   	push   %ebx
80104ea4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ea7:	e8 74 ea ff ff       	call   80103920 <myproc>
80104eac:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104eae:	8b 40 18             	mov    0x18(%eax),%eax
80104eb1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104eb4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104eb7:	83 fa 17             	cmp    $0x17,%edx
80104eba:	77 1c                	ja     80104ed8 <syscall+0x38>
80104ebc:	8b 14 85 a0 7d 10 80 	mov    -0x7fef8260(,%eax,4),%edx
80104ec3:	85 d2                	test   %edx,%edx
80104ec5:	74 11                	je     80104ed8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104ec7:	ff d2                	call   *%edx
80104ec9:	8b 53 18             	mov    0x18(%ebx),%edx
80104ecc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ecf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ed2:	c9                   	leave  
80104ed3:	c3                   	ret    
80104ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ed8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ed9:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104edc:	50                   	push   %eax
80104edd:	ff 73 10             	pushl  0x10(%ebx)
80104ee0:	68 81 7d 10 80       	push   $0x80107d81
80104ee5:	e8 76 b7 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104eea:	8b 43 18             	mov    0x18(%ebx),%eax
80104eed:	83 c4 10             	add    $0x10,%esp
80104ef0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104ef7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104efa:	c9                   	leave  
80104efb:	c3                   	ret    
80104efc:	66 90                	xchg   %ax,%ax
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	57                   	push   %edi
80104f04:	56                   	push   %esi
80104f05:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104f06:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104f09:	83 ec 34             	sub    $0x34,%esp
80104f0c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104f0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104f12:	56                   	push   %esi
80104f13:	50                   	push   %eax
{
80104f14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104f17:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104f1a:	e8 11 d0 ff ff       	call   80101f30 <nameiparent>
80104f1f:	83 c4 10             	add    $0x10,%esp
80104f22:	85 c0                	test   %eax,%eax
80104f24:	0f 84 46 01 00 00    	je     80105070 <create+0x170>
    return 0;
  ilock(dp);
80104f2a:	83 ec 0c             	sub    $0xc,%esp
80104f2d:	89 c3                	mov    %eax,%ebx
80104f2f:	50                   	push   %eax
80104f30:	e8 7b c7 ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104f35:	83 c4 0c             	add    $0xc,%esp
80104f38:	6a 00                	push   $0x0
80104f3a:	56                   	push   %esi
80104f3b:	53                   	push   %ebx
80104f3c:	e8 9f cc ff ff       	call   80101be0 <dirlookup>
80104f41:	83 c4 10             	add    $0x10,%esp
80104f44:	85 c0                	test   %eax,%eax
80104f46:	89 c7                	mov    %eax,%edi
80104f48:	74 36                	je     80104f80 <create+0x80>
    iunlockput(dp);
80104f4a:	83 ec 0c             	sub    $0xc,%esp
80104f4d:	53                   	push   %ebx
80104f4e:	e8 ed c9 ff ff       	call   80101940 <iunlockput>
    ilock(ip);
80104f53:	89 3c 24             	mov    %edi,(%esp)
80104f56:	e8 55 c7 ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f5b:	83 c4 10             	add    $0x10,%esp
80104f5e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104f63:	0f 85 97 00 00 00    	jne    80105000 <create+0x100>
80104f69:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104f6e:	0f 85 8c 00 00 00    	jne    80105000 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f77:	89 f8                	mov    %edi,%eax
80104f79:	5b                   	pop    %ebx
80104f7a:	5e                   	pop    %esi
80104f7b:	5f                   	pop    %edi
80104f7c:	5d                   	pop    %ebp
80104f7d:	c3                   	ret    
80104f7e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80104f80:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104f84:	83 ec 08             	sub    $0x8,%esp
80104f87:	50                   	push   %eax
80104f88:	ff 33                	pushl  (%ebx)
80104f8a:	e8 b1 c5 ff ff       	call   80101540 <ialloc>
80104f8f:	83 c4 10             	add    $0x10,%esp
80104f92:	85 c0                	test   %eax,%eax
80104f94:	89 c7                	mov    %eax,%edi
80104f96:	0f 84 e8 00 00 00    	je     80105084 <create+0x184>
  ilock(ip);
80104f9c:	83 ec 0c             	sub    $0xc,%esp
80104f9f:	50                   	push   %eax
80104fa0:	e8 0b c7 ff ff       	call   801016b0 <ilock>
  ip->major = major;
80104fa5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104fa9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104fad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104fb1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104fb5:	b8 01 00 00 00       	mov    $0x1,%eax
80104fba:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104fbe:	89 3c 24             	mov    %edi,(%esp)
80104fc1:	e8 3a c6 ff ff       	call   80101600 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104fc6:	83 c4 10             	add    $0x10,%esp
80104fc9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104fce:	74 50                	je     80105020 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104fd0:	83 ec 04             	sub    $0x4,%esp
80104fd3:	ff 77 04             	pushl  0x4(%edi)
80104fd6:	56                   	push   %esi
80104fd7:	53                   	push   %ebx
80104fd8:	e8 73 ce ff ff       	call   80101e50 <dirlink>
80104fdd:	83 c4 10             	add    $0x10,%esp
80104fe0:	85 c0                	test   %eax,%eax
80104fe2:	0f 88 8f 00 00 00    	js     80105077 <create+0x177>
  iunlockput(dp);
80104fe8:	83 ec 0c             	sub    $0xc,%esp
80104feb:	53                   	push   %ebx
80104fec:	e8 4f c9 ff ff       	call   80101940 <iunlockput>
  return ip;
80104ff1:	83 c4 10             	add    $0x10,%esp
}
80104ff4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ff7:	89 f8                	mov    %edi,%eax
80104ff9:	5b                   	pop    %ebx
80104ffa:	5e                   	pop    %esi
80104ffb:	5f                   	pop    %edi
80104ffc:	5d                   	pop    %ebp
80104ffd:	c3                   	ret    
80104ffe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105000:	83 ec 0c             	sub    $0xc,%esp
80105003:	57                   	push   %edi
    return 0;
80105004:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105006:	e8 35 c9 ff ff       	call   80101940 <iunlockput>
    return 0;
8010500b:	83 c4 10             	add    $0x10,%esp
}
8010500e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105011:	89 f8                	mov    %edi,%eax
80105013:	5b                   	pop    %ebx
80105014:	5e                   	pop    %esi
80105015:	5f                   	pop    %edi
80105016:	5d                   	pop    %ebp
80105017:	c3                   	ret    
80105018:	90                   	nop
80105019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105020:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105025:	83 ec 0c             	sub    $0xc,%esp
80105028:	53                   	push   %ebx
80105029:	e8 d2 c5 ff ff       	call   80101600 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010502e:	83 c4 0c             	add    $0xc,%esp
80105031:	ff 77 04             	pushl  0x4(%edi)
80105034:	68 20 7e 10 80       	push   $0x80107e20
80105039:	57                   	push   %edi
8010503a:	e8 11 ce ff ff       	call   80101e50 <dirlink>
8010503f:	83 c4 10             	add    $0x10,%esp
80105042:	85 c0                	test   %eax,%eax
80105044:	78 1c                	js     80105062 <create+0x162>
80105046:	83 ec 04             	sub    $0x4,%esp
80105049:	ff 73 04             	pushl  0x4(%ebx)
8010504c:	68 1f 7e 10 80       	push   $0x80107e1f
80105051:	57                   	push   %edi
80105052:	e8 f9 cd ff ff       	call   80101e50 <dirlink>
80105057:	83 c4 10             	add    $0x10,%esp
8010505a:	85 c0                	test   %eax,%eax
8010505c:	0f 89 6e ff ff ff    	jns    80104fd0 <create+0xd0>
      panic("create dots");
80105062:	83 ec 0c             	sub    $0xc,%esp
80105065:	68 13 7e 10 80       	push   $0x80107e13
8010506a:	e8 21 b3 ff ff       	call   80100390 <panic>
8010506f:	90                   	nop
    return 0;
80105070:	31 ff                	xor    %edi,%edi
80105072:	e9 fd fe ff ff       	jmp    80104f74 <create+0x74>
    panic("create: dirlink");
80105077:	83 ec 0c             	sub    $0xc,%esp
8010507a:	68 22 7e 10 80       	push   $0x80107e22
8010507f:	e8 0c b3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	68 04 7e 10 80       	push   $0x80107e04
8010508c:	e8 ff b2 ff ff       	call   80100390 <panic>
80105091:	eb 0d                	jmp    801050a0 <argfd.constprop.0>
80105093:	90                   	nop
80105094:	90                   	nop
80105095:	90                   	nop
80105096:	90                   	nop
80105097:	90                   	nop
80105098:	90                   	nop
80105099:	90                   	nop
8010509a:	90                   	nop
8010509b:	90                   	nop
8010509c:	90                   	nop
8010509d:	90                   	nop
8010509e:	90                   	nop
8010509f:	90                   	nop

801050a0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	56                   	push   %esi
801050a4:	53                   	push   %ebx
801050a5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801050a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801050aa:	89 d6                	mov    %edx,%esi
801050ac:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050af:	50                   	push   %eax
801050b0:	6a 00                	push   $0x0
801050b2:	e8 f9 fc ff ff       	call   80104db0 <argint>
801050b7:	83 c4 10             	add    $0x10,%esp
801050ba:	85 c0                	test   %eax,%eax
801050bc:	78 2a                	js     801050e8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050be:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050c2:	77 24                	ja     801050e8 <argfd.constprop.0+0x48>
801050c4:	e8 57 e8 ff ff       	call   80103920 <myproc>
801050c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050cc:	8b 44 90 2c          	mov    0x2c(%eax,%edx,4),%eax
801050d0:	85 c0                	test   %eax,%eax
801050d2:	74 14                	je     801050e8 <argfd.constprop.0+0x48>
  if(pfd)
801050d4:	85 db                	test   %ebx,%ebx
801050d6:	74 02                	je     801050da <argfd.constprop.0+0x3a>
    *pfd = fd;
801050d8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801050da:	89 06                	mov    %eax,(%esi)
  return 0;
801050dc:	31 c0                	xor    %eax,%eax
}
801050de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050e1:	5b                   	pop    %ebx
801050e2:	5e                   	pop    %esi
801050e3:	5d                   	pop    %ebp
801050e4:	c3                   	ret    
801050e5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ed:	eb ef                	jmp    801050de <argfd.constprop.0+0x3e>
801050ef:	90                   	nop

801050f0 <sys_dup>:
{
801050f0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801050f1:	31 c0                	xor    %eax,%eax
{
801050f3:	89 e5                	mov    %esp,%ebp
801050f5:	56                   	push   %esi
801050f6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801050f7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801050fa:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801050fd:	e8 9e ff ff ff       	call   801050a0 <argfd.constprop.0>
80105102:	85 c0                	test   %eax,%eax
80105104:	78 42                	js     80105148 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105106:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105109:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010510b:	e8 10 e8 ff ff       	call   80103920 <myproc>
80105110:	eb 0e                	jmp    80105120 <sys_dup+0x30>
80105112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105118:	83 c3 01             	add    $0x1,%ebx
8010511b:	83 fb 10             	cmp    $0x10,%ebx
8010511e:	74 28                	je     80105148 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105120:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105124:	85 d2                	test   %edx,%edx
80105126:	75 f0                	jne    80105118 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105128:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
8010512c:	83 ec 0c             	sub    $0xc,%esp
8010512f:	ff 75 f4             	pushl  -0xc(%ebp)
80105132:	e8 e9 bc ff ff       	call   80100e20 <filedup>
  return fd;
80105137:	83 c4 10             	add    $0x10,%esp
}
8010513a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010513d:	89 d8                	mov    %ebx,%eax
8010513f:	5b                   	pop    %ebx
80105140:	5e                   	pop    %esi
80105141:	5d                   	pop    %ebp
80105142:	c3                   	ret    
80105143:	90                   	nop
80105144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105148:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010514b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105150:	89 d8                	mov    %ebx,%eax
80105152:	5b                   	pop    %ebx
80105153:	5e                   	pop    %esi
80105154:	5d                   	pop    %ebp
80105155:	c3                   	ret    
80105156:	8d 76 00             	lea    0x0(%esi),%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105160 <sys_read>:
{
80105160:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105161:	31 c0                	xor    %eax,%eax
{
80105163:	89 e5                	mov    %esp,%ebp
80105165:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105168:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010516b:	e8 30 ff ff ff       	call   801050a0 <argfd.constprop.0>
80105170:	85 c0                	test   %eax,%eax
80105172:	78 4c                	js     801051c0 <sys_read+0x60>
80105174:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105177:	83 ec 08             	sub    $0x8,%esp
8010517a:	50                   	push   %eax
8010517b:	6a 02                	push   $0x2
8010517d:	e8 2e fc ff ff       	call   80104db0 <argint>
80105182:	83 c4 10             	add    $0x10,%esp
80105185:	85 c0                	test   %eax,%eax
80105187:	78 37                	js     801051c0 <sys_read+0x60>
80105189:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010518c:	83 ec 04             	sub    $0x4,%esp
8010518f:	ff 75 f0             	pushl  -0x10(%ebp)
80105192:	50                   	push   %eax
80105193:	6a 01                	push   $0x1
80105195:	e8 66 fc ff ff       	call   80104e00 <argptr>
8010519a:	83 c4 10             	add    $0x10,%esp
8010519d:	85 c0                	test   %eax,%eax
8010519f:	78 1f                	js     801051c0 <sys_read+0x60>
  return fileread(f, p, n);
801051a1:	83 ec 04             	sub    $0x4,%esp
801051a4:	ff 75 f0             	pushl  -0x10(%ebp)
801051a7:	ff 75 f4             	pushl  -0xc(%ebp)
801051aa:	ff 75 ec             	pushl  -0x14(%ebp)
801051ad:	e8 de bd ff ff       	call   80100f90 <fileread>
801051b2:	83 c4 10             	add    $0x10,%esp
}
801051b5:	c9                   	leave  
801051b6:	c3                   	ret    
801051b7:	89 f6                	mov    %esi,%esi
801051b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051c5:	c9                   	leave  
801051c6:	c3                   	ret    
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051d0 <sys_write>:
{
801051d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051d1:	31 c0                	xor    %eax,%eax
{
801051d3:	89 e5                	mov    %esp,%ebp
801051d5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051db:	e8 c0 fe ff ff       	call   801050a0 <argfd.constprop.0>
801051e0:	85 c0                	test   %eax,%eax
801051e2:	78 4c                	js     80105230 <sys_write+0x60>
801051e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051e7:	83 ec 08             	sub    $0x8,%esp
801051ea:	50                   	push   %eax
801051eb:	6a 02                	push   $0x2
801051ed:	e8 be fb ff ff       	call   80104db0 <argint>
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	85 c0                	test   %eax,%eax
801051f7:	78 37                	js     80105230 <sys_write+0x60>
801051f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051fc:	83 ec 04             	sub    $0x4,%esp
801051ff:	ff 75 f0             	pushl  -0x10(%ebp)
80105202:	50                   	push   %eax
80105203:	6a 01                	push   $0x1
80105205:	e8 f6 fb ff ff       	call   80104e00 <argptr>
8010520a:	83 c4 10             	add    $0x10,%esp
8010520d:	85 c0                	test   %eax,%eax
8010520f:	78 1f                	js     80105230 <sys_write+0x60>
  return filewrite(f, p, n);
80105211:	83 ec 04             	sub    $0x4,%esp
80105214:	ff 75 f0             	pushl  -0x10(%ebp)
80105217:	ff 75 f4             	pushl  -0xc(%ebp)
8010521a:	ff 75 ec             	pushl  -0x14(%ebp)
8010521d:	e8 fe bd ff ff       	call   80101020 <filewrite>
80105222:	83 c4 10             	add    $0x10,%esp
}
80105225:	c9                   	leave  
80105226:	c3                   	ret    
80105227:	89 f6                	mov    %esi,%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105235:	c9                   	leave  
80105236:	c3                   	ret    
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105240 <sys_close>:
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105246:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105249:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010524c:	e8 4f fe ff ff       	call   801050a0 <argfd.constprop.0>
80105251:	85 c0                	test   %eax,%eax
80105253:	78 2b                	js     80105280 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105255:	e8 c6 e6 ff ff       	call   80103920 <myproc>
8010525a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010525d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105260:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
80105267:	00 
  fileclose(f);
80105268:	ff 75 f4             	pushl  -0xc(%ebp)
8010526b:	e8 00 bc ff ff       	call   80100e70 <fileclose>
  return 0;
80105270:	83 c4 10             	add    $0x10,%esp
80105273:	31 c0                	xor    %eax,%eax
}
80105275:	c9                   	leave  
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105285:	c9                   	leave  
80105286:	c3                   	ret    
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_fstat>:
{
80105290:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105291:	31 c0                	xor    %eax,%eax
{
80105293:	89 e5                	mov    %esp,%ebp
80105295:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105298:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010529b:	e8 00 fe ff ff       	call   801050a0 <argfd.constprop.0>
801052a0:	85 c0                	test   %eax,%eax
801052a2:	78 2c                	js     801052d0 <sys_fstat+0x40>
801052a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a7:	83 ec 04             	sub    $0x4,%esp
801052aa:	6a 14                	push   $0x14
801052ac:	50                   	push   %eax
801052ad:	6a 01                	push   $0x1
801052af:	e8 4c fb ff ff       	call   80104e00 <argptr>
801052b4:	83 c4 10             	add    $0x10,%esp
801052b7:	85 c0                	test   %eax,%eax
801052b9:	78 15                	js     801052d0 <sys_fstat+0x40>
  return filestat(f, st);
801052bb:	83 ec 08             	sub    $0x8,%esp
801052be:	ff 75 f4             	pushl  -0xc(%ebp)
801052c1:	ff 75 f0             	pushl  -0x10(%ebp)
801052c4:	e8 77 bc ff ff       	call   80100f40 <filestat>
801052c9:	83 c4 10             	add    $0x10,%esp
}
801052cc:	c9                   	leave  
801052cd:	c3                   	ret    
801052ce:	66 90                	xchg   %ax,%ax
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052d5:	c9                   	leave  
801052d6:	c3                   	ret    
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <sys_link>:
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	57                   	push   %edi
801052e4:	56                   	push   %esi
801052e5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052e6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801052e9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052ec:	50                   	push   %eax
801052ed:	6a 00                	push   $0x0
801052ef:	e8 6c fb ff ff       	call   80104e60 <argstr>
801052f4:	83 c4 10             	add    $0x10,%esp
801052f7:	85 c0                	test   %eax,%eax
801052f9:	0f 88 fb 00 00 00    	js     801053fa <sys_link+0x11a>
801052ff:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105302:	83 ec 08             	sub    $0x8,%esp
80105305:	50                   	push   %eax
80105306:	6a 01                	push   $0x1
80105308:	e8 53 fb ff ff       	call   80104e60 <argstr>
8010530d:	83 c4 10             	add    $0x10,%esp
80105310:	85 c0                	test   %eax,%eax
80105312:	0f 88 e2 00 00 00    	js     801053fa <sys_link+0x11a>
  begin_op();
80105318:	e8 c3 d8 ff ff       	call   80102be0 <begin_op>
  if((ip = namei(old)) == 0){
8010531d:	83 ec 0c             	sub    $0xc,%esp
80105320:	ff 75 d4             	pushl  -0x2c(%ebp)
80105323:	e8 e8 cb ff ff       	call   80101f10 <namei>
80105328:	83 c4 10             	add    $0x10,%esp
8010532b:	85 c0                	test   %eax,%eax
8010532d:	89 c3                	mov    %eax,%ebx
8010532f:	0f 84 ea 00 00 00    	je     8010541f <sys_link+0x13f>
  ilock(ip);
80105335:	83 ec 0c             	sub    $0xc,%esp
80105338:	50                   	push   %eax
80105339:	e8 72 c3 ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
8010533e:	83 c4 10             	add    $0x10,%esp
80105341:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105346:	0f 84 bb 00 00 00    	je     80105407 <sys_link+0x127>
  ip->nlink++;
8010534c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105351:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105354:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105357:	53                   	push   %ebx
80105358:	e8 a3 c2 ff ff       	call   80101600 <iupdate>
  iunlock(ip);
8010535d:	89 1c 24             	mov    %ebx,(%esp)
80105360:	e8 2b c4 ff ff       	call   80101790 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105365:	58                   	pop    %eax
80105366:	5a                   	pop    %edx
80105367:	57                   	push   %edi
80105368:	ff 75 d0             	pushl  -0x30(%ebp)
8010536b:	e8 c0 cb ff ff       	call   80101f30 <nameiparent>
80105370:	83 c4 10             	add    $0x10,%esp
80105373:	85 c0                	test   %eax,%eax
80105375:	89 c6                	mov    %eax,%esi
80105377:	74 5b                	je     801053d4 <sys_link+0xf4>
  ilock(dp);
80105379:	83 ec 0c             	sub    $0xc,%esp
8010537c:	50                   	push   %eax
8010537d:	e8 2e c3 ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105382:	83 c4 10             	add    $0x10,%esp
80105385:	8b 03                	mov    (%ebx),%eax
80105387:	39 06                	cmp    %eax,(%esi)
80105389:	75 3d                	jne    801053c8 <sys_link+0xe8>
8010538b:	83 ec 04             	sub    $0x4,%esp
8010538e:	ff 73 04             	pushl  0x4(%ebx)
80105391:	57                   	push   %edi
80105392:	56                   	push   %esi
80105393:	e8 b8 ca ff ff       	call   80101e50 <dirlink>
80105398:	83 c4 10             	add    $0x10,%esp
8010539b:	85 c0                	test   %eax,%eax
8010539d:	78 29                	js     801053c8 <sys_link+0xe8>
  iunlockput(dp);
8010539f:	83 ec 0c             	sub    $0xc,%esp
801053a2:	56                   	push   %esi
801053a3:	e8 98 c5 ff ff       	call   80101940 <iunlockput>
  iput(ip);
801053a8:	89 1c 24             	mov    %ebx,(%esp)
801053ab:	e8 30 c4 ff ff       	call   801017e0 <iput>
  end_op();
801053b0:	e8 9b d8 ff ff       	call   80102c50 <end_op>
  return 0;
801053b5:	83 c4 10             	add    $0x10,%esp
801053b8:	31 c0                	xor    %eax,%eax
}
801053ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053bd:	5b                   	pop    %ebx
801053be:	5e                   	pop    %esi
801053bf:	5f                   	pop    %edi
801053c0:	5d                   	pop    %ebp
801053c1:	c3                   	ret    
801053c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801053c8:	83 ec 0c             	sub    $0xc,%esp
801053cb:	56                   	push   %esi
801053cc:	e8 6f c5 ff ff       	call   80101940 <iunlockput>
    goto bad;
801053d1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801053d4:	83 ec 0c             	sub    $0xc,%esp
801053d7:	53                   	push   %ebx
801053d8:	e8 d3 c2 ff ff       	call   801016b0 <ilock>
  ip->nlink--;
801053dd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053e2:	89 1c 24             	mov    %ebx,(%esp)
801053e5:	e8 16 c2 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
801053ea:	89 1c 24             	mov    %ebx,(%esp)
801053ed:	e8 4e c5 ff ff       	call   80101940 <iunlockput>
  end_op();
801053f2:	e8 59 d8 ff ff       	call   80102c50 <end_op>
  return -1;
801053f7:	83 c4 10             	add    $0x10,%esp
}
801053fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801053fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105402:	5b                   	pop    %ebx
80105403:	5e                   	pop    %esi
80105404:	5f                   	pop    %edi
80105405:	5d                   	pop    %ebp
80105406:	c3                   	ret    
    iunlockput(ip);
80105407:	83 ec 0c             	sub    $0xc,%esp
8010540a:	53                   	push   %ebx
8010540b:	e8 30 c5 ff ff       	call   80101940 <iunlockput>
    end_op();
80105410:	e8 3b d8 ff ff       	call   80102c50 <end_op>
    return -1;
80105415:	83 c4 10             	add    $0x10,%esp
80105418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010541d:	eb 9b                	jmp    801053ba <sys_link+0xda>
    end_op();
8010541f:	e8 2c d8 ff ff       	call   80102c50 <end_op>
    return -1;
80105424:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105429:	eb 8f                	jmp    801053ba <sys_link+0xda>
8010542b:	90                   	nop
8010542c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105430 <sys_unlink>:
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	57                   	push   %edi
80105434:	56                   	push   %esi
80105435:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105436:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105439:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010543c:	50                   	push   %eax
8010543d:	6a 00                	push   $0x0
8010543f:	e8 1c fa ff ff       	call   80104e60 <argstr>
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	85 c0                	test   %eax,%eax
80105449:	0f 88 77 01 00 00    	js     801055c6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010544f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105452:	e8 89 d7 ff ff       	call   80102be0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105457:	83 ec 08             	sub    $0x8,%esp
8010545a:	53                   	push   %ebx
8010545b:	ff 75 c0             	pushl  -0x40(%ebp)
8010545e:	e8 cd ca ff ff       	call   80101f30 <nameiparent>
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	85 c0                	test   %eax,%eax
80105468:	89 c6                	mov    %eax,%esi
8010546a:	0f 84 60 01 00 00    	je     801055d0 <sys_unlink+0x1a0>
  ilock(dp);
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	50                   	push   %eax
80105474:	e8 37 c2 ff ff       	call   801016b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105479:	58                   	pop    %eax
8010547a:	5a                   	pop    %edx
8010547b:	68 20 7e 10 80       	push   $0x80107e20
80105480:	53                   	push   %ebx
80105481:	e8 3a c7 ff ff       	call   80101bc0 <namecmp>
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	85 c0                	test   %eax,%eax
8010548b:	0f 84 03 01 00 00    	je     80105594 <sys_unlink+0x164>
80105491:	83 ec 08             	sub    $0x8,%esp
80105494:	68 1f 7e 10 80       	push   $0x80107e1f
80105499:	53                   	push   %ebx
8010549a:	e8 21 c7 ff ff       	call   80101bc0 <namecmp>
8010549f:	83 c4 10             	add    $0x10,%esp
801054a2:	85 c0                	test   %eax,%eax
801054a4:	0f 84 ea 00 00 00    	je     80105594 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801054aa:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801054ad:	83 ec 04             	sub    $0x4,%esp
801054b0:	50                   	push   %eax
801054b1:	53                   	push   %ebx
801054b2:	56                   	push   %esi
801054b3:	e8 28 c7 ff ff       	call   80101be0 <dirlookup>
801054b8:	83 c4 10             	add    $0x10,%esp
801054bb:	85 c0                	test   %eax,%eax
801054bd:	89 c3                	mov    %eax,%ebx
801054bf:	0f 84 cf 00 00 00    	je     80105594 <sys_unlink+0x164>
  ilock(ip);
801054c5:	83 ec 0c             	sub    $0xc,%esp
801054c8:	50                   	push   %eax
801054c9:	e8 e2 c1 ff ff       	call   801016b0 <ilock>
  if(ip->nlink < 1)
801054ce:	83 c4 10             	add    $0x10,%esp
801054d1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801054d6:	0f 8e 10 01 00 00    	jle    801055ec <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801054dc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054e1:	74 6d                	je     80105550 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801054e3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054e6:	83 ec 04             	sub    $0x4,%esp
801054e9:	6a 10                	push   $0x10
801054eb:	6a 00                	push   $0x0
801054ed:	50                   	push   %eax
801054ee:	e8 bd f5 ff ff       	call   80104ab0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054f3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054f6:	6a 10                	push   $0x10
801054f8:	ff 75 c4             	pushl  -0x3c(%ebp)
801054fb:	50                   	push   %eax
801054fc:	56                   	push   %esi
801054fd:	e8 8e c5 ff ff       	call   80101a90 <writei>
80105502:	83 c4 20             	add    $0x20,%esp
80105505:	83 f8 10             	cmp    $0x10,%eax
80105508:	0f 85 eb 00 00 00    	jne    801055f9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010550e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105513:	0f 84 97 00 00 00    	je     801055b0 <sys_unlink+0x180>
  iunlockput(dp);
80105519:	83 ec 0c             	sub    $0xc,%esp
8010551c:	56                   	push   %esi
8010551d:	e8 1e c4 ff ff       	call   80101940 <iunlockput>
  ip->nlink--;
80105522:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105527:	89 1c 24             	mov    %ebx,(%esp)
8010552a:	e8 d1 c0 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
8010552f:	89 1c 24             	mov    %ebx,(%esp)
80105532:	e8 09 c4 ff ff       	call   80101940 <iunlockput>
  end_op();
80105537:	e8 14 d7 ff ff       	call   80102c50 <end_op>
  return 0;
8010553c:	83 c4 10             	add    $0x10,%esp
8010553f:	31 c0                	xor    %eax,%eax
}
80105541:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105544:	5b                   	pop    %ebx
80105545:	5e                   	pop    %esi
80105546:	5f                   	pop    %edi
80105547:	5d                   	pop    %ebp
80105548:	c3                   	ret    
80105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105550:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105554:	76 8d                	jbe    801054e3 <sys_unlink+0xb3>
80105556:	bf 20 00 00 00       	mov    $0x20,%edi
8010555b:	eb 0f                	jmp    8010556c <sys_unlink+0x13c>
8010555d:	8d 76 00             	lea    0x0(%esi),%esi
80105560:	83 c7 10             	add    $0x10,%edi
80105563:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105566:	0f 83 77 ff ff ff    	jae    801054e3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010556c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010556f:	6a 10                	push   $0x10
80105571:	57                   	push   %edi
80105572:	50                   	push   %eax
80105573:	53                   	push   %ebx
80105574:	e8 17 c4 ff ff       	call   80101990 <readi>
80105579:	83 c4 10             	add    $0x10,%esp
8010557c:	83 f8 10             	cmp    $0x10,%eax
8010557f:	75 5e                	jne    801055df <sys_unlink+0x1af>
    if(de.inum != 0)
80105581:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105586:	74 d8                	je     80105560 <sys_unlink+0x130>
    iunlockput(ip);
80105588:	83 ec 0c             	sub    $0xc,%esp
8010558b:	53                   	push   %ebx
8010558c:	e8 af c3 ff ff       	call   80101940 <iunlockput>
    goto bad;
80105591:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105594:	83 ec 0c             	sub    $0xc,%esp
80105597:	56                   	push   %esi
80105598:	e8 a3 c3 ff ff       	call   80101940 <iunlockput>
  end_op();
8010559d:	e8 ae d6 ff ff       	call   80102c50 <end_op>
  return -1;
801055a2:	83 c4 10             	add    $0x10,%esp
801055a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055aa:	eb 95                	jmp    80105541 <sys_unlink+0x111>
801055ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801055b0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801055b5:	83 ec 0c             	sub    $0xc,%esp
801055b8:	56                   	push   %esi
801055b9:	e8 42 c0 ff ff       	call   80101600 <iupdate>
801055be:	83 c4 10             	add    $0x10,%esp
801055c1:	e9 53 ff ff ff       	jmp    80105519 <sys_unlink+0xe9>
    return -1;
801055c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055cb:	e9 71 ff ff ff       	jmp    80105541 <sys_unlink+0x111>
    end_op();
801055d0:	e8 7b d6 ff ff       	call   80102c50 <end_op>
    return -1;
801055d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055da:	e9 62 ff ff ff       	jmp    80105541 <sys_unlink+0x111>
      panic("isdirempty: readi");
801055df:	83 ec 0c             	sub    $0xc,%esp
801055e2:	68 44 7e 10 80       	push   $0x80107e44
801055e7:	e8 a4 ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801055ec:	83 ec 0c             	sub    $0xc,%esp
801055ef:	68 32 7e 10 80       	push   $0x80107e32
801055f4:	e8 97 ad ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801055f9:	83 ec 0c             	sub    $0xc,%esp
801055fc:	68 56 7e 10 80       	push   $0x80107e56
80105601:	e8 8a ad ff ff       	call   80100390 <panic>
80105606:	8d 76 00             	lea    0x0(%esi),%esi
80105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105610 <sys_open>:

int
sys_open(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
80105615:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105616:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105619:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010561c:	50                   	push   %eax
8010561d:	6a 00                	push   $0x0
8010561f:	e8 3c f8 ff ff       	call   80104e60 <argstr>
80105624:	83 c4 10             	add    $0x10,%esp
80105627:	85 c0                	test   %eax,%eax
80105629:	0f 88 1d 01 00 00    	js     8010574c <sys_open+0x13c>
8010562f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105632:	83 ec 08             	sub    $0x8,%esp
80105635:	50                   	push   %eax
80105636:	6a 01                	push   $0x1
80105638:	e8 73 f7 ff ff       	call   80104db0 <argint>
8010563d:	83 c4 10             	add    $0x10,%esp
80105640:	85 c0                	test   %eax,%eax
80105642:	0f 88 04 01 00 00    	js     8010574c <sys_open+0x13c>
    return -1;

  begin_op();
80105648:	e8 93 d5 ff ff       	call   80102be0 <begin_op>

  if(omode & O_CREATE){
8010564d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105651:	0f 85 a9 00 00 00    	jne    80105700 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105657:	83 ec 0c             	sub    $0xc,%esp
8010565a:	ff 75 e0             	pushl  -0x20(%ebp)
8010565d:	e8 ae c8 ff ff       	call   80101f10 <namei>
80105662:	83 c4 10             	add    $0x10,%esp
80105665:	85 c0                	test   %eax,%eax
80105667:	89 c6                	mov    %eax,%esi
80105669:	0f 84 b2 00 00 00    	je     80105721 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010566f:	83 ec 0c             	sub    $0xc,%esp
80105672:	50                   	push   %eax
80105673:	e8 38 c0 ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105678:	83 c4 10             	add    $0x10,%esp
8010567b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105680:	0f 84 aa 00 00 00    	je     80105730 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105686:	e8 25 b7 ff ff       	call   80100db0 <filealloc>
8010568b:	85 c0                	test   %eax,%eax
8010568d:	89 c7                	mov    %eax,%edi
8010568f:	0f 84 a6 00 00 00    	je     8010573b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105695:	e8 86 e2 ff ff       	call   80103920 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010569a:	31 db                	xor    %ebx,%ebx
8010569c:	eb 0e                	jmp    801056ac <sys_open+0x9c>
8010569e:	66 90                	xchg   %ax,%ax
801056a0:	83 c3 01             	add    $0x1,%ebx
801056a3:	83 fb 10             	cmp    $0x10,%ebx
801056a6:	0f 84 ac 00 00 00    	je     80105758 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801056ac:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
801056b0:	85 d2                	test   %edx,%edx
801056b2:	75 ec                	jne    801056a0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056b4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801056b7:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
801056bb:	56                   	push   %esi
801056bc:	e8 cf c0 ff ff       	call   80101790 <iunlock>
  end_op();
801056c1:	e8 8a d5 ff ff       	call   80102c50 <end_op>

  f->type = FD_INODE;
801056c6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801056cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056cf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801056d2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801056d5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801056dc:	89 d0                	mov    %edx,%eax
801056de:	f7 d0                	not    %eax
801056e0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056e3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801056e6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056e9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801056ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056f0:	89 d8                	mov    %ebx,%eax
801056f2:	5b                   	pop    %ebx
801056f3:	5e                   	pop    %esi
801056f4:	5f                   	pop    %edi
801056f5:	5d                   	pop    %ebp
801056f6:	c3                   	ret    
801056f7:	89 f6                	mov    %esi,%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105706:	31 c9                	xor    %ecx,%ecx
80105708:	6a 00                	push   $0x0
8010570a:	ba 02 00 00 00       	mov    $0x2,%edx
8010570f:	e8 ec f7 ff ff       	call   80104f00 <create>
    if(ip == 0){
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105719:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010571b:	0f 85 65 ff ff ff    	jne    80105686 <sys_open+0x76>
      end_op();
80105721:	e8 2a d5 ff ff       	call   80102c50 <end_op>
      return -1;
80105726:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010572b:	eb c0                	jmp    801056ed <sys_open+0xdd>
8010572d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105730:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105733:	85 c9                	test   %ecx,%ecx
80105735:	0f 84 4b ff ff ff    	je     80105686 <sys_open+0x76>
    iunlockput(ip);
8010573b:	83 ec 0c             	sub    $0xc,%esp
8010573e:	56                   	push   %esi
8010573f:	e8 fc c1 ff ff       	call   80101940 <iunlockput>
    end_op();
80105744:	e8 07 d5 ff ff       	call   80102c50 <end_op>
    return -1;
80105749:	83 c4 10             	add    $0x10,%esp
8010574c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105751:	eb 9a                	jmp    801056ed <sys_open+0xdd>
80105753:	90                   	nop
80105754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	57                   	push   %edi
8010575c:	e8 0f b7 ff ff       	call   80100e70 <fileclose>
80105761:	83 c4 10             	add    $0x10,%esp
80105764:	eb d5                	jmp    8010573b <sys_open+0x12b>
80105766:	8d 76 00             	lea    0x0(%esi),%esi
80105769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105770 <sys_mkdir>:

int
sys_mkdir(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105776:	e8 65 d4 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010577b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010577e:	83 ec 08             	sub    $0x8,%esp
80105781:	50                   	push   %eax
80105782:	6a 00                	push   $0x0
80105784:	e8 d7 f6 ff ff       	call   80104e60 <argstr>
80105789:	83 c4 10             	add    $0x10,%esp
8010578c:	85 c0                	test   %eax,%eax
8010578e:	78 30                	js     801057c0 <sys_mkdir+0x50>
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105796:	31 c9                	xor    %ecx,%ecx
80105798:	6a 00                	push   $0x0
8010579a:	ba 01 00 00 00       	mov    $0x1,%edx
8010579f:	e8 5c f7 ff ff       	call   80104f00 <create>
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	85 c0                	test   %eax,%eax
801057a9:	74 15                	je     801057c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057ab:	83 ec 0c             	sub    $0xc,%esp
801057ae:	50                   	push   %eax
801057af:	e8 8c c1 ff ff       	call   80101940 <iunlockput>
  end_op();
801057b4:	e8 97 d4 ff ff       	call   80102c50 <end_op>
  return 0;
801057b9:	83 c4 10             	add    $0x10,%esp
801057bc:	31 c0                	xor    %eax,%eax
}
801057be:	c9                   	leave  
801057bf:	c3                   	ret    
    end_op();
801057c0:	e8 8b d4 ff ff       	call   80102c50 <end_op>
    return -1;
801057c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ca:	c9                   	leave  
801057cb:	c3                   	ret    
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057d0 <sys_mknod>:

int
sys_mknod(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801057d6:	e8 05 d4 ff ff       	call   80102be0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801057db:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057de:	83 ec 08             	sub    $0x8,%esp
801057e1:	50                   	push   %eax
801057e2:	6a 00                	push   $0x0
801057e4:	e8 77 f6 ff ff       	call   80104e60 <argstr>
801057e9:	83 c4 10             	add    $0x10,%esp
801057ec:	85 c0                	test   %eax,%eax
801057ee:	78 60                	js     80105850 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801057f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057f3:	83 ec 08             	sub    $0x8,%esp
801057f6:	50                   	push   %eax
801057f7:	6a 01                	push   $0x1
801057f9:	e8 b2 f5 ff ff       	call   80104db0 <argint>
  if((argstr(0, &path)) < 0 ||
801057fe:	83 c4 10             	add    $0x10,%esp
80105801:	85 c0                	test   %eax,%eax
80105803:	78 4b                	js     80105850 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105805:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105808:	83 ec 08             	sub    $0x8,%esp
8010580b:	50                   	push   %eax
8010580c:	6a 02                	push   $0x2
8010580e:	e8 9d f5 ff ff       	call   80104db0 <argint>
     argint(1, &major) < 0 ||
80105813:	83 c4 10             	add    $0x10,%esp
80105816:	85 c0                	test   %eax,%eax
80105818:	78 36                	js     80105850 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010581a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010581e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105821:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105825:	ba 03 00 00 00       	mov    $0x3,%edx
8010582a:	50                   	push   %eax
8010582b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010582e:	e8 cd f6 ff ff       	call   80104f00 <create>
80105833:	83 c4 10             	add    $0x10,%esp
80105836:	85 c0                	test   %eax,%eax
80105838:	74 16                	je     80105850 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010583a:	83 ec 0c             	sub    $0xc,%esp
8010583d:	50                   	push   %eax
8010583e:	e8 fd c0 ff ff       	call   80101940 <iunlockput>
  end_op();
80105843:	e8 08 d4 ff ff       	call   80102c50 <end_op>
  return 0;
80105848:	83 c4 10             	add    $0x10,%esp
8010584b:	31 c0                	xor    %eax,%eax
}
8010584d:	c9                   	leave  
8010584e:	c3                   	ret    
8010584f:	90                   	nop
    end_op();
80105850:	e8 fb d3 ff ff       	call   80102c50 <end_op>
    return -1;
80105855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010585a:	c9                   	leave  
8010585b:	c3                   	ret    
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105860 <sys_chdir>:

int
sys_chdir(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	56                   	push   %esi
80105864:	53                   	push   %ebx
80105865:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105868:	e8 b3 e0 ff ff       	call   80103920 <myproc>
8010586d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010586f:	e8 6c d3 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105874:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105877:	83 ec 08             	sub    $0x8,%esp
8010587a:	50                   	push   %eax
8010587b:	6a 00                	push   $0x0
8010587d:	e8 de f5 ff ff       	call   80104e60 <argstr>
80105882:	83 c4 10             	add    $0x10,%esp
80105885:	85 c0                	test   %eax,%eax
80105887:	78 77                	js     80105900 <sys_chdir+0xa0>
80105889:	83 ec 0c             	sub    $0xc,%esp
8010588c:	ff 75 f4             	pushl  -0xc(%ebp)
8010588f:	e8 7c c6 ff ff       	call   80101f10 <namei>
80105894:	83 c4 10             	add    $0x10,%esp
80105897:	85 c0                	test   %eax,%eax
80105899:	89 c3                	mov    %eax,%ebx
8010589b:	74 63                	je     80105900 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010589d:	83 ec 0c             	sub    $0xc,%esp
801058a0:	50                   	push   %eax
801058a1:	e8 0a be ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
801058a6:	83 c4 10             	add    $0x10,%esp
801058a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058ae:	75 30                	jne    801058e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058b0:	83 ec 0c             	sub    $0xc,%esp
801058b3:	53                   	push   %ebx
801058b4:	e8 d7 be ff ff       	call   80101790 <iunlock>
  iput(curproc->cwd);
801058b9:	58                   	pop    %eax
801058ba:	ff 76 6c             	pushl  0x6c(%esi)
801058bd:	e8 1e bf ff ff       	call   801017e0 <iput>
  end_op();
801058c2:	e8 89 d3 ff ff       	call   80102c50 <end_op>
  curproc->cwd = ip;
801058c7:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
801058ca:	83 c4 10             	add    $0x10,%esp
801058cd:	31 c0                	xor    %eax,%eax
}
801058cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058d2:	5b                   	pop    %ebx
801058d3:	5e                   	pop    %esi
801058d4:	5d                   	pop    %ebp
801058d5:	c3                   	ret    
801058d6:	8d 76 00             	lea    0x0(%esi),%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	53                   	push   %ebx
801058e4:	e8 57 c0 ff ff       	call   80101940 <iunlockput>
    end_op();
801058e9:	e8 62 d3 ff ff       	call   80102c50 <end_op>
    return -1;
801058ee:	83 c4 10             	add    $0x10,%esp
801058f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f6:	eb d7                	jmp    801058cf <sys_chdir+0x6f>
801058f8:	90                   	nop
801058f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105900:	e8 4b d3 ff ff       	call   80102c50 <end_op>
    return -1;
80105905:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010590a:	eb c3                	jmp    801058cf <sys_chdir+0x6f>
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_exec>:

int
sys_exec(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	57                   	push   %edi
80105914:	56                   	push   %esi
80105915:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105916:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010591c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105922:	50                   	push   %eax
80105923:	6a 00                	push   $0x0
80105925:	e8 36 f5 ff ff       	call   80104e60 <argstr>
8010592a:	83 c4 10             	add    $0x10,%esp
8010592d:	85 c0                	test   %eax,%eax
8010592f:	0f 88 87 00 00 00    	js     801059bc <sys_exec+0xac>
80105935:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010593b:	83 ec 08             	sub    $0x8,%esp
8010593e:	50                   	push   %eax
8010593f:	6a 01                	push   $0x1
80105941:	e8 6a f4 ff ff       	call   80104db0 <argint>
80105946:	83 c4 10             	add    $0x10,%esp
80105949:	85 c0                	test   %eax,%eax
8010594b:	78 6f                	js     801059bc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010594d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105953:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105956:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105958:	68 80 00 00 00       	push   $0x80
8010595d:	6a 00                	push   $0x0
8010595f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105965:	50                   	push   %eax
80105966:	e8 45 f1 ff ff       	call   80104ab0 <memset>
8010596b:	83 c4 10             	add    $0x10,%esp
8010596e:	eb 2c                	jmp    8010599c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105970:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105976:	85 c0                	test   %eax,%eax
80105978:	74 56                	je     801059d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010597a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105980:	83 ec 08             	sub    $0x8,%esp
80105983:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105986:	52                   	push   %edx
80105987:	50                   	push   %eax
80105988:	e8 b3 f3 ff ff       	call   80104d40 <fetchstr>
8010598d:	83 c4 10             	add    $0x10,%esp
80105990:	85 c0                	test   %eax,%eax
80105992:	78 28                	js     801059bc <sys_exec+0xac>
  for(i=0;; i++){
80105994:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105997:	83 fb 20             	cmp    $0x20,%ebx
8010599a:	74 20                	je     801059bc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010599c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801059a2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801059a9:	83 ec 08             	sub    $0x8,%esp
801059ac:	57                   	push   %edi
801059ad:	01 f0                	add    %esi,%eax
801059af:	50                   	push   %eax
801059b0:	e8 4b f3 ff ff       	call   80104d00 <fetchint>
801059b5:	83 c4 10             	add    $0x10,%esp
801059b8:	85 c0                	test   %eax,%eax
801059ba:	79 b4                	jns    80105970 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801059bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801059bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c4:	5b                   	pop    %ebx
801059c5:	5e                   	pop    %esi
801059c6:	5f                   	pop    %edi
801059c7:	5d                   	pop    %ebp
801059c8:	c3                   	ret    
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801059d0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801059d6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801059d9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801059e0:	00 00 00 00 
  return exec(path, argv);
801059e4:	50                   	push   %eax
801059e5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801059eb:	e8 20 b0 ff ff       	call   80100a10 <exec>
801059f0:	83 c4 10             	add    $0x10,%esp
}
801059f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059f6:	5b                   	pop    %ebx
801059f7:	5e                   	pop    %esi
801059f8:	5f                   	pop    %edi
801059f9:	5d                   	pop    %ebp
801059fa:	c3                   	ret    
801059fb:	90                   	nop
801059fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a00 <sys_pipe>:

int
sys_pipe(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	57                   	push   %edi
80105a04:	56                   	push   %esi
80105a05:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a06:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105a09:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a0c:	6a 08                	push   $0x8
80105a0e:	50                   	push   %eax
80105a0f:	6a 00                	push   $0x0
80105a11:	e8 ea f3 ff ff       	call   80104e00 <argptr>
80105a16:	83 c4 10             	add    $0x10,%esp
80105a19:	85 c0                	test   %eax,%eax
80105a1b:	0f 88 ae 00 00 00    	js     80105acf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105a21:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a24:	83 ec 08             	sub    $0x8,%esp
80105a27:	50                   	push   %eax
80105a28:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a2b:	50                   	push   %eax
80105a2c:	e8 4f d8 ff ff       	call   80103280 <pipealloc>
80105a31:	83 c4 10             	add    $0x10,%esp
80105a34:	85 c0                	test   %eax,%eax
80105a36:	0f 88 93 00 00 00    	js     80105acf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a3c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105a3f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a41:	e8 da de ff ff       	call   80103920 <myproc>
80105a46:	eb 10                	jmp    80105a58 <sys_pipe+0x58>
80105a48:	90                   	nop
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a50:	83 c3 01             	add    $0x1,%ebx
80105a53:	83 fb 10             	cmp    $0x10,%ebx
80105a56:	74 60                	je     80105ab8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105a58:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105a5c:	85 f6                	test   %esi,%esi
80105a5e:	75 f0                	jne    80105a50 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105a60:	8d 73 08             	lea    0x8(%ebx),%esi
80105a63:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a6a:	e8 b1 de ff ff       	call   80103920 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a6f:	31 d2                	xor    %edx,%edx
80105a71:	eb 0d                	jmp    80105a80 <sys_pipe+0x80>
80105a73:	90                   	nop
80105a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a78:	83 c2 01             	add    $0x1,%edx
80105a7b:	83 fa 10             	cmp    $0x10,%edx
80105a7e:	74 28                	je     80105aa8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105a80:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80105a84:	85 c9                	test   %ecx,%ecx
80105a86:	75 f0                	jne    80105a78 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105a88:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105a8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a8f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a91:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a94:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a97:	31 c0                	xor    %eax,%eax
}
80105a99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a9c:	5b                   	pop    %ebx
80105a9d:	5e                   	pop    %esi
80105a9e:	5f                   	pop    %edi
80105a9f:	5d                   	pop    %ebp
80105aa0:	c3                   	ret    
80105aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105aa8:	e8 73 de ff ff       	call   80103920 <myproc>
80105aad:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105ab4:	00 
80105ab5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
80105abb:	ff 75 e0             	pushl  -0x20(%ebp)
80105abe:	e8 ad b3 ff ff       	call   80100e70 <fileclose>
    fileclose(wf);
80105ac3:	58                   	pop    %eax
80105ac4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ac7:	e8 a4 b3 ff ff       	call   80100e70 <fileclose>
    return -1;
80105acc:	83 c4 10             	add    $0x10,%esp
80105acf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad4:	eb c3                	jmp    80105a99 <sys_pipe+0x99>
80105ad6:	66 90                	xchg   %ax,%ax
80105ad8:	66 90                	xchg   %ax,%ax
80105ada:	66 90                	xchg   %ax,%ax
80105adc:	66 90                	xchg   %ax,%ax
80105ade:	66 90                	xchg   %ax,%ax

80105ae0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105ae3:	5d                   	pop    %ebp
  return fork();
80105ae4:	e9 57 e0 ff ff       	jmp    80103b40 <fork>
80105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105af0 <sys_exit>:

int
sys_exit(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105af6:	e8 95 e3 ff ff       	call   80103e90 <exit>
  return 0;  // not reached
}
80105afb:	31 c0                	xor    %eax,%eax
80105afd:	c9                   	leave  
80105afe:	c3                   	ret    
80105aff:	90                   	nop

80105b00 <sys_wait>:

int
sys_wait(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105b03:	5d                   	pop    %ebp
  return wait();
80105b04:	e9 97 e4 ff ff       	jmp    80103fa0 <wait>
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b10 <sys_kill>:

int
sys_kill(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int signum;
  if(argint(0, &pid) < 0)
80105b16:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b19:	50                   	push   %eax
80105b1a:	6a 00                	push   $0x0
80105b1c:	e8 8f f2 ff ff       	call   80104db0 <argint>
80105b21:	83 c4 10             	add    $0x10,%esp
80105b24:	85 c0                	test   %eax,%eax
80105b26:	78 38                	js     80105b60 <sys_kill+0x50>
    return -1;
  if(argint(1, &signum) < 0)
80105b28:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b2b:	83 ec 08             	sub    $0x8,%esp
80105b2e:	50                   	push   %eax
80105b2f:	6a 01                	push   $0x1
80105b31:	e8 7a f2 ff ff       	call   80104db0 <argint>
80105b36:	83 c4 10             	add    $0x10,%esp
80105b39:	85 c0                	test   %eax,%eax
80105b3b:	78 23                	js     80105b60 <sys_kill+0x50>
    return -1;
  if(signum<1||signum>32)
80105b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b40:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b43:	83 fa 1f             	cmp    $0x1f,%edx
80105b46:	77 18                	ja     80105b60 <sys_kill+0x50>
    return -1;
  return kill(pid, signum);
80105b48:	83 ec 08             	sub    $0x8,%esp
80105b4b:	50                   	push   %eax
80105b4c:	ff 75 f0             	pushl  -0x10(%ebp)
80105b4f:	e8 fc e6 ff ff       	call   80104250 <kill>
80105b54:	83 c4 10             	add    $0x10,%esp
}
80105b57:	c9                   	leave  
80105b58:	c3                   	ret    
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b65:	c9                   	leave  
80105b66:	c3                   	ret    
80105b67:	89 f6                	mov    %esi,%esi
80105b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b70 <sys_getpid>:

int
sys_getpid(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b76:	e8 a5 dd ff ff       	call   80103920 <myproc>
80105b7b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105b7e:	c9                   	leave  
80105b7f:	c3                   	ret    

80105b80 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b84:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b87:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b8a:	50                   	push   %eax
80105b8b:	6a 00                	push   $0x0
80105b8d:	e8 1e f2 ff ff       	call   80104db0 <argint>
80105b92:	83 c4 10             	add    $0x10,%esp
80105b95:	85 c0                	test   %eax,%eax
80105b97:	78 27                	js     80105bc0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105b99:	e8 82 dd ff ff       	call   80103920 <myproc>
  if(growproc(n) < 0)
80105b9e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ba1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ba3:	ff 75 f4             	pushl  -0xc(%ebp)
80105ba6:	e8 15 df ff ff       	call   80103ac0 <growproc>
80105bab:	83 c4 10             	add    $0x10,%esp
80105bae:	85 c0                	test   %eax,%eax
80105bb0:	78 0e                	js     80105bc0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105bb2:	89 d8                	mov    %ebx,%eax
80105bb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bb7:	c9                   	leave  
80105bb8:	c3                   	ret    
80105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105bc0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105bc5:	eb eb                	jmp    80105bb2 <sys_sbrk+0x32>
80105bc7:	89 f6                	mov    %esi,%esi
80105bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bd0 <sys_sleep>:

int
sys_sleep(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105bd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105bd7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bda:	50                   	push   %eax
80105bdb:	6a 00                	push   $0x0
80105bdd:	e8 ce f1 ff ff       	call   80104db0 <argint>
80105be2:	83 c4 10             	add    $0x10,%esp
80105be5:	85 c0                	test   %eax,%eax
80105be7:	0f 88 8a 00 00 00    	js     80105c77 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105bed:	83 ec 0c             	sub    $0xc,%esp
80105bf0:	68 60 81 11 80       	push   $0x80118160
80105bf5:	e8 a6 ed ff ff       	call   801049a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bfd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105c00:	8b 1d a0 89 11 80    	mov    0x801189a0,%ebx
  while(ticks - ticks0 < n){
80105c06:	85 d2                	test   %edx,%edx
80105c08:	75 27                	jne    80105c31 <sys_sleep+0x61>
80105c0a:	eb 54                	jmp    80105c60 <sys_sleep+0x90>
80105c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c10:	83 ec 08             	sub    $0x8,%esp
80105c13:	68 60 81 11 80       	push   $0x80118160
80105c18:	68 a0 89 11 80       	push   $0x801189a0
80105c1d:	e8 5e e5 ff ff       	call   80104180 <sleep>
  while(ticks - ticks0 < n){
80105c22:	a1 a0 89 11 80       	mov    0x801189a0,%eax
80105c27:	83 c4 10             	add    $0x10,%esp
80105c2a:	29 d8                	sub    %ebx,%eax
80105c2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c2f:	73 2f                	jae    80105c60 <sys_sleep+0x90>
    if(myproc()->killed){
80105c31:	e8 ea dc ff ff       	call   80103920 <myproc>
80105c36:	8b 40 24             	mov    0x24(%eax),%eax
80105c39:	85 c0                	test   %eax,%eax
80105c3b:	74 d3                	je     80105c10 <sys_sleep+0x40>
      release(&tickslock);
80105c3d:	83 ec 0c             	sub    $0xc,%esp
80105c40:	68 60 81 11 80       	push   $0x80118160
80105c45:	e8 16 ee ff ff       	call   80104a60 <release>
      return -1;
80105c4a:	83 c4 10             	add    $0x10,%esp
80105c4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105c52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c55:	c9                   	leave  
80105c56:	c3                   	ret    
80105c57:	89 f6                	mov    %esi,%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105c60:	83 ec 0c             	sub    $0xc,%esp
80105c63:	68 60 81 11 80       	push   $0x80118160
80105c68:	e8 f3 ed ff ff       	call   80104a60 <release>
  return 0;
80105c6d:	83 c4 10             	add    $0x10,%esp
80105c70:	31 c0                	xor    %eax,%eax
}
80105c72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c75:	c9                   	leave  
80105c76:	c3                   	ret    
    return -1;
80105c77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c7c:	eb f4                	jmp    80105c72 <sys_sleep+0xa2>
80105c7e:	66 90                	xchg   %ax,%ax

80105c80 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	53                   	push   %ebx
80105c84:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c87:	68 60 81 11 80       	push   $0x80118160
80105c8c:	e8 0f ed ff ff       	call   801049a0 <acquire>
  xticks = ticks;
80105c91:	8b 1d a0 89 11 80    	mov    0x801189a0,%ebx
  release(&tickslock);
80105c97:	c7 04 24 60 81 11 80 	movl   $0x80118160,(%esp)
80105c9e:	e8 bd ed ff ff       	call   80104a60 <release>
  return xticks;
}
80105ca3:	89 d8                	mov    %ebx,%eax
80105ca5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ca8:	c9                   	leave  
80105ca9:	c3                   	ret    
80105caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cb0 <sys_sigprocmask>:
uint sys_sigprocmask(void){
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	83 ec 20             	sub    $0x20,%esp
  int sigmask;
  if(argint(0, &sigmask) < 0)
80105cb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cb9:	50                   	push   %eax
80105cba:	6a 00                	push   $0x0
80105cbc:	e8 ef f0 ff ff       	call   80104db0 <argint>
80105cc1:	83 c4 10             	add    $0x10,%esp
80105cc4:	85 c0                	test   %eax,%eax
80105cc6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80105ccb:	78 10                	js     80105cdd <sys_sigprocmask+0x2d>
    return -1;
  return sigprocmask((uint) sigmask);
80105ccd:	83 ec 0c             	sub    $0xc,%esp
80105cd0:	ff 75 f4             	pushl  -0xc(%ebp)
80105cd3:	e8 18 e8 ff ff       	call   801044f0 <sigprocmask>
80105cd8:	83 c4 10             	add    $0x10,%esp
80105cdb:	89 c2                	mov    %eax,%edx
}
80105cdd:	89 d0                	mov    %edx,%eax
80105cdf:	c9                   	leave  
80105ce0:	c3                   	ret    
80105ce1:	eb 0d                	jmp    80105cf0 <sys_sigaction>
80105ce3:	90                   	nop
80105ce4:	90                   	nop
80105ce5:	90                   	nop
80105ce6:	90                   	nop
80105ce7:	90                   	nop
80105ce8:	90                   	nop
80105ce9:	90                   	nop
80105cea:	90                   	nop
80105ceb:	90                   	nop
80105cec:	90                   	nop
80105ced:	90                   	nop
80105cee:	90                   	nop
80105cef:	90                   	nop

80105cf0 <sys_sigaction>:

int sys_sigaction(void){
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	83 ec 20             	sub    $0x20,%esp
    int signum;
    char* act;
    char* oldact;
    if(argint(0, &signum) < 0)
80105cf6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105cf9:	50                   	push   %eax
80105cfa:	6a 00                	push   $0x0
80105cfc:	e8 af f0 ff ff       	call   80104db0 <argint>
80105d01:	83 c4 10             	add    $0x10,%esp
80105d04:	85 c0                	test   %eax,%eax
80105d06:	78 48                	js     80105d50 <sys_sigaction+0x60>
      return -1;
    if(argptr(1,&act,sizeof(struct sigaction))<0)
80105d08:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d0b:	83 ec 04             	sub    $0x4,%esp
80105d0e:	6a 08                	push   $0x8
80105d10:	50                   	push   %eax
80105d11:	6a 01                	push   $0x1
80105d13:	e8 e8 f0 ff ff       	call   80104e00 <argptr>
80105d18:	83 c4 10             	add    $0x10,%esp
80105d1b:	85 c0                	test   %eax,%eax
80105d1d:	78 31                	js     80105d50 <sys_sigaction+0x60>
      return -1;
    if(argptr(2,&oldact,sizeof(struct sigaction))<0)
80105d1f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d22:	83 ec 04             	sub    $0x4,%esp
80105d25:	6a 08                	push   $0x8
80105d27:	50                   	push   %eax
80105d28:	6a 02                	push   $0x2
80105d2a:	e8 d1 f0 ff ff       	call   80104e00 <argptr>
80105d2f:	83 c4 10             	add    $0x10,%esp
80105d32:	85 c0                	test   %eax,%eax
80105d34:	78 1a                	js     80105d50 <sys_sigaction+0x60>
      return -1;
    return sigaction(signum, (const struct sigaction*)act, (struct sigaction*)oldact);
80105d36:	83 ec 04             	sub    $0x4,%esp
80105d39:	ff 75 f4             	pushl  -0xc(%ebp)
80105d3c:	ff 75 f0             	pushl  -0x10(%ebp)
80105d3f:	ff 75 ec             	pushl  -0x14(%ebp)
80105d42:	e8 c9 e6 ff ff       	call   80104410 <sigaction>
80105d47:	83 c4 10             	add    $0x10,%esp
}
80105d4a:	c9                   	leave  
80105d4b:	c3                   	ret    
80105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80105d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d55:	c9                   	leave  
80105d56:	c3                   	ret    
80105d57:	89 f6                	mov    %esi,%esi
80105d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d60 <sys_sigret>:

int sys_sigret(void){
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 08             	sub    $0x8,%esp
  sigret();
80105d66:	e8 25 e7 ff ff       	call   80104490 <sigret>
  return 0;
80105d6b:	31 c0                	xor    %eax,%eax
80105d6d:	c9                   	leave  
80105d6e:	c3                   	ret    

80105d6f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d6f:	1e                   	push   %ds
  pushl %es
80105d70:	06                   	push   %es
  pushl %fs
80105d71:	0f a0                	push   %fs
  pushl %gs
80105d73:	0f a8                	push   %gs
  pushal
80105d75:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d76:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d7a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d7c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d7e:	54                   	push   %esp
  call trap
80105d7f:	e8 cc 00 00 00       	call   80105e50 <trap>
  addl $4, %esp
80105d84:	83 c4 04             	add    $0x4,%esp

80105d87 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  pushl %esp
80105d87:	54                   	push   %esp
  call checkS # this is to check for the pending signals (and of course handle them if needed)
80105d88:	e8 b3 e7 ff ff       	call   80104540 <checkS>
  addl $4, %esp
80105d8d:	83 c4 04             	add    $0x4,%esp
  popal
80105d90:	61                   	popa   
  popl %gs
80105d91:	0f a9                	pop    %gs
  popl %fs
80105d93:	0f a1                	pop    %fs
  popl %es
80105d95:	07                   	pop    %es
  popl %ds
80105d96:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d97:	83 c4 08             	add    $0x8,%esp
  iret
80105d9a:	cf                   	iret   
80105d9b:	66 90                	xchg   %ax,%ax
80105d9d:	66 90                	xchg   %ax,%ax
80105d9f:	90                   	nop

80105da0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105da0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105da1:	31 c0                	xor    %eax,%eax
{
80105da3:	89 e5                	mov    %esp,%ebp
80105da5:	83 ec 08             	sub    $0x8,%esp
80105da8:	90                   	nop
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105db0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105db7:	c7 04 c5 a2 81 11 80 	movl   $0x8e000008,-0x7fee7e5e(,%eax,8)
80105dbe:	08 00 00 8e 
80105dc2:	66 89 14 c5 a0 81 11 	mov    %dx,-0x7fee7e60(,%eax,8)
80105dc9:	80 
80105dca:	c1 ea 10             	shr    $0x10,%edx
80105dcd:	66 89 14 c5 a6 81 11 	mov    %dx,-0x7fee7e5a(,%eax,8)
80105dd4:	80 
  for(i = 0; i < 256; i++)
80105dd5:	83 c0 01             	add    $0x1,%eax
80105dd8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105ddd:	75 d1                	jne    80105db0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ddf:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105de4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105de7:	c7 05 a2 83 11 80 08 	movl   $0xef000008,0x801183a2
80105dee:	00 00 ef 
  initlock(&tickslock, "time");
80105df1:	68 65 7e 10 80       	push   $0x80107e65
80105df6:	68 60 81 11 80       	push   $0x80118160
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dfb:	66 a3 a0 83 11 80    	mov    %ax,0x801183a0
80105e01:	c1 e8 10             	shr    $0x10,%eax
80105e04:	66 a3 a6 83 11 80    	mov    %ax,0x801183a6
  initlock(&tickslock, "time");
80105e0a:	e8 51 ea ff ff       	call   80104860 <initlock>
}
80105e0f:	83 c4 10             	add    $0x10,%esp
80105e12:	c9                   	leave  
80105e13:	c3                   	ret    
80105e14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105e20 <idtinit>:

void
idtinit(void)
{
80105e20:	55                   	push   %ebp
  pd[0] = size-1;
80105e21:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e26:	89 e5                	mov    %esp,%ebp
80105e28:	83 ec 10             	sub    $0x10,%esp
80105e2b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e2f:	b8 a0 81 11 80       	mov    $0x801181a0,%eax
80105e34:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e38:	c1 e8 10             	shr    $0x10,%eax
80105e3b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105e3f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e42:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e45:	c9                   	leave  
80105e46:	c3                   	ret    
80105e47:	89 f6                	mov    %esi,%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e50 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	57                   	push   %edi
80105e54:	56                   	push   %esi
80105e55:	53                   	push   %ebx
80105e56:	83 ec 1c             	sub    $0x1c,%esp
80105e59:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105e5c:	8b 47 30             	mov    0x30(%edi),%eax
80105e5f:	83 f8 40             	cmp    $0x40,%eax
80105e62:	0f 84 f0 00 00 00    	je     80105f58 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e68:	83 e8 20             	sub    $0x20,%eax
80105e6b:	83 f8 1f             	cmp    $0x1f,%eax
80105e6e:	77 10                	ja     80105e80 <trap+0x30>
80105e70:	ff 24 85 0c 7f 10 80 	jmp    *-0x7fef80f4(,%eax,4)
80105e77:	89 f6                	mov    %esi,%esi
80105e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e80:	e8 9b da ff ff       	call   80103920 <myproc>
80105e85:	85 c0                	test   %eax,%eax
80105e87:	8b 5f 38             	mov    0x38(%edi),%ebx
80105e8a:	0f 84 14 02 00 00    	je     801060a4 <trap+0x254>
80105e90:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105e94:	0f 84 0a 02 00 00    	je     801060a4 <trap+0x254>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e9a:	0f 20 d1             	mov    %cr2,%ecx
80105e9d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ea0:	e8 5b da ff ff       	call   80103900 <cpuid>
80105ea5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105ea8:	8b 47 34             	mov    0x34(%edi),%eax
80105eab:	8b 77 30             	mov    0x30(%edi),%esi
80105eae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105eb1:	e8 6a da ff ff       	call   80103920 <myproc>
80105eb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105eb9:	e8 62 da ff ff       	call   80103920 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ebe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ec1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ec4:	51                   	push   %ecx
80105ec5:	53                   	push   %ebx
80105ec6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105ec7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eca:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ecd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105ece:	83 c2 70             	add    $0x70,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ed1:	52                   	push   %edx
80105ed2:	ff 70 10             	pushl  0x10(%eax)
80105ed5:	68 c8 7e 10 80       	push   $0x80107ec8
80105eda:	e8 81 a7 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105edf:	83 c4 20             	add    $0x20,%esp
80105ee2:	e8 39 da ff ff       	call   80103920 <myproc>
80105ee7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eee:	e8 2d da ff ff       	call   80103920 <myproc>
80105ef3:	85 c0                	test   %eax,%eax
80105ef5:	74 1d                	je     80105f14 <trap+0xc4>
80105ef7:	e8 24 da ff ff       	call   80103920 <myproc>
80105efc:	8b 50 24             	mov    0x24(%eax),%edx
80105eff:	85 d2                	test   %edx,%edx
80105f01:	74 11                	je     80105f14 <trap+0xc4>
80105f03:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105f07:	83 e0 03             	and    $0x3,%eax
80105f0a:	66 83 f8 03          	cmp    $0x3,%ax
80105f0e:	0f 84 4c 01 00 00    	je     80106060 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105f14:	e8 07 da ff ff       	call   80103920 <myproc>
80105f19:	85 c0                	test   %eax,%eax
80105f1b:	74 0d                	je     80105f2a <trap+0xda>
80105f1d:	e8 fe d9 ff ff       	call   80103920 <myproc>
80105f22:	8b 40 0c             	mov    0xc(%eax),%eax
80105f25:	83 f8 07             	cmp    $0x7,%eax
80105f28:	74 66                	je     80105f90 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f2a:	e8 f1 d9 ff ff       	call   80103920 <myproc>
80105f2f:	85 c0                	test   %eax,%eax
80105f31:	74 19                	je     80105f4c <trap+0xfc>
80105f33:	e8 e8 d9 ff ff       	call   80103920 <myproc>
80105f38:	8b 40 24             	mov    0x24(%eax),%eax
80105f3b:	85 c0                	test   %eax,%eax
80105f3d:	74 0d                	je     80105f4c <trap+0xfc>
80105f3f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105f43:	83 e0 03             	and    $0x3,%eax
80105f46:	66 83 f8 03          	cmp    $0x3,%ax
80105f4a:	74 35                	je     80105f81 <trap+0x131>
    exit();
}
80105f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f4f:	5b                   	pop    %ebx
80105f50:	5e                   	pop    %esi
80105f51:	5f                   	pop    %edi
80105f52:	5d                   	pop    %ebp
80105f53:	c3                   	ret    
80105f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105f58:	e8 c3 d9 ff ff       	call   80103920 <myproc>
80105f5d:	8b 58 24             	mov    0x24(%eax),%ebx
80105f60:	85 db                	test   %ebx,%ebx
80105f62:	0f 85 e8 00 00 00    	jne    80106050 <trap+0x200>
    myproc()->tf = tf;
80105f68:	e8 b3 d9 ff ff       	call   80103920 <myproc>
80105f6d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105f70:	e8 2b ef ff ff       	call   80104ea0 <syscall>
    if(myproc()->killed)
80105f75:	e8 a6 d9 ff ff       	call   80103920 <myproc>
80105f7a:	8b 48 24             	mov    0x24(%eax),%ecx
80105f7d:	85 c9                	test   %ecx,%ecx
80105f7f:	74 cb                	je     80105f4c <trap+0xfc>
}
80105f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f84:	5b                   	pop    %ebx
80105f85:	5e                   	pop    %esi
80105f86:	5f                   	pop    %edi
80105f87:	5d                   	pop    %ebp
      exit();
80105f88:	e9 03 df ff ff       	jmp    80103e90 <exit>
80105f8d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105f90:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105f94:	75 94                	jne    80105f2a <trap+0xda>
    yield();
80105f96:	e8 85 e1 ff ff       	call   80104120 <yield>
80105f9b:	eb 8d                	jmp    80105f2a <trap+0xda>
80105f9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105fa0:	e8 5b d9 ff ff       	call   80103900 <cpuid>
80105fa5:	85 c0                	test   %eax,%eax
80105fa7:	0f 84 c3 00 00 00    	je     80106070 <trap+0x220>
    lapiceoi();
80105fad:	e8 de c7 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fb2:	e8 69 d9 ff ff       	call   80103920 <myproc>
80105fb7:	85 c0                	test   %eax,%eax
80105fb9:	0f 85 38 ff ff ff    	jne    80105ef7 <trap+0xa7>
80105fbf:	e9 50 ff ff ff       	jmp    80105f14 <trap+0xc4>
80105fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105fc8:	e8 83 c6 ff ff       	call   80102650 <kbdintr>
    lapiceoi();
80105fcd:	e8 be c7 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fd2:	e8 49 d9 ff ff       	call   80103920 <myproc>
80105fd7:	85 c0                	test   %eax,%eax
80105fd9:	0f 85 18 ff ff ff    	jne    80105ef7 <trap+0xa7>
80105fdf:	e9 30 ff ff ff       	jmp    80105f14 <trap+0xc4>
80105fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105fe8:	e8 53 02 00 00       	call   80106240 <uartintr>
    lapiceoi();
80105fed:	e8 9e c7 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ff2:	e8 29 d9 ff ff       	call   80103920 <myproc>
80105ff7:	85 c0                	test   %eax,%eax
80105ff9:	0f 85 f8 fe ff ff    	jne    80105ef7 <trap+0xa7>
80105fff:	e9 10 ff ff ff       	jmp    80105f14 <trap+0xc4>
80106004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106008:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010600c:	8b 77 38             	mov    0x38(%edi),%esi
8010600f:	e8 ec d8 ff ff       	call   80103900 <cpuid>
80106014:	56                   	push   %esi
80106015:	53                   	push   %ebx
80106016:	50                   	push   %eax
80106017:	68 70 7e 10 80       	push   $0x80107e70
8010601c:	e8 3f a6 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106021:	e8 6a c7 ff ff       	call   80102790 <lapiceoi>
    break;
80106026:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106029:	e8 f2 d8 ff ff       	call   80103920 <myproc>
8010602e:	85 c0                	test   %eax,%eax
80106030:	0f 85 c1 fe ff ff    	jne    80105ef7 <trap+0xa7>
80106036:	e9 d9 fe ff ff       	jmp    80105f14 <trap+0xc4>
8010603b:	90                   	nop
8010603c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106040:	e8 6b c0 ff ff       	call   801020b0 <ideintr>
80106045:	e9 63 ff ff ff       	jmp    80105fad <trap+0x15d>
8010604a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106050:	e8 3b de ff ff       	call   80103e90 <exit>
80106055:	e9 0e ff ff ff       	jmp    80105f68 <trap+0x118>
8010605a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106060:	e8 2b de ff ff       	call   80103e90 <exit>
80106065:	e9 aa fe ff ff       	jmp    80105f14 <trap+0xc4>
8010606a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106070:	83 ec 0c             	sub    $0xc,%esp
80106073:	68 60 81 11 80       	push   $0x80118160
80106078:	e8 23 e9 ff ff       	call   801049a0 <acquire>
      wakeup(&ticks);
8010607d:	c7 04 24 a0 89 11 80 	movl   $0x801189a0,(%esp)
      ticks++;
80106084:	83 05 a0 89 11 80 01 	addl   $0x1,0x801189a0
      wakeup(&ticks);
8010608b:	e8 a0 e1 ff ff       	call   80104230 <wakeup>
      release(&tickslock);
80106090:	c7 04 24 60 81 11 80 	movl   $0x80118160,(%esp)
80106097:	e8 c4 e9 ff ff       	call   80104a60 <release>
8010609c:	83 c4 10             	add    $0x10,%esp
8010609f:	e9 09 ff ff ff       	jmp    80105fad <trap+0x15d>
801060a4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060a7:	e8 54 d8 ff ff       	call   80103900 <cpuid>
801060ac:	83 ec 0c             	sub    $0xc,%esp
801060af:	56                   	push   %esi
801060b0:	53                   	push   %ebx
801060b1:	50                   	push   %eax
801060b2:	ff 77 30             	pushl  0x30(%edi)
801060b5:	68 94 7e 10 80       	push   $0x80107e94
801060ba:	e8 a1 a5 ff ff       	call   80100660 <cprintf>
      panic("trap");
801060bf:	83 c4 14             	add    $0x14,%esp
801060c2:	68 6a 7e 10 80       	push   $0x80107e6a
801060c7:	e8 c4 a2 ff ff       	call   80100390 <panic>
801060cc:	66 90                	xchg   %ax,%ax
801060ce:	66 90                	xchg   %ax,%ax

801060d0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801060d0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
801060d5:	55                   	push   %ebp
801060d6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801060d8:	85 c0                	test   %eax,%eax
801060da:	74 1c                	je     801060f8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060dc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060e1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801060e2:	a8 01                	test   $0x1,%al
801060e4:	74 12                	je     801060f8 <uartgetc+0x28>
801060e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060eb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801060ec:	0f b6 c0             	movzbl %al,%eax
}
801060ef:	5d                   	pop    %ebp
801060f0:	c3                   	ret    
801060f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801060f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060fd:	5d                   	pop    %ebp
801060fe:	c3                   	ret    
801060ff:	90                   	nop

80106100 <uartputc.part.0>:
uartputc(int c)
80106100:	55                   	push   %ebp
80106101:	89 e5                	mov    %esp,%ebp
80106103:	57                   	push   %edi
80106104:	56                   	push   %esi
80106105:	53                   	push   %ebx
80106106:	89 c7                	mov    %eax,%edi
80106108:	bb 80 00 00 00       	mov    $0x80,%ebx
8010610d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106112:	83 ec 0c             	sub    $0xc,%esp
80106115:	eb 1b                	jmp    80106132 <uartputc.part.0+0x32>
80106117:	89 f6                	mov    %esi,%esi
80106119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106120:	83 ec 0c             	sub    $0xc,%esp
80106123:	6a 0a                	push   $0xa
80106125:	e8 86 c6 ff ff       	call   801027b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010612a:	83 c4 10             	add    $0x10,%esp
8010612d:	83 eb 01             	sub    $0x1,%ebx
80106130:	74 07                	je     80106139 <uartputc.part.0+0x39>
80106132:	89 f2                	mov    %esi,%edx
80106134:	ec                   	in     (%dx),%al
80106135:	a8 20                	test   $0x20,%al
80106137:	74 e7                	je     80106120 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106139:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010613e:	89 f8                	mov    %edi,%eax
80106140:	ee                   	out    %al,(%dx)
}
80106141:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106144:	5b                   	pop    %ebx
80106145:	5e                   	pop    %esi
80106146:	5f                   	pop    %edi
80106147:	5d                   	pop    %ebp
80106148:	c3                   	ret    
80106149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106150 <uartinit>:
{
80106150:	55                   	push   %ebp
80106151:	31 c9                	xor    %ecx,%ecx
80106153:	89 c8                	mov    %ecx,%eax
80106155:	89 e5                	mov    %esp,%ebp
80106157:	57                   	push   %edi
80106158:	56                   	push   %esi
80106159:	53                   	push   %ebx
8010615a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010615f:	89 da                	mov    %ebx,%edx
80106161:	83 ec 0c             	sub    $0xc,%esp
80106164:	ee                   	out    %al,(%dx)
80106165:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010616a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010616f:	89 fa                	mov    %edi,%edx
80106171:	ee                   	out    %al,(%dx)
80106172:	b8 0c 00 00 00       	mov    $0xc,%eax
80106177:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010617c:	ee                   	out    %al,(%dx)
8010617d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106182:	89 c8                	mov    %ecx,%eax
80106184:	89 f2                	mov    %esi,%edx
80106186:	ee                   	out    %al,(%dx)
80106187:	b8 03 00 00 00       	mov    $0x3,%eax
8010618c:	89 fa                	mov    %edi,%edx
8010618e:	ee                   	out    %al,(%dx)
8010618f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106194:	89 c8                	mov    %ecx,%eax
80106196:	ee                   	out    %al,(%dx)
80106197:	b8 01 00 00 00       	mov    $0x1,%eax
8010619c:	89 f2                	mov    %esi,%edx
8010619e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010619f:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061a4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801061a5:	3c ff                	cmp    $0xff,%al
801061a7:	74 5a                	je     80106203 <uartinit+0xb3>
  uart = 1;
801061a9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801061b0:	00 00 00 
801061b3:	89 da                	mov    %ebx,%edx
801061b5:	ec                   	in     (%dx),%al
801061b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061bb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801061bc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801061bf:	bb 8c 7f 10 80       	mov    $0x80107f8c,%ebx
  ioapicenable(IRQ_COM1, 0);
801061c4:	6a 00                	push   $0x0
801061c6:	6a 04                	push   $0x4
801061c8:	e8 43 c1 ff ff       	call   80102310 <ioapicenable>
801061cd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801061d0:	b8 78 00 00 00       	mov    $0x78,%eax
801061d5:	eb 13                	jmp    801061ea <uartinit+0x9a>
801061d7:	89 f6                	mov    %esi,%esi
801061d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801061e0:	83 c3 01             	add    $0x1,%ebx
801061e3:	0f be 03             	movsbl (%ebx),%eax
801061e6:	84 c0                	test   %al,%al
801061e8:	74 19                	je     80106203 <uartinit+0xb3>
  if(!uart)
801061ea:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801061f0:	85 d2                	test   %edx,%edx
801061f2:	74 ec                	je     801061e0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801061f4:	83 c3 01             	add    $0x1,%ebx
801061f7:	e8 04 ff ff ff       	call   80106100 <uartputc.part.0>
801061fc:	0f be 03             	movsbl (%ebx),%eax
801061ff:	84 c0                	test   %al,%al
80106201:	75 e7                	jne    801061ea <uartinit+0x9a>
}
80106203:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106206:	5b                   	pop    %ebx
80106207:	5e                   	pop    %esi
80106208:	5f                   	pop    %edi
80106209:	5d                   	pop    %ebp
8010620a:	c3                   	ret    
8010620b:	90                   	nop
8010620c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106210 <uartputc>:
  if(!uart)
80106210:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106216:	55                   	push   %ebp
80106217:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106219:	85 d2                	test   %edx,%edx
{
8010621b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010621e:	74 10                	je     80106230 <uartputc+0x20>
}
80106220:	5d                   	pop    %ebp
80106221:	e9 da fe ff ff       	jmp    80106100 <uartputc.part.0>
80106226:	8d 76 00             	lea    0x0(%esi),%esi
80106229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106230:	5d                   	pop    %ebp
80106231:	c3                   	ret    
80106232:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106240 <uartintr>:

void
uartintr(void)
{
80106240:	55                   	push   %ebp
80106241:	89 e5                	mov    %esp,%ebp
80106243:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106246:	68 d0 60 10 80       	push   $0x801060d0
8010624b:	e8 c0 a5 ff ff       	call   80100810 <consoleintr>
}
80106250:	83 c4 10             	add    $0x10,%esp
80106253:	c9                   	leave  
80106254:	c3                   	ret    

80106255 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106255:	6a 00                	push   $0x0
  pushl $0
80106257:	6a 00                	push   $0x0
  jmp alltraps
80106259:	e9 11 fb ff ff       	jmp    80105d6f <alltraps>

8010625e <vector1>:
.globl vector1
vector1:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $1
80106260:	6a 01                	push   $0x1
  jmp alltraps
80106262:	e9 08 fb ff ff       	jmp    80105d6f <alltraps>

80106267 <vector2>:
.globl vector2
vector2:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $2
80106269:	6a 02                	push   $0x2
  jmp alltraps
8010626b:	e9 ff fa ff ff       	jmp    80105d6f <alltraps>

80106270 <vector3>:
.globl vector3
vector3:
  pushl $0
80106270:	6a 00                	push   $0x0
  pushl $3
80106272:	6a 03                	push   $0x3
  jmp alltraps
80106274:	e9 f6 fa ff ff       	jmp    80105d6f <alltraps>

80106279 <vector4>:
.globl vector4
vector4:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $4
8010627b:	6a 04                	push   $0x4
  jmp alltraps
8010627d:	e9 ed fa ff ff       	jmp    80105d6f <alltraps>

80106282 <vector5>:
.globl vector5
vector5:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $5
80106284:	6a 05                	push   $0x5
  jmp alltraps
80106286:	e9 e4 fa ff ff       	jmp    80105d6f <alltraps>

8010628b <vector6>:
.globl vector6
vector6:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $6
8010628d:	6a 06                	push   $0x6
  jmp alltraps
8010628f:	e9 db fa ff ff       	jmp    80105d6f <alltraps>

80106294 <vector7>:
.globl vector7
vector7:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $7
80106296:	6a 07                	push   $0x7
  jmp alltraps
80106298:	e9 d2 fa ff ff       	jmp    80105d6f <alltraps>

8010629d <vector8>:
.globl vector8
vector8:
  pushl $8
8010629d:	6a 08                	push   $0x8
  jmp alltraps
8010629f:	e9 cb fa ff ff       	jmp    80105d6f <alltraps>

801062a4 <vector9>:
.globl vector9
vector9:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $9
801062a6:	6a 09                	push   $0x9
  jmp alltraps
801062a8:	e9 c2 fa ff ff       	jmp    80105d6f <alltraps>

801062ad <vector10>:
.globl vector10
vector10:
  pushl $10
801062ad:	6a 0a                	push   $0xa
  jmp alltraps
801062af:	e9 bb fa ff ff       	jmp    80105d6f <alltraps>

801062b4 <vector11>:
.globl vector11
vector11:
  pushl $11
801062b4:	6a 0b                	push   $0xb
  jmp alltraps
801062b6:	e9 b4 fa ff ff       	jmp    80105d6f <alltraps>

801062bb <vector12>:
.globl vector12
vector12:
  pushl $12
801062bb:	6a 0c                	push   $0xc
  jmp alltraps
801062bd:	e9 ad fa ff ff       	jmp    80105d6f <alltraps>

801062c2 <vector13>:
.globl vector13
vector13:
  pushl $13
801062c2:	6a 0d                	push   $0xd
  jmp alltraps
801062c4:	e9 a6 fa ff ff       	jmp    80105d6f <alltraps>

801062c9 <vector14>:
.globl vector14
vector14:
  pushl $14
801062c9:	6a 0e                	push   $0xe
  jmp alltraps
801062cb:	e9 9f fa ff ff       	jmp    80105d6f <alltraps>

801062d0 <vector15>:
.globl vector15
vector15:
  pushl $0
801062d0:	6a 00                	push   $0x0
  pushl $15
801062d2:	6a 0f                	push   $0xf
  jmp alltraps
801062d4:	e9 96 fa ff ff       	jmp    80105d6f <alltraps>

801062d9 <vector16>:
.globl vector16
vector16:
  pushl $0
801062d9:	6a 00                	push   $0x0
  pushl $16
801062db:	6a 10                	push   $0x10
  jmp alltraps
801062dd:	e9 8d fa ff ff       	jmp    80105d6f <alltraps>

801062e2 <vector17>:
.globl vector17
vector17:
  pushl $17
801062e2:	6a 11                	push   $0x11
  jmp alltraps
801062e4:	e9 86 fa ff ff       	jmp    80105d6f <alltraps>

801062e9 <vector18>:
.globl vector18
vector18:
  pushl $0
801062e9:	6a 00                	push   $0x0
  pushl $18
801062eb:	6a 12                	push   $0x12
  jmp alltraps
801062ed:	e9 7d fa ff ff       	jmp    80105d6f <alltraps>

801062f2 <vector19>:
.globl vector19
vector19:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $19
801062f4:	6a 13                	push   $0x13
  jmp alltraps
801062f6:	e9 74 fa ff ff       	jmp    80105d6f <alltraps>

801062fb <vector20>:
.globl vector20
vector20:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $20
801062fd:	6a 14                	push   $0x14
  jmp alltraps
801062ff:	e9 6b fa ff ff       	jmp    80105d6f <alltraps>

80106304 <vector21>:
.globl vector21
vector21:
  pushl $0
80106304:	6a 00                	push   $0x0
  pushl $21
80106306:	6a 15                	push   $0x15
  jmp alltraps
80106308:	e9 62 fa ff ff       	jmp    80105d6f <alltraps>

8010630d <vector22>:
.globl vector22
vector22:
  pushl $0
8010630d:	6a 00                	push   $0x0
  pushl $22
8010630f:	6a 16                	push   $0x16
  jmp alltraps
80106311:	e9 59 fa ff ff       	jmp    80105d6f <alltraps>

80106316 <vector23>:
.globl vector23
vector23:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $23
80106318:	6a 17                	push   $0x17
  jmp alltraps
8010631a:	e9 50 fa ff ff       	jmp    80105d6f <alltraps>

8010631f <vector24>:
.globl vector24
vector24:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $24
80106321:	6a 18                	push   $0x18
  jmp alltraps
80106323:	e9 47 fa ff ff       	jmp    80105d6f <alltraps>

80106328 <vector25>:
.globl vector25
vector25:
  pushl $0
80106328:	6a 00                	push   $0x0
  pushl $25
8010632a:	6a 19                	push   $0x19
  jmp alltraps
8010632c:	e9 3e fa ff ff       	jmp    80105d6f <alltraps>

80106331 <vector26>:
.globl vector26
vector26:
  pushl $0
80106331:	6a 00                	push   $0x0
  pushl $26
80106333:	6a 1a                	push   $0x1a
  jmp alltraps
80106335:	e9 35 fa ff ff       	jmp    80105d6f <alltraps>

8010633a <vector27>:
.globl vector27
vector27:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $27
8010633c:	6a 1b                	push   $0x1b
  jmp alltraps
8010633e:	e9 2c fa ff ff       	jmp    80105d6f <alltraps>

80106343 <vector28>:
.globl vector28
vector28:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $28
80106345:	6a 1c                	push   $0x1c
  jmp alltraps
80106347:	e9 23 fa ff ff       	jmp    80105d6f <alltraps>

8010634c <vector29>:
.globl vector29
vector29:
  pushl $0
8010634c:	6a 00                	push   $0x0
  pushl $29
8010634e:	6a 1d                	push   $0x1d
  jmp alltraps
80106350:	e9 1a fa ff ff       	jmp    80105d6f <alltraps>

80106355 <vector30>:
.globl vector30
vector30:
  pushl $0
80106355:	6a 00                	push   $0x0
  pushl $30
80106357:	6a 1e                	push   $0x1e
  jmp alltraps
80106359:	e9 11 fa ff ff       	jmp    80105d6f <alltraps>

8010635e <vector31>:
.globl vector31
vector31:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $31
80106360:	6a 1f                	push   $0x1f
  jmp alltraps
80106362:	e9 08 fa ff ff       	jmp    80105d6f <alltraps>

80106367 <vector32>:
.globl vector32
vector32:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $32
80106369:	6a 20                	push   $0x20
  jmp alltraps
8010636b:	e9 ff f9 ff ff       	jmp    80105d6f <alltraps>

80106370 <vector33>:
.globl vector33
vector33:
  pushl $0
80106370:	6a 00                	push   $0x0
  pushl $33
80106372:	6a 21                	push   $0x21
  jmp alltraps
80106374:	e9 f6 f9 ff ff       	jmp    80105d6f <alltraps>

80106379 <vector34>:
.globl vector34
vector34:
  pushl $0
80106379:	6a 00                	push   $0x0
  pushl $34
8010637b:	6a 22                	push   $0x22
  jmp alltraps
8010637d:	e9 ed f9 ff ff       	jmp    80105d6f <alltraps>

80106382 <vector35>:
.globl vector35
vector35:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $35
80106384:	6a 23                	push   $0x23
  jmp alltraps
80106386:	e9 e4 f9 ff ff       	jmp    80105d6f <alltraps>

8010638b <vector36>:
.globl vector36
vector36:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $36
8010638d:	6a 24                	push   $0x24
  jmp alltraps
8010638f:	e9 db f9 ff ff       	jmp    80105d6f <alltraps>

80106394 <vector37>:
.globl vector37
vector37:
  pushl $0
80106394:	6a 00                	push   $0x0
  pushl $37
80106396:	6a 25                	push   $0x25
  jmp alltraps
80106398:	e9 d2 f9 ff ff       	jmp    80105d6f <alltraps>

8010639d <vector38>:
.globl vector38
vector38:
  pushl $0
8010639d:	6a 00                	push   $0x0
  pushl $38
8010639f:	6a 26                	push   $0x26
  jmp alltraps
801063a1:	e9 c9 f9 ff ff       	jmp    80105d6f <alltraps>

801063a6 <vector39>:
.globl vector39
vector39:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $39
801063a8:	6a 27                	push   $0x27
  jmp alltraps
801063aa:	e9 c0 f9 ff ff       	jmp    80105d6f <alltraps>

801063af <vector40>:
.globl vector40
vector40:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $40
801063b1:	6a 28                	push   $0x28
  jmp alltraps
801063b3:	e9 b7 f9 ff ff       	jmp    80105d6f <alltraps>

801063b8 <vector41>:
.globl vector41
vector41:
  pushl $0
801063b8:	6a 00                	push   $0x0
  pushl $41
801063ba:	6a 29                	push   $0x29
  jmp alltraps
801063bc:	e9 ae f9 ff ff       	jmp    80105d6f <alltraps>

801063c1 <vector42>:
.globl vector42
vector42:
  pushl $0
801063c1:	6a 00                	push   $0x0
  pushl $42
801063c3:	6a 2a                	push   $0x2a
  jmp alltraps
801063c5:	e9 a5 f9 ff ff       	jmp    80105d6f <alltraps>

801063ca <vector43>:
.globl vector43
vector43:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $43
801063cc:	6a 2b                	push   $0x2b
  jmp alltraps
801063ce:	e9 9c f9 ff ff       	jmp    80105d6f <alltraps>

801063d3 <vector44>:
.globl vector44
vector44:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $44
801063d5:	6a 2c                	push   $0x2c
  jmp alltraps
801063d7:	e9 93 f9 ff ff       	jmp    80105d6f <alltraps>

801063dc <vector45>:
.globl vector45
vector45:
  pushl $0
801063dc:	6a 00                	push   $0x0
  pushl $45
801063de:	6a 2d                	push   $0x2d
  jmp alltraps
801063e0:	e9 8a f9 ff ff       	jmp    80105d6f <alltraps>

801063e5 <vector46>:
.globl vector46
vector46:
  pushl $0
801063e5:	6a 00                	push   $0x0
  pushl $46
801063e7:	6a 2e                	push   $0x2e
  jmp alltraps
801063e9:	e9 81 f9 ff ff       	jmp    80105d6f <alltraps>

801063ee <vector47>:
.globl vector47
vector47:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $47
801063f0:	6a 2f                	push   $0x2f
  jmp alltraps
801063f2:	e9 78 f9 ff ff       	jmp    80105d6f <alltraps>

801063f7 <vector48>:
.globl vector48
vector48:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $48
801063f9:	6a 30                	push   $0x30
  jmp alltraps
801063fb:	e9 6f f9 ff ff       	jmp    80105d6f <alltraps>

80106400 <vector49>:
.globl vector49
vector49:
  pushl $0
80106400:	6a 00                	push   $0x0
  pushl $49
80106402:	6a 31                	push   $0x31
  jmp alltraps
80106404:	e9 66 f9 ff ff       	jmp    80105d6f <alltraps>

80106409 <vector50>:
.globl vector50
vector50:
  pushl $0
80106409:	6a 00                	push   $0x0
  pushl $50
8010640b:	6a 32                	push   $0x32
  jmp alltraps
8010640d:	e9 5d f9 ff ff       	jmp    80105d6f <alltraps>

80106412 <vector51>:
.globl vector51
vector51:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $51
80106414:	6a 33                	push   $0x33
  jmp alltraps
80106416:	e9 54 f9 ff ff       	jmp    80105d6f <alltraps>

8010641b <vector52>:
.globl vector52
vector52:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $52
8010641d:	6a 34                	push   $0x34
  jmp alltraps
8010641f:	e9 4b f9 ff ff       	jmp    80105d6f <alltraps>

80106424 <vector53>:
.globl vector53
vector53:
  pushl $0
80106424:	6a 00                	push   $0x0
  pushl $53
80106426:	6a 35                	push   $0x35
  jmp alltraps
80106428:	e9 42 f9 ff ff       	jmp    80105d6f <alltraps>

8010642d <vector54>:
.globl vector54
vector54:
  pushl $0
8010642d:	6a 00                	push   $0x0
  pushl $54
8010642f:	6a 36                	push   $0x36
  jmp alltraps
80106431:	e9 39 f9 ff ff       	jmp    80105d6f <alltraps>

80106436 <vector55>:
.globl vector55
vector55:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $55
80106438:	6a 37                	push   $0x37
  jmp alltraps
8010643a:	e9 30 f9 ff ff       	jmp    80105d6f <alltraps>

8010643f <vector56>:
.globl vector56
vector56:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $56
80106441:	6a 38                	push   $0x38
  jmp alltraps
80106443:	e9 27 f9 ff ff       	jmp    80105d6f <alltraps>

80106448 <vector57>:
.globl vector57
vector57:
  pushl $0
80106448:	6a 00                	push   $0x0
  pushl $57
8010644a:	6a 39                	push   $0x39
  jmp alltraps
8010644c:	e9 1e f9 ff ff       	jmp    80105d6f <alltraps>

80106451 <vector58>:
.globl vector58
vector58:
  pushl $0
80106451:	6a 00                	push   $0x0
  pushl $58
80106453:	6a 3a                	push   $0x3a
  jmp alltraps
80106455:	e9 15 f9 ff ff       	jmp    80105d6f <alltraps>

8010645a <vector59>:
.globl vector59
vector59:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $59
8010645c:	6a 3b                	push   $0x3b
  jmp alltraps
8010645e:	e9 0c f9 ff ff       	jmp    80105d6f <alltraps>

80106463 <vector60>:
.globl vector60
vector60:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $60
80106465:	6a 3c                	push   $0x3c
  jmp alltraps
80106467:	e9 03 f9 ff ff       	jmp    80105d6f <alltraps>

8010646c <vector61>:
.globl vector61
vector61:
  pushl $0
8010646c:	6a 00                	push   $0x0
  pushl $61
8010646e:	6a 3d                	push   $0x3d
  jmp alltraps
80106470:	e9 fa f8 ff ff       	jmp    80105d6f <alltraps>

80106475 <vector62>:
.globl vector62
vector62:
  pushl $0
80106475:	6a 00                	push   $0x0
  pushl $62
80106477:	6a 3e                	push   $0x3e
  jmp alltraps
80106479:	e9 f1 f8 ff ff       	jmp    80105d6f <alltraps>

8010647e <vector63>:
.globl vector63
vector63:
  pushl $0
8010647e:	6a 00                	push   $0x0
  pushl $63
80106480:	6a 3f                	push   $0x3f
  jmp alltraps
80106482:	e9 e8 f8 ff ff       	jmp    80105d6f <alltraps>

80106487 <vector64>:
.globl vector64
vector64:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $64
80106489:	6a 40                	push   $0x40
  jmp alltraps
8010648b:	e9 df f8 ff ff       	jmp    80105d6f <alltraps>

80106490 <vector65>:
.globl vector65
vector65:
  pushl $0
80106490:	6a 00                	push   $0x0
  pushl $65
80106492:	6a 41                	push   $0x41
  jmp alltraps
80106494:	e9 d6 f8 ff ff       	jmp    80105d6f <alltraps>

80106499 <vector66>:
.globl vector66
vector66:
  pushl $0
80106499:	6a 00                	push   $0x0
  pushl $66
8010649b:	6a 42                	push   $0x42
  jmp alltraps
8010649d:	e9 cd f8 ff ff       	jmp    80105d6f <alltraps>

801064a2 <vector67>:
.globl vector67
vector67:
  pushl $0
801064a2:	6a 00                	push   $0x0
  pushl $67
801064a4:	6a 43                	push   $0x43
  jmp alltraps
801064a6:	e9 c4 f8 ff ff       	jmp    80105d6f <alltraps>

801064ab <vector68>:
.globl vector68
vector68:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $68
801064ad:	6a 44                	push   $0x44
  jmp alltraps
801064af:	e9 bb f8 ff ff       	jmp    80105d6f <alltraps>

801064b4 <vector69>:
.globl vector69
vector69:
  pushl $0
801064b4:	6a 00                	push   $0x0
  pushl $69
801064b6:	6a 45                	push   $0x45
  jmp alltraps
801064b8:	e9 b2 f8 ff ff       	jmp    80105d6f <alltraps>

801064bd <vector70>:
.globl vector70
vector70:
  pushl $0
801064bd:	6a 00                	push   $0x0
  pushl $70
801064bf:	6a 46                	push   $0x46
  jmp alltraps
801064c1:	e9 a9 f8 ff ff       	jmp    80105d6f <alltraps>

801064c6 <vector71>:
.globl vector71
vector71:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $71
801064c8:	6a 47                	push   $0x47
  jmp alltraps
801064ca:	e9 a0 f8 ff ff       	jmp    80105d6f <alltraps>

801064cf <vector72>:
.globl vector72
vector72:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $72
801064d1:	6a 48                	push   $0x48
  jmp alltraps
801064d3:	e9 97 f8 ff ff       	jmp    80105d6f <alltraps>

801064d8 <vector73>:
.globl vector73
vector73:
  pushl $0
801064d8:	6a 00                	push   $0x0
  pushl $73
801064da:	6a 49                	push   $0x49
  jmp alltraps
801064dc:	e9 8e f8 ff ff       	jmp    80105d6f <alltraps>

801064e1 <vector74>:
.globl vector74
vector74:
  pushl $0
801064e1:	6a 00                	push   $0x0
  pushl $74
801064e3:	6a 4a                	push   $0x4a
  jmp alltraps
801064e5:	e9 85 f8 ff ff       	jmp    80105d6f <alltraps>

801064ea <vector75>:
.globl vector75
vector75:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $75
801064ec:	6a 4b                	push   $0x4b
  jmp alltraps
801064ee:	e9 7c f8 ff ff       	jmp    80105d6f <alltraps>

801064f3 <vector76>:
.globl vector76
vector76:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $76
801064f5:	6a 4c                	push   $0x4c
  jmp alltraps
801064f7:	e9 73 f8 ff ff       	jmp    80105d6f <alltraps>

801064fc <vector77>:
.globl vector77
vector77:
  pushl $0
801064fc:	6a 00                	push   $0x0
  pushl $77
801064fe:	6a 4d                	push   $0x4d
  jmp alltraps
80106500:	e9 6a f8 ff ff       	jmp    80105d6f <alltraps>

80106505 <vector78>:
.globl vector78
vector78:
  pushl $0
80106505:	6a 00                	push   $0x0
  pushl $78
80106507:	6a 4e                	push   $0x4e
  jmp alltraps
80106509:	e9 61 f8 ff ff       	jmp    80105d6f <alltraps>

8010650e <vector79>:
.globl vector79
vector79:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $79
80106510:	6a 4f                	push   $0x4f
  jmp alltraps
80106512:	e9 58 f8 ff ff       	jmp    80105d6f <alltraps>

80106517 <vector80>:
.globl vector80
vector80:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $80
80106519:	6a 50                	push   $0x50
  jmp alltraps
8010651b:	e9 4f f8 ff ff       	jmp    80105d6f <alltraps>

80106520 <vector81>:
.globl vector81
vector81:
  pushl $0
80106520:	6a 00                	push   $0x0
  pushl $81
80106522:	6a 51                	push   $0x51
  jmp alltraps
80106524:	e9 46 f8 ff ff       	jmp    80105d6f <alltraps>

80106529 <vector82>:
.globl vector82
vector82:
  pushl $0
80106529:	6a 00                	push   $0x0
  pushl $82
8010652b:	6a 52                	push   $0x52
  jmp alltraps
8010652d:	e9 3d f8 ff ff       	jmp    80105d6f <alltraps>

80106532 <vector83>:
.globl vector83
vector83:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $83
80106534:	6a 53                	push   $0x53
  jmp alltraps
80106536:	e9 34 f8 ff ff       	jmp    80105d6f <alltraps>

8010653b <vector84>:
.globl vector84
vector84:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $84
8010653d:	6a 54                	push   $0x54
  jmp alltraps
8010653f:	e9 2b f8 ff ff       	jmp    80105d6f <alltraps>

80106544 <vector85>:
.globl vector85
vector85:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $85
80106546:	6a 55                	push   $0x55
  jmp alltraps
80106548:	e9 22 f8 ff ff       	jmp    80105d6f <alltraps>

8010654d <vector86>:
.globl vector86
vector86:
  pushl $0
8010654d:	6a 00                	push   $0x0
  pushl $86
8010654f:	6a 56                	push   $0x56
  jmp alltraps
80106551:	e9 19 f8 ff ff       	jmp    80105d6f <alltraps>

80106556 <vector87>:
.globl vector87
vector87:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $87
80106558:	6a 57                	push   $0x57
  jmp alltraps
8010655a:	e9 10 f8 ff ff       	jmp    80105d6f <alltraps>

8010655f <vector88>:
.globl vector88
vector88:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $88
80106561:	6a 58                	push   $0x58
  jmp alltraps
80106563:	e9 07 f8 ff ff       	jmp    80105d6f <alltraps>

80106568 <vector89>:
.globl vector89
vector89:
  pushl $0
80106568:	6a 00                	push   $0x0
  pushl $89
8010656a:	6a 59                	push   $0x59
  jmp alltraps
8010656c:	e9 fe f7 ff ff       	jmp    80105d6f <alltraps>

80106571 <vector90>:
.globl vector90
vector90:
  pushl $0
80106571:	6a 00                	push   $0x0
  pushl $90
80106573:	6a 5a                	push   $0x5a
  jmp alltraps
80106575:	e9 f5 f7 ff ff       	jmp    80105d6f <alltraps>

8010657a <vector91>:
.globl vector91
vector91:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $91
8010657c:	6a 5b                	push   $0x5b
  jmp alltraps
8010657e:	e9 ec f7 ff ff       	jmp    80105d6f <alltraps>

80106583 <vector92>:
.globl vector92
vector92:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $92
80106585:	6a 5c                	push   $0x5c
  jmp alltraps
80106587:	e9 e3 f7 ff ff       	jmp    80105d6f <alltraps>

8010658c <vector93>:
.globl vector93
vector93:
  pushl $0
8010658c:	6a 00                	push   $0x0
  pushl $93
8010658e:	6a 5d                	push   $0x5d
  jmp alltraps
80106590:	e9 da f7 ff ff       	jmp    80105d6f <alltraps>

80106595 <vector94>:
.globl vector94
vector94:
  pushl $0
80106595:	6a 00                	push   $0x0
  pushl $94
80106597:	6a 5e                	push   $0x5e
  jmp alltraps
80106599:	e9 d1 f7 ff ff       	jmp    80105d6f <alltraps>

8010659e <vector95>:
.globl vector95
vector95:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $95
801065a0:	6a 5f                	push   $0x5f
  jmp alltraps
801065a2:	e9 c8 f7 ff ff       	jmp    80105d6f <alltraps>

801065a7 <vector96>:
.globl vector96
vector96:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $96
801065a9:	6a 60                	push   $0x60
  jmp alltraps
801065ab:	e9 bf f7 ff ff       	jmp    80105d6f <alltraps>

801065b0 <vector97>:
.globl vector97
vector97:
  pushl $0
801065b0:	6a 00                	push   $0x0
  pushl $97
801065b2:	6a 61                	push   $0x61
  jmp alltraps
801065b4:	e9 b6 f7 ff ff       	jmp    80105d6f <alltraps>

801065b9 <vector98>:
.globl vector98
vector98:
  pushl $0
801065b9:	6a 00                	push   $0x0
  pushl $98
801065bb:	6a 62                	push   $0x62
  jmp alltraps
801065bd:	e9 ad f7 ff ff       	jmp    80105d6f <alltraps>

801065c2 <vector99>:
.globl vector99
vector99:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $99
801065c4:	6a 63                	push   $0x63
  jmp alltraps
801065c6:	e9 a4 f7 ff ff       	jmp    80105d6f <alltraps>

801065cb <vector100>:
.globl vector100
vector100:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $100
801065cd:	6a 64                	push   $0x64
  jmp alltraps
801065cf:	e9 9b f7 ff ff       	jmp    80105d6f <alltraps>

801065d4 <vector101>:
.globl vector101
vector101:
  pushl $0
801065d4:	6a 00                	push   $0x0
  pushl $101
801065d6:	6a 65                	push   $0x65
  jmp alltraps
801065d8:	e9 92 f7 ff ff       	jmp    80105d6f <alltraps>

801065dd <vector102>:
.globl vector102
vector102:
  pushl $0
801065dd:	6a 00                	push   $0x0
  pushl $102
801065df:	6a 66                	push   $0x66
  jmp alltraps
801065e1:	e9 89 f7 ff ff       	jmp    80105d6f <alltraps>

801065e6 <vector103>:
.globl vector103
vector103:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $103
801065e8:	6a 67                	push   $0x67
  jmp alltraps
801065ea:	e9 80 f7 ff ff       	jmp    80105d6f <alltraps>

801065ef <vector104>:
.globl vector104
vector104:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $104
801065f1:	6a 68                	push   $0x68
  jmp alltraps
801065f3:	e9 77 f7 ff ff       	jmp    80105d6f <alltraps>

801065f8 <vector105>:
.globl vector105
vector105:
  pushl $0
801065f8:	6a 00                	push   $0x0
  pushl $105
801065fa:	6a 69                	push   $0x69
  jmp alltraps
801065fc:	e9 6e f7 ff ff       	jmp    80105d6f <alltraps>

80106601 <vector106>:
.globl vector106
vector106:
  pushl $0
80106601:	6a 00                	push   $0x0
  pushl $106
80106603:	6a 6a                	push   $0x6a
  jmp alltraps
80106605:	e9 65 f7 ff ff       	jmp    80105d6f <alltraps>

8010660a <vector107>:
.globl vector107
vector107:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $107
8010660c:	6a 6b                	push   $0x6b
  jmp alltraps
8010660e:	e9 5c f7 ff ff       	jmp    80105d6f <alltraps>

80106613 <vector108>:
.globl vector108
vector108:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $108
80106615:	6a 6c                	push   $0x6c
  jmp alltraps
80106617:	e9 53 f7 ff ff       	jmp    80105d6f <alltraps>

8010661c <vector109>:
.globl vector109
vector109:
  pushl $0
8010661c:	6a 00                	push   $0x0
  pushl $109
8010661e:	6a 6d                	push   $0x6d
  jmp alltraps
80106620:	e9 4a f7 ff ff       	jmp    80105d6f <alltraps>

80106625 <vector110>:
.globl vector110
vector110:
  pushl $0
80106625:	6a 00                	push   $0x0
  pushl $110
80106627:	6a 6e                	push   $0x6e
  jmp alltraps
80106629:	e9 41 f7 ff ff       	jmp    80105d6f <alltraps>

8010662e <vector111>:
.globl vector111
vector111:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $111
80106630:	6a 6f                	push   $0x6f
  jmp alltraps
80106632:	e9 38 f7 ff ff       	jmp    80105d6f <alltraps>

80106637 <vector112>:
.globl vector112
vector112:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $112
80106639:	6a 70                	push   $0x70
  jmp alltraps
8010663b:	e9 2f f7 ff ff       	jmp    80105d6f <alltraps>

80106640 <vector113>:
.globl vector113
vector113:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $113
80106642:	6a 71                	push   $0x71
  jmp alltraps
80106644:	e9 26 f7 ff ff       	jmp    80105d6f <alltraps>

80106649 <vector114>:
.globl vector114
vector114:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $114
8010664b:	6a 72                	push   $0x72
  jmp alltraps
8010664d:	e9 1d f7 ff ff       	jmp    80105d6f <alltraps>

80106652 <vector115>:
.globl vector115
vector115:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $115
80106654:	6a 73                	push   $0x73
  jmp alltraps
80106656:	e9 14 f7 ff ff       	jmp    80105d6f <alltraps>

8010665b <vector116>:
.globl vector116
vector116:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $116
8010665d:	6a 74                	push   $0x74
  jmp alltraps
8010665f:	e9 0b f7 ff ff       	jmp    80105d6f <alltraps>

80106664 <vector117>:
.globl vector117
vector117:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $117
80106666:	6a 75                	push   $0x75
  jmp alltraps
80106668:	e9 02 f7 ff ff       	jmp    80105d6f <alltraps>

8010666d <vector118>:
.globl vector118
vector118:
  pushl $0
8010666d:	6a 00                	push   $0x0
  pushl $118
8010666f:	6a 76                	push   $0x76
  jmp alltraps
80106671:	e9 f9 f6 ff ff       	jmp    80105d6f <alltraps>

80106676 <vector119>:
.globl vector119
vector119:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $119
80106678:	6a 77                	push   $0x77
  jmp alltraps
8010667a:	e9 f0 f6 ff ff       	jmp    80105d6f <alltraps>

8010667f <vector120>:
.globl vector120
vector120:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $120
80106681:	6a 78                	push   $0x78
  jmp alltraps
80106683:	e9 e7 f6 ff ff       	jmp    80105d6f <alltraps>

80106688 <vector121>:
.globl vector121
vector121:
  pushl $0
80106688:	6a 00                	push   $0x0
  pushl $121
8010668a:	6a 79                	push   $0x79
  jmp alltraps
8010668c:	e9 de f6 ff ff       	jmp    80105d6f <alltraps>

80106691 <vector122>:
.globl vector122
vector122:
  pushl $0
80106691:	6a 00                	push   $0x0
  pushl $122
80106693:	6a 7a                	push   $0x7a
  jmp alltraps
80106695:	e9 d5 f6 ff ff       	jmp    80105d6f <alltraps>

8010669a <vector123>:
.globl vector123
vector123:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $123
8010669c:	6a 7b                	push   $0x7b
  jmp alltraps
8010669e:	e9 cc f6 ff ff       	jmp    80105d6f <alltraps>

801066a3 <vector124>:
.globl vector124
vector124:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $124
801066a5:	6a 7c                	push   $0x7c
  jmp alltraps
801066a7:	e9 c3 f6 ff ff       	jmp    80105d6f <alltraps>

801066ac <vector125>:
.globl vector125
vector125:
  pushl $0
801066ac:	6a 00                	push   $0x0
  pushl $125
801066ae:	6a 7d                	push   $0x7d
  jmp alltraps
801066b0:	e9 ba f6 ff ff       	jmp    80105d6f <alltraps>

801066b5 <vector126>:
.globl vector126
vector126:
  pushl $0
801066b5:	6a 00                	push   $0x0
  pushl $126
801066b7:	6a 7e                	push   $0x7e
  jmp alltraps
801066b9:	e9 b1 f6 ff ff       	jmp    80105d6f <alltraps>

801066be <vector127>:
.globl vector127
vector127:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $127
801066c0:	6a 7f                	push   $0x7f
  jmp alltraps
801066c2:	e9 a8 f6 ff ff       	jmp    80105d6f <alltraps>

801066c7 <vector128>:
.globl vector128
vector128:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $128
801066c9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801066ce:	e9 9c f6 ff ff       	jmp    80105d6f <alltraps>

801066d3 <vector129>:
.globl vector129
vector129:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $129
801066d5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801066da:	e9 90 f6 ff ff       	jmp    80105d6f <alltraps>

801066df <vector130>:
.globl vector130
vector130:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $130
801066e1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801066e6:	e9 84 f6 ff ff       	jmp    80105d6f <alltraps>

801066eb <vector131>:
.globl vector131
vector131:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $131
801066ed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066f2:	e9 78 f6 ff ff       	jmp    80105d6f <alltraps>

801066f7 <vector132>:
.globl vector132
vector132:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $132
801066f9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066fe:	e9 6c f6 ff ff       	jmp    80105d6f <alltraps>

80106703 <vector133>:
.globl vector133
vector133:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $133
80106705:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010670a:	e9 60 f6 ff ff       	jmp    80105d6f <alltraps>

8010670f <vector134>:
.globl vector134
vector134:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $134
80106711:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106716:	e9 54 f6 ff ff       	jmp    80105d6f <alltraps>

8010671b <vector135>:
.globl vector135
vector135:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $135
8010671d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106722:	e9 48 f6 ff ff       	jmp    80105d6f <alltraps>

80106727 <vector136>:
.globl vector136
vector136:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $136
80106729:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010672e:	e9 3c f6 ff ff       	jmp    80105d6f <alltraps>

80106733 <vector137>:
.globl vector137
vector137:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $137
80106735:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010673a:	e9 30 f6 ff ff       	jmp    80105d6f <alltraps>

8010673f <vector138>:
.globl vector138
vector138:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $138
80106741:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106746:	e9 24 f6 ff ff       	jmp    80105d6f <alltraps>

8010674b <vector139>:
.globl vector139
vector139:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $139
8010674d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106752:	e9 18 f6 ff ff       	jmp    80105d6f <alltraps>

80106757 <vector140>:
.globl vector140
vector140:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $140
80106759:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010675e:	e9 0c f6 ff ff       	jmp    80105d6f <alltraps>

80106763 <vector141>:
.globl vector141
vector141:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $141
80106765:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010676a:	e9 00 f6 ff ff       	jmp    80105d6f <alltraps>

8010676f <vector142>:
.globl vector142
vector142:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $142
80106771:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106776:	e9 f4 f5 ff ff       	jmp    80105d6f <alltraps>

8010677b <vector143>:
.globl vector143
vector143:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $143
8010677d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106782:	e9 e8 f5 ff ff       	jmp    80105d6f <alltraps>

80106787 <vector144>:
.globl vector144
vector144:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $144
80106789:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010678e:	e9 dc f5 ff ff       	jmp    80105d6f <alltraps>

80106793 <vector145>:
.globl vector145
vector145:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $145
80106795:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010679a:	e9 d0 f5 ff ff       	jmp    80105d6f <alltraps>

8010679f <vector146>:
.globl vector146
vector146:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $146
801067a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801067a6:	e9 c4 f5 ff ff       	jmp    80105d6f <alltraps>

801067ab <vector147>:
.globl vector147
vector147:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $147
801067ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801067b2:	e9 b8 f5 ff ff       	jmp    80105d6f <alltraps>

801067b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $148
801067b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801067be:	e9 ac f5 ff ff       	jmp    80105d6f <alltraps>

801067c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $149
801067c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801067ca:	e9 a0 f5 ff ff       	jmp    80105d6f <alltraps>

801067cf <vector150>:
.globl vector150
vector150:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $150
801067d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801067d6:	e9 94 f5 ff ff       	jmp    80105d6f <alltraps>

801067db <vector151>:
.globl vector151
vector151:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $151
801067dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801067e2:	e9 88 f5 ff ff       	jmp    80105d6f <alltraps>

801067e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $152
801067e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801067ee:	e9 7c f5 ff ff       	jmp    80105d6f <alltraps>

801067f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $153
801067f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067fa:	e9 70 f5 ff ff       	jmp    80105d6f <alltraps>

801067ff <vector154>:
.globl vector154
vector154:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $154
80106801:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106806:	e9 64 f5 ff ff       	jmp    80105d6f <alltraps>

8010680b <vector155>:
.globl vector155
vector155:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $155
8010680d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106812:	e9 58 f5 ff ff       	jmp    80105d6f <alltraps>

80106817 <vector156>:
.globl vector156
vector156:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $156
80106819:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010681e:	e9 4c f5 ff ff       	jmp    80105d6f <alltraps>

80106823 <vector157>:
.globl vector157
vector157:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $157
80106825:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010682a:	e9 40 f5 ff ff       	jmp    80105d6f <alltraps>

8010682f <vector158>:
.globl vector158
vector158:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $158
80106831:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106836:	e9 34 f5 ff ff       	jmp    80105d6f <alltraps>

8010683b <vector159>:
.globl vector159
vector159:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $159
8010683d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106842:	e9 28 f5 ff ff       	jmp    80105d6f <alltraps>

80106847 <vector160>:
.globl vector160
vector160:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $160
80106849:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010684e:	e9 1c f5 ff ff       	jmp    80105d6f <alltraps>

80106853 <vector161>:
.globl vector161
vector161:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $161
80106855:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010685a:	e9 10 f5 ff ff       	jmp    80105d6f <alltraps>

8010685f <vector162>:
.globl vector162
vector162:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $162
80106861:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106866:	e9 04 f5 ff ff       	jmp    80105d6f <alltraps>

8010686b <vector163>:
.globl vector163
vector163:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $163
8010686d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106872:	e9 f8 f4 ff ff       	jmp    80105d6f <alltraps>

80106877 <vector164>:
.globl vector164
vector164:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $164
80106879:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010687e:	e9 ec f4 ff ff       	jmp    80105d6f <alltraps>

80106883 <vector165>:
.globl vector165
vector165:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $165
80106885:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010688a:	e9 e0 f4 ff ff       	jmp    80105d6f <alltraps>

8010688f <vector166>:
.globl vector166
vector166:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $166
80106891:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106896:	e9 d4 f4 ff ff       	jmp    80105d6f <alltraps>

8010689b <vector167>:
.globl vector167
vector167:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $167
8010689d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801068a2:	e9 c8 f4 ff ff       	jmp    80105d6f <alltraps>

801068a7 <vector168>:
.globl vector168
vector168:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $168
801068a9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801068ae:	e9 bc f4 ff ff       	jmp    80105d6f <alltraps>

801068b3 <vector169>:
.globl vector169
vector169:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $169
801068b5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801068ba:	e9 b0 f4 ff ff       	jmp    80105d6f <alltraps>

801068bf <vector170>:
.globl vector170
vector170:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $170
801068c1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801068c6:	e9 a4 f4 ff ff       	jmp    80105d6f <alltraps>

801068cb <vector171>:
.globl vector171
vector171:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $171
801068cd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801068d2:	e9 98 f4 ff ff       	jmp    80105d6f <alltraps>

801068d7 <vector172>:
.globl vector172
vector172:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $172
801068d9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801068de:	e9 8c f4 ff ff       	jmp    80105d6f <alltraps>

801068e3 <vector173>:
.globl vector173
vector173:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $173
801068e5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801068ea:	e9 80 f4 ff ff       	jmp    80105d6f <alltraps>

801068ef <vector174>:
.globl vector174
vector174:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $174
801068f1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068f6:	e9 74 f4 ff ff       	jmp    80105d6f <alltraps>

801068fb <vector175>:
.globl vector175
vector175:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $175
801068fd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106902:	e9 68 f4 ff ff       	jmp    80105d6f <alltraps>

80106907 <vector176>:
.globl vector176
vector176:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $176
80106909:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010690e:	e9 5c f4 ff ff       	jmp    80105d6f <alltraps>

80106913 <vector177>:
.globl vector177
vector177:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $177
80106915:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010691a:	e9 50 f4 ff ff       	jmp    80105d6f <alltraps>

8010691f <vector178>:
.globl vector178
vector178:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $178
80106921:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106926:	e9 44 f4 ff ff       	jmp    80105d6f <alltraps>

8010692b <vector179>:
.globl vector179
vector179:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $179
8010692d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106932:	e9 38 f4 ff ff       	jmp    80105d6f <alltraps>

80106937 <vector180>:
.globl vector180
vector180:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $180
80106939:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010693e:	e9 2c f4 ff ff       	jmp    80105d6f <alltraps>

80106943 <vector181>:
.globl vector181
vector181:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $181
80106945:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010694a:	e9 20 f4 ff ff       	jmp    80105d6f <alltraps>

8010694f <vector182>:
.globl vector182
vector182:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $182
80106951:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106956:	e9 14 f4 ff ff       	jmp    80105d6f <alltraps>

8010695b <vector183>:
.globl vector183
vector183:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $183
8010695d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106962:	e9 08 f4 ff ff       	jmp    80105d6f <alltraps>

80106967 <vector184>:
.globl vector184
vector184:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $184
80106969:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010696e:	e9 fc f3 ff ff       	jmp    80105d6f <alltraps>

80106973 <vector185>:
.globl vector185
vector185:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $185
80106975:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010697a:	e9 f0 f3 ff ff       	jmp    80105d6f <alltraps>

8010697f <vector186>:
.globl vector186
vector186:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $186
80106981:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106986:	e9 e4 f3 ff ff       	jmp    80105d6f <alltraps>

8010698b <vector187>:
.globl vector187
vector187:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $187
8010698d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106992:	e9 d8 f3 ff ff       	jmp    80105d6f <alltraps>

80106997 <vector188>:
.globl vector188
vector188:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $188
80106999:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010699e:	e9 cc f3 ff ff       	jmp    80105d6f <alltraps>

801069a3 <vector189>:
.globl vector189
vector189:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $189
801069a5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801069aa:	e9 c0 f3 ff ff       	jmp    80105d6f <alltraps>

801069af <vector190>:
.globl vector190
vector190:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $190
801069b1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801069b6:	e9 b4 f3 ff ff       	jmp    80105d6f <alltraps>

801069bb <vector191>:
.globl vector191
vector191:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $191
801069bd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801069c2:	e9 a8 f3 ff ff       	jmp    80105d6f <alltraps>

801069c7 <vector192>:
.globl vector192
vector192:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $192
801069c9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801069ce:	e9 9c f3 ff ff       	jmp    80105d6f <alltraps>

801069d3 <vector193>:
.globl vector193
vector193:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $193
801069d5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801069da:	e9 90 f3 ff ff       	jmp    80105d6f <alltraps>

801069df <vector194>:
.globl vector194
vector194:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $194
801069e1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801069e6:	e9 84 f3 ff ff       	jmp    80105d6f <alltraps>

801069eb <vector195>:
.globl vector195
vector195:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $195
801069ed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069f2:	e9 78 f3 ff ff       	jmp    80105d6f <alltraps>

801069f7 <vector196>:
.globl vector196
vector196:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $196
801069f9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069fe:	e9 6c f3 ff ff       	jmp    80105d6f <alltraps>

80106a03 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $197
80106a05:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a0a:	e9 60 f3 ff ff       	jmp    80105d6f <alltraps>

80106a0f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $198
80106a11:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a16:	e9 54 f3 ff ff       	jmp    80105d6f <alltraps>

80106a1b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $199
80106a1d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a22:	e9 48 f3 ff ff       	jmp    80105d6f <alltraps>

80106a27 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $200
80106a29:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a2e:	e9 3c f3 ff ff       	jmp    80105d6f <alltraps>

80106a33 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $201
80106a35:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a3a:	e9 30 f3 ff ff       	jmp    80105d6f <alltraps>

80106a3f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $202
80106a41:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a46:	e9 24 f3 ff ff       	jmp    80105d6f <alltraps>

80106a4b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $203
80106a4d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a52:	e9 18 f3 ff ff       	jmp    80105d6f <alltraps>

80106a57 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $204
80106a59:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a5e:	e9 0c f3 ff ff       	jmp    80105d6f <alltraps>

80106a63 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $205
80106a65:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a6a:	e9 00 f3 ff ff       	jmp    80105d6f <alltraps>

80106a6f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $206
80106a71:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a76:	e9 f4 f2 ff ff       	jmp    80105d6f <alltraps>

80106a7b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $207
80106a7d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a82:	e9 e8 f2 ff ff       	jmp    80105d6f <alltraps>

80106a87 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $208
80106a89:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a8e:	e9 dc f2 ff ff       	jmp    80105d6f <alltraps>

80106a93 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $209
80106a95:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a9a:	e9 d0 f2 ff ff       	jmp    80105d6f <alltraps>

80106a9f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $210
80106aa1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106aa6:	e9 c4 f2 ff ff       	jmp    80105d6f <alltraps>

80106aab <vector211>:
.globl vector211
vector211:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $211
80106aad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ab2:	e9 b8 f2 ff ff       	jmp    80105d6f <alltraps>

80106ab7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $212
80106ab9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106abe:	e9 ac f2 ff ff       	jmp    80105d6f <alltraps>

80106ac3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $213
80106ac5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106aca:	e9 a0 f2 ff ff       	jmp    80105d6f <alltraps>

80106acf <vector214>:
.globl vector214
vector214:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $214
80106ad1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ad6:	e9 94 f2 ff ff       	jmp    80105d6f <alltraps>

80106adb <vector215>:
.globl vector215
vector215:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $215
80106add:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ae2:	e9 88 f2 ff ff       	jmp    80105d6f <alltraps>

80106ae7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $216
80106ae9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106aee:	e9 7c f2 ff ff       	jmp    80105d6f <alltraps>

80106af3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $217
80106af5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106afa:	e9 70 f2 ff ff       	jmp    80105d6f <alltraps>

80106aff <vector218>:
.globl vector218
vector218:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $218
80106b01:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b06:	e9 64 f2 ff ff       	jmp    80105d6f <alltraps>

80106b0b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $219
80106b0d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b12:	e9 58 f2 ff ff       	jmp    80105d6f <alltraps>

80106b17 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $220
80106b19:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b1e:	e9 4c f2 ff ff       	jmp    80105d6f <alltraps>

80106b23 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $221
80106b25:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b2a:	e9 40 f2 ff ff       	jmp    80105d6f <alltraps>

80106b2f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $222
80106b31:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b36:	e9 34 f2 ff ff       	jmp    80105d6f <alltraps>

80106b3b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $223
80106b3d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b42:	e9 28 f2 ff ff       	jmp    80105d6f <alltraps>

80106b47 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $224
80106b49:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b4e:	e9 1c f2 ff ff       	jmp    80105d6f <alltraps>

80106b53 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $225
80106b55:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b5a:	e9 10 f2 ff ff       	jmp    80105d6f <alltraps>

80106b5f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $226
80106b61:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b66:	e9 04 f2 ff ff       	jmp    80105d6f <alltraps>

80106b6b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $227
80106b6d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b72:	e9 f8 f1 ff ff       	jmp    80105d6f <alltraps>

80106b77 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $228
80106b79:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b7e:	e9 ec f1 ff ff       	jmp    80105d6f <alltraps>

80106b83 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $229
80106b85:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b8a:	e9 e0 f1 ff ff       	jmp    80105d6f <alltraps>

80106b8f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $230
80106b91:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b96:	e9 d4 f1 ff ff       	jmp    80105d6f <alltraps>

80106b9b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $231
80106b9d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ba2:	e9 c8 f1 ff ff       	jmp    80105d6f <alltraps>

80106ba7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $232
80106ba9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106bae:	e9 bc f1 ff ff       	jmp    80105d6f <alltraps>

80106bb3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $233
80106bb5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106bba:	e9 b0 f1 ff ff       	jmp    80105d6f <alltraps>

80106bbf <vector234>:
.globl vector234
vector234:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $234
80106bc1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106bc6:	e9 a4 f1 ff ff       	jmp    80105d6f <alltraps>

80106bcb <vector235>:
.globl vector235
vector235:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $235
80106bcd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106bd2:	e9 98 f1 ff ff       	jmp    80105d6f <alltraps>

80106bd7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $236
80106bd9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106bde:	e9 8c f1 ff ff       	jmp    80105d6f <alltraps>

80106be3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $237
80106be5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106bea:	e9 80 f1 ff ff       	jmp    80105d6f <alltraps>

80106bef <vector238>:
.globl vector238
vector238:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $238
80106bf1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106bf6:	e9 74 f1 ff ff       	jmp    80105d6f <alltraps>

80106bfb <vector239>:
.globl vector239
vector239:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $239
80106bfd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c02:	e9 68 f1 ff ff       	jmp    80105d6f <alltraps>

80106c07 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $240
80106c09:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c0e:	e9 5c f1 ff ff       	jmp    80105d6f <alltraps>

80106c13 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $241
80106c15:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c1a:	e9 50 f1 ff ff       	jmp    80105d6f <alltraps>

80106c1f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $242
80106c21:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c26:	e9 44 f1 ff ff       	jmp    80105d6f <alltraps>

80106c2b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $243
80106c2d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c32:	e9 38 f1 ff ff       	jmp    80105d6f <alltraps>

80106c37 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $244
80106c39:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c3e:	e9 2c f1 ff ff       	jmp    80105d6f <alltraps>

80106c43 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $245
80106c45:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c4a:	e9 20 f1 ff ff       	jmp    80105d6f <alltraps>

80106c4f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $246
80106c51:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c56:	e9 14 f1 ff ff       	jmp    80105d6f <alltraps>

80106c5b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $247
80106c5d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c62:	e9 08 f1 ff ff       	jmp    80105d6f <alltraps>

80106c67 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $248
80106c69:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c6e:	e9 fc f0 ff ff       	jmp    80105d6f <alltraps>

80106c73 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $249
80106c75:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c7a:	e9 f0 f0 ff ff       	jmp    80105d6f <alltraps>

80106c7f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $250
80106c81:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c86:	e9 e4 f0 ff ff       	jmp    80105d6f <alltraps>

80106c8b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $251
80106c8d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c92:	e9 d8 f0 ff ff       	jmp    80105d6f <alltraps>

80106c97 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $252
80106c99:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c9e:	e9 cc f0 ff ff       	jmp    80105d6f <alltraps>

80106ca3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $253
80106ca5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106caa:	e9 c0 f0 ff ff       	jmp    80105d6f <alltraps>

80106caf <vector254>:
.globl vector254
vector254:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $254
80106cb1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106cb6:	e9 b4 f0 ff ff       	jmp    80105d6f <alltraps>

80106cbb <vector255>:
.globl vector255
vector255:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $255
80106cbd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106cc2:	e9 a8 f0 ff ff       	jmp    80105d6f <alltraps>
80106cc7:	66 90                	xchg   %ax,%ax
80106cc9:	66 90                	xchg   %ax,%ax
80106ccb:	66 90                	xchg   %ax,%ax
80106ccd:	66 90                	xchg   %ax,%ax
80106ccf:	90                   	nop

80106cd0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
80106cd5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106cd6:	89 d3                	mov    %edx,%ebx
{
80106cd8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106cda:	c1 eb 16             	shr    $0x16,%ebx
80106cdd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106ce0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ce3:	8b 06                	mov    (%esi),%eax
80106ce5:	a8 01                	test   $0x1,%al
80106ce7:	74 27                	je     80106d10 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ce9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cee:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106cf4:	c1 ef 0a             	shr    $0xa,%edi
}
80106cf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106cfa:	89 fa                	mov    %edi,%edx
80106cfc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d02:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106d05:	5b                   	pop    %ebx
80106d06:	5e                   	pop    %esi
80106d07:	5f                   	pop    %edi
80106d08:	5d                   	pop    %ebp
80106d09:	c3                   	ret    
80106d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d10:	85 c9                	test   %ecx,%ecx
80106d12:	74 2c                	je     80106d40 <walkpgdir+0x70>
80106d14:	e8 e7 b7 ff ff       	call   80102500 <kalloc>
80106d19:	85 c0                	test   %eax,%eax
80106d1b:	89 c3                	mov    %eax,%ebx
80106d1d:	74 21                	je     80106d40 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106d1f:	83 ec 04             	sub    $0x4,%esp
80106d22:	68 00 10 00 00       	push   $0x1000
80106d27:	6a 00                	push   $0x0
80106d29:	50                   	push   %eax
80106d2a:	e8 81 dd ff ff       	call   80104ab0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d2f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d35:	83 c4 10             	add    $0x10,%esp
80106d38:	83 c8 07             	or     $0x7,%eax
80106d3b:	89 06                	mov    %eax,(%esi)
80106d3d:	eb b5                	jmp    80106cf4 <walkpgdir+0x24>
80106d3f:	90                   	nop
}
80106d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106d43:	31 c0                	xor    %eax,%eax
}
80106d45:	5b                   	pop    %ebx
80106d46:	5e                   	pop    %esi
80106d47:	5f                   	pop    %edi
80106d48:	5d                   	pop    %ebp
80106d49:	c3                   	ret    
80106d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d50 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	57                   	push   %edi
80106d54:	56                   	push   %esi
80106d55:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106d56:	89 d3                	mov    %edx,%ebx
80106d58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106d5e:	83 ec 1c             	sub    $0x1c,%esp
80106d61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d68:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d70:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d73:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d76:	29 df                	sub    %ebx,%edi
80106d78:	83 c8 01             	or     $0x1,%eax
80106d7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d7e:	eb 15                	jmp    80106d95 <mappages+0x45>
    if(*pte & PTE_P)
80106d80:	f6 00 01             	testb  $0x1,(%eax)
80106d83:	75 45                	jne    80106dca <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106d85:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106d88:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106d8b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d8d:	74 31                	je     80106dc0 <mappages+0x70>
      break;
    a += PGSIZE;
80106d8f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d98:	b9 01 00 00 00       	mov    $0x1,%ecx
80106d9d:	89 da                	mov    %ebx,%edx
80106d9f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106da2:	e8 29 ff ff ff       	call   80106cd0 <walkpgdir>
80106da7:	85 c0                	test   %eax,%eax
80106da9:	75 d5                	jne    80106d80 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106dae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106db3:	5b                   	pop    %ebx
80106db4:	5e                   	pop    %esi
80106db5:	5f                   	pop    %edi
80106db6:	5d                   	pop    %ebp
80106db7:	c3                   	ret    
80106db8:	90                   	nop
80106db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106dc3:	31 c0                	xor    %eax,%eax
}
80106dc5:	5b                   	pop    %ebx
80106dc6:	5e                   	pop    %esi
80106dc7:	5f                   	pop    %edi
80106dc8:	5d                   	pop    %ebp
80106dc9:	c3                   	ret    
      panic("remap");
80106dca:	83 ec 0c             	sub    $0xc,%esp
80106dcd:	68 94 7f 10 80       	push   $0x80107f94
80106dd2:	e8 b9 95 ff ff       	call   80100390 <panic>
80106dd7:	89 f6                	mov    %esi,%esi
80106dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106de0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	57                   	push   %edi
80106de4:	56                   	push   %esi
80106de5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106de6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106dec:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106dee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106df4:	83 ec 1c             	sub    $0x1c,%esp
80106df7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106dfa:	39 d3                	cmp    %edx,%ebx
80106dfc:	73 66                	jae    80106e64 <deallocuvm.part.0+0x84>
80106dfe:	89 d6                	mov    %edx,%esi
80106e00:	eb 3d                	jmp    80106e3f <deallocuvm.part.0+0x5f>
80106e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106e08:	8b 10                	mov    (%eax),%edx
80106e0a:	f6 c2 01             	test   $0x1,%dl
80106e0d:	74 26                	je     80106e35 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106e0f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106e15:	74 58                	je     80106e6f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106e17:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106e1a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106e20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106e23:	52                   	push   %edx
80106e24:	e8 27 b5 ff ff       	call   80102350 <kfree>
      *pte = 0;
80106e29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e2c:	83 c4 10             	add    $0x10,%esp
80106e2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106e35:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e3b:	39 f3                	cmp    %esi,%ebx
80106e3d:	73 25                	jae    80106e64 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106e3f:	31 c9                	xor    %ecx,%ecx
80106e41:	89 da                	mov    %ebx,%edx
80106e43:	89 f8                	mov    %edi,%eax
80106e45:	e8 86 fe ff ff       	call   80106cd0 <walkpgdir>
    if(!pte)
80106e4a:	85 c0                	test   %eax,%eax
80106e4c:	75 ba                	jne    80106e08 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106e4e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106e54:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106e5a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e60:	39 f3                	cmp    %esi,%ebx
80106e62:	72 db                	jb     80106e3f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106e64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e6a:	5b                   	pop    %ebx
80106e6b:	5e                   	pop    %esi
80106e6c:	5f                   	pop    %edi
80106e6d:	5d                   	pop    %ebp
80106e6e:	c3                   	ret    
        panic("kfree");
80106e6f:	83 ec 0c             	sub    $0xc,%esp
80106e72:	68 66 78 10 80       	push   $0x80107866
80106e77:	e8 14 95 ff ff       	call   80100390 <panic>
80106e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e80 <seginit>:
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e86:	e8 75 ca ff ff       	call   80103900 <cpuid>
80106e8b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106e91:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106e96:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e9a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80106ea1:	ff 00 00 
80106ea4:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
80106eab:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106eae:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80106eb5:	ff 00 00 
80106eb8:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80106ebf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ec2:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80106ec9:	ff 00 00 
80106ecc:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80106ed3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ed6:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80106edd:	ff 00 00 
80106ee0:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80106ee7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106eea:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80106eef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ef3:	c1 e8 10             	shr    $0x10,%eax
80106ef6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106efa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106efd:	0f 01 10             	lgdtl  (%eax)
}
80106f00:	c9                   	leave  
80106f01:	c3                   	ret    
80106f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f10 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f10:	a1 a4 89 11 80       	mov    0x801189a4,%eax
{
80106f15:	55                   	push   %ebp
80106f16:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f18:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f1d:	0f 22 d8             	mov    %eax,%cr3
}
80106f20:	5d                   	pop    %ebp
80106f21:	c3                   	ret    
80106f22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f30 <switchuvm>:
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	57                   	push   %edi
80106f34:	56                   	push   %esi
80106f35:	53                   	push   %ebx
80106f36:	83 ec 1c             	sub    $0x1c,%esp
80106f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106f3c:	85 db                	test   %ebx,%ebx
80106f3e:	0f 84 cb 00 00 00    	je     8010700f <switchuvm+0xdf>
  if(p->kstack == 0)
80106f44:	8b 43 08             	mov    0x8(%ebx),%eax
80106f47:	85 c0                	test   %eax,%eax
80106f49:	0f 84 da 00 00 00    	je     80107029 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f4f:	8b 43 04             	mov    0x4(%ebx),%eax
80106f52:	85 c0                	test   %eax,%eax
80106f54:	0f 84 c2 00 00 00    	je     8010701c <switchuvm+0xec>
  pushcli();
80106f5a:	e8 71 d9 ff ff       	call   801048d0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f5f:	e8 1c c9 ff ff       	call   80103880 <mycpu>
80106f64:	89 c6                	mov    %eax,%esi
80106f66:	e8 15 c9 ff ff       	call   80103880 <mycpu>
80106f6b:	89 c7                	mov    %eax,%edi
80106f6d:	e8 0e c9 ff ff       	call   80103880 <mycpu>
80106f72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f75:	83 c7 08             	add    $0x8,%edi
80106f78:	e8 03 c9 ff ff       	call   80103880 <mycpu>
80106f7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f80:	83 c0 08             	add    $0x8,%eax
80106f83:	ba 67 00 00 00       	mov    $0x67,%edx
80106f88:	c1 e8 18             	shr    $0x18,%eax
80106f8b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106f92:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106f99:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f9f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fa4:	83 c1 08             	add    $0x8,%ecx
80106fa7:	c1 e9 10             	shr    $0x10,%ecx
80106faa:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106fb0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106fb5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fbc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106fc1:	e8 ba c8 ff ff       	call   80103880 <mycpu>
80106fc6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fcd:	e8 ae c8 ff ff       	call   80103880 <mycpu>
80106fd2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106fd6:	8b 73 08             	mov    0x8(%ebx),%esi
80106fd9:	e8 a2 c8 ff ff       	call   80103880 <mycpu>
80106fde:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106fe4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fe7:	e8 94 c8 ff ff       	call   80103880 <mycpu>
80106fec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ff0:	b8 28 00 00 00       	mov    $0x28,%eax
80106ff5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ff8:	8b 43 04             	mov    0x4(%ebx),%eax
80106ffb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107000:	0f 22 d8             	mov    %eax,%cr3
}
80107003:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107006:	5b                   	pop    %ebx
80107007:	5e                   	pop    %esi
80107008:	5f                   	pop    %edi
80107009:	5d                   	pop    %ebp
  popcli();
8010700a:	e9 01 d9 ff ff       	jmp    80104910 <popcli>
    panic("switchuvm: no process");
8010700f:	83 ec 0c             	sub    $0xc,%esp
80107012:	68 9a 7f 10 80       	push   $0x80107f9a
80107017:	e8 74 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010701c:	83 ec 0c             	sub    $0xc,%esp
8010701f:	68 c5 7f 10 80       	push   $0x80107fc5
80107024:	e8 67 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107029:	83 ec 0c             	sub    $0xc,%esp
8010702c:	68 b0 7f 10 80       	push   $0x80107fb0
80107031:	e8 5a 93 ff ff       	call   80100390 <panic>
80107036:	8d 76 00             	lea    0x0(%esi),%esi
80107039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107040 <inituvm>:
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 1c             	sub    $0x1c,%esp
80107049:	8b 75 10             	mov    0x10(%ebp),%esi
8010704c:	8b 45 08             	mov    0x8(%ebp),%eax
8010704f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107052:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010705b:	77 49                	ja     801070a6 <inituvm+0x66>
  mem = kalloc();
8010705d:	e8 9e b4 ff ff       	call   80102500 <kalloc>
  memset(mem, 0, PGSIZE);
80107062:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107065:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107067:	68 00 10 00 00       	push   $0x1000
8010706c:	6a 00                	push   $0x0
8010706e:	50                   	push   %eax
8010706f:	e8 3c da ff ff       	call   80104ab0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107074:	58                   	pop    %eax
80107075:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010707b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107080:	5a                   	pop    %edx
80107081:	6a 06                	push   $0x6
80107083:	50                   	push   %eax
80107084:	31 d2                	xor    %edx,%edx
80107086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107089:	e8 c2 fc ff ff       	call   80106d50 <mappages>
  memmove(mem, init, sz);
8010708e:	89 75 10             	mov    %esi,0x10(%ebp)
80107091:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107094:	83 c4 10             	add    $0x10,%esp
80107097:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010709a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010709d:	5b                   	pop    %ebx
8010709e:	5e                   	pop    %esi
8010709f:	5f                   	pop    %edi
801070a0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801070a1:	e9 ba da ff ff       	jmp    80104b60 <memmove>
    panic("inituvm: more than a page");
801070a6:	83 ec 0c             	sub    $0xc,%esp
801070a9:	68 d9 7f 10 80       	push   $0x80107fd9
801070ae:	e8 dd 92 ff ff       	call   80100390 <panic>
801070b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070c0 <loaduvm>:
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801070c9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801070d0:	0f 85 91 00 00 00    	jne    80107167 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801070d6:	8b 75 18             	mov    0x18(%ebp),%esi
801070d9:	31 db                	xor    %ebx,%ebx
801070db:	85 f6                	test   %esi,%esi
801070dd:	75 1a                	jne    801070f9 <loaduvm+0x39>
801070df:	eb 6f                	jmp    80107150 <loaduvm+0x90>
801070e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070ee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801070f4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801070f7:	76 57                	jbe    80107150 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801070fc:	8b 45 08             	mov    0x8(%ebp),%eax
801070ff:	31 c9                	xor    %ecx,%ecx
80107101:	01 da                	add    %ebx,%edx
80107103:	e8 c8 fb ff ff       	call   80106cd0 <walkpgdir>
80107108:	85 c0                	test   %eax,%eax
8010710a:	74 4e                	je     8010715a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010710c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010710e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107111:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107116:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010711b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107121:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107124:	01 d9                	add    %ebx,%ecx
80107126:	05 00 00 00 80       	add    $0x80000000,%eax
8010712b:	57                   	push   %edi
8010712c:	51                   	push   %ecx
8010712d:	50                   	push   %eax
8010712e:	ff 75 10             	pushl  0x10(%ebp)
80107131:	e8 5a a8 ff ff       	call   80101990 <readi>
80107136:	83 c4 10             	add    $0x10,%esp
80107139:	39 f8                	cmp    %edi,%eax
8010713b:	74 ab                	je     801070e8 <loaduvm+0x28>
}
8010713d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107145:	5b                   	pop    %ebx
80107146:	5e                   	pop    %esi
80107147:	5f                   	pop    %edi
80107148:	5d                   	pop    %ebp
80107149:	c3                   	ret    
8010714a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107153:	31 c0                	xor    %eax,%eax
}
80107155:	5b                   	pop    %ebx
80107156:	5e                   	pop    %esi
80107157:	5f                   	pop    %edi
80107158:	5d                   	pop    %ebp
80107159:	c3                   	ret    
      panic("loaduvm: address should exist");
8010715a:	83 ec 0c             	sub    $0xc,%esp
8010715d:	68 f3 7f 10 80       	push   $0x80107ff3
80107162:	e8 29 92 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107167:	83 ec 0c             	sub    $0xc,%esp
8010716a:	68 94 80 10 80       	push   $0x80108094
8010716f:	e8 1c 92 ff ff       	call   80100390 <panic>
80107174:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010717a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107180 <allocuvm>:
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
80107185:	53                   	push   %ebx
80107186:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107189:	8b 7d 10             	mov    0x10(%ebp),%edi
8010718c:	85 ff                	test   %edi,%edi
8010718e:	0f 88 8e 00 00 00    	js     80107222 <allocuvm+0xa2>
  if(newsz < oldsz)
80107194:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107197:	0f 82 93 00 00 00    	jb     80107230 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010719d:	8b 45 0c             	mov    0xc(%ebp),%eax
801071a0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801071a6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801071ac:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801071af:	0f 86 7e 00 00 00    	jbe    80107233 <allocuvm+0xb3>
801071b5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801071b8:	8b 7d 08             	mov    0x8(%ebp),%edi
801071bb:	eb 42                	jmp    801071ff <allocuvm+0x7f>
801071bd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801071c0:	83 ec 04             	sub    $0x4,%esp
801071c3:	68 00 10 00 00       	push   $0x1000
801071c8:	6a 00                	push   $0x0
801071ca:	50                   	push   %eax
801071cb:	e8 e0 d8 ff ff       	call   80104ab0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801071d0:	58                   	pop    %eax
801071d1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801071d7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071dc:	5a                   	pop    %edx
801071dd:	6a 06                	push   $0x6
801071df:	50                   	push   %eax
801071e0:	89 da                	mov    %ebx,%edx
801071e2:	89 f8                	mov    %edi,%eax
801071e4:	e8 67 fb ff ff       	call   80106d50 <mappages>
801071e9:	83 c4 10             	add    $0x10,%esp
801071ec:	85 c0                	test   %eax,%eax
801071ee:	78 50                	js     80107240 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801071f0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071f6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801071f9:	0f 86 81 00 00 00    	jbe    80107280 <allocuvm+0x100>
    mem = kalloc();
801071ff:	e8 fc b2 ff ff       	call   80102500 <kalloc>
    if(mem == 0){
80107204:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107206:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107208:	75 b6                	jne    801071c0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010720a:	83 ec 0c             	sub    $0xc,%esp
8010720d:	68 11 80 10 80       	push   $0x80108011
80107212:	e8 49 94 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107217:	83 c4 10             	add    $0x10,%esp
8010721a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010721d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107220:	77 6e                	ja     80107290 <allocuvm+0x110>
}
80107222:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107225:	31 ff                	xor    %edi,%edi
}
80107227:	89 f8                	mov    %edi,%eax
80107229:	5b                   	pop    %ebx
8010722a:	5e                   	pop    %esi
8010722b:	5f                   	pop    %edi
8010722c:	5d                   	pop    %ebp
8010722d:	c3                   	ret    
8010722e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107230:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107233:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107236:	89 f8                	mov    %edi,%eax
80107238:	5b                   	pop    %ebx
80107239:	5e                   	pop    %esi
8010723a:	5f                   	pop    %edi
8010723b:	5d                   	pop    %ebp
8010723c:	c3                   	ret    
8010723d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107240:	83 ec 0c             	sub    $0xc,%esp
80107243:	68 29 80 10 80       	push   $0x80108029
80107248:	e8 13 94 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010724d:	83 c4 10             	add    $0x10,%esp
80107250:	8b 45 0c             	mov    0xc(%ebp),%eax
80107253:	39 45 10             	cmp    %eax,0x10(%ebp)
80107256:	76 0d                	jbe    80107265 <allocuvm+0xe5>
80107258:	89 c1                	mov    %eax,%ecx
8010725a:	8b 55 10             	mov    0x10(%ebp),%edx
8010725d:	8b 45 08             	mov    0x8(%ebp),%eax
80107260:	e8 7b fb ff ff       	call   80106de0 <deallocuvm.part.0>
      kfree(mem);
80107265:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107268:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010726a:	56                   	push   %esi
8010726b:	e8 e0 b0 ff ff       	call   80102350 <kfree>
      return 0;
80107270:	83 c4 10             	add    $0x10,%esp
}
80107273:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107276:	89 f8                	mov    %edi,%eax
80107278:	5b                   	pop    %ebx
80107279:	5e                   	pop    %esi
8010727a:	5f                   	pop    %edi
8010727b:	5d                   	pop    %ebp
8010727c:	c3                   	ret    
8010727d:	8d 76 00             	lea    0x0(%esi),%esi
80107280:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107283:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107286:	5b                   	pop    %ebx
80107287:	89 f8                	mov    %edi,%eax
80107289:	5e                   	pop    %esi
8010728a:	5f                   	pop    %edi
8010728b:	5d                   	pop    %ebp
8010728c:	c3                   	ret    
8010728d:	8d 76 00             	lea    0x0(%esi),%esi
80107290:	89 c1                	mov    %eax,%ecx
80107292:	8b 55 10             	mov    0x10(%ebp),%edx
80107295:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107298:	31 ff                	xor    %edi,%edi
8010729a:	e8 41 fb ff ff       	call   80106de0 <deallocuvm.part.0>
8010729f:	eb 92                	jmp    80107233 <allocuvm+0xb3>
801072a1:	eb 0d                	jmp    801072b0 <deallocuvm>
801072a3:	90                   	nop
801072a4:	90                   	nop
801072a5:	90                   	nop
801072a6:	90                   	nop
801072a7:	90                   	nop
801072a8:	90                   	nop
801072a9:	90                   	nop
801072aa:	90                   	nop
801072ab:	90                   	nop
801072ac:	90                   	nop
801072ad:	90                   	nop
801072ae:	90                   	nop
801072af:	90                   	nop

801072b0 <deallocuvm>:
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801072b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801072b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801072bc:	39 d1                	cmp    %edx,%ecx
801072be:	73 10                	jae    801072d0 <deallocuvm+0x20>
}
801072c0:	5d                   	pop    %ebp
801072c1:	e9 1a fb ff ff       	jmp    80106de0 <deallocuvm.part.0>
801072c6:	8d 76 00             	lea    0x0(%esi),%esi
801072c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801072d0:	89 d0                	mov    %edx,%eax
801072d2:	5d                   	pop    %ebp
801072d3:	c3                   	ret    
801072d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801072e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	57                   	push   %edi
801072e4:	56                   	push   %esi
801072e5:	53                   	push   %ebx
801072e6:	83 ec 0c             	sub    $0xc,%esp
801072e9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801072ec:	85 f6                	test   %esi,%esi
801072ee:	74 59                	je     80107349 <freevm+0x69>
801072f0:	31 c9                	xor    %ecx,%ecx
801072f2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801072f7:	89 f0                	mov    %esi,%eax
801072f9:	e8 e2 fa ff ff       	call   80106de0 <deallocuvm.part.0>
801072fe:	89 f3                	mov    %esi,%ebx
80107300:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107306:	eb 0f                	jmp    80107317 <freevm+0x37>
80107308:	90                   	nop
80107309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107310:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107313:	39 fb                	cmp    %edi,%ebx
80107315:	74 23                	je     8010733a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107317:	8b 03                	mov    (%ebx),%eax
80107319:	a8 01                	test   $0x1,%al
8010731b:	74 f3                	je     80107310 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010731d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107322:	83 ec 0c             	sub    $0xc,%esp
80107325:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107328:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010732d:	50                   	push   %eax
8010732e:	e8 1d b0 ff ff       	call   80102350 <kfree>
80107333:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107336:	39 fb                	cmp    %edi,%ebx
80107338:	75 dd                	jne    80107317 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010733a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010733d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107340:	5b                   	pop    %ebx
80107341:	5e                   	pop    %esi
80107342:	5f                   	pop    %edi
80107343:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107344:	e9 07 b0 ff ff       	jmp    80102350 <kfree>
    panic("freevm: no pgdir");
80107349:	83 ec 0c             	sub    $0xc,%esp
8010734c:	68 45 80 10 80       	push   $0x80108045
80107351:	e8 3a 90 ff ff       	call   80100390 <panic>
80107356:	8d 76 00             	lea    0x0(%esi),%esi
80107359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107360 <setupkvm>:
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	56                   	push   %esi
80107364:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107365:	e8 96 b1 ff ff       	call   80102500 <kalloc>
8010736a:	85 c0                	test   %eax,%eax
8010736c:	89 c6                	mov    %eax,%esi
8010736e:	74 42                	je     801073b2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107370:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107373:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107378:	68 00 10 00 00       	push   $0x1000
8010737d:	6a 00                	push   $0x0
8010737f:	50                   	push   %eax
80107380:	e8 2b d7 ff ff       	call   80104ab0 <memset>
80107385:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107388:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010738b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010738e:	83 ec 08             	sub    $0x8,%esp
80107391:	8b 13                	mov    (%ebx),%edx
80107393:	ff 73 0c             	pushl  0xc(%ebx)
80107396:	50                   	push   %eax
80107397:	29 c1                	sub    %eax,%ecx
80107399:	89 f0                	mov    %esi,%eax
8010739b:	e8 b0 f9 ff ff       	call   80106d50 <mappages>
801073a0:	83 c4 10             	add    $0x10,%esp
801073a3:	85 c0                	test   %eax,%eax
801073a5:	78 19                	js     801073c0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073a7:	83 c3 10             	add    $0x10,%ebx
801073aa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801073b0:	75 d6                	jne    80107388 <setupkvm+0x28>
}
801073b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073b5:	89 f0                	mov    %esi,%eax
801073b7:	5b                   	pop    %ebx
801073b8:	5e                   	pop    %esi
801073b9:	5d                   	pop    %ebp
801073ba:	c3                   	ret    
801073bb:	90                   	nop
801073bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801073c0:	83 ec 0c             	sub    $0xc,%esp
801073c3:	56                   	push   %esi
      return 0;
801073c4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801073c6:	e8 15 ff ff ff       	call   801072e0 <freevm>
      return 0;
801073cb:	83 c4 10             	add    $0x10,%esp
}
801073ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073d1:	89 f0                	mov    %esi,%eax
801073d3:	5b                   	pop    %ebx
801073d4:	5e                   	pop    %esi
801073d5:	5d                   	pop    %ebp
801073d6:	c3                   	ret    
801073d7:	89 f6                	mov    %esi,%esi
801073d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073e0 <kvmalloc>:
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801073e6:	e8 75 ff ff ff       	call   80107360 <setupkvm>
801073eb:	a3 a4 89 11 80       	mov    %eax,0x801189a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073f0:	05 00 00 00 80       	add    $0x80000000,%eax
801073f5:	0f 22 d8             	mov    %eax,%cr3
}
801073f8:	c9                   	leave  
801073f9:	c3                   	ret    
801073fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107400 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107400:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107401:	31 c9                	xor    %ecx,%ecx
{
80107403:	89 e5                	mov    %esp,%ebp
80107405:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107408:	8b 55 0c             	mov    0xc(%ebp),%edx
8010740b:	8b 45 08             	mov    0x8(%ebp),%eax
8010740e:	e8 bd f8 ff ff       	call   80106cd0 <walkpgdir>
  if(pte == 0)
80107413:	85 c0                	test   %eax,%eax
80107415:	74 05                	je     8010741c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107417:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010741a:	c9                   	leave  
8010741b:	c3                   	ret    
    panic("clearpteu");
8010741c:	83 ec 0c             	sub    $0xc,%esp
8010741f:	68 56 80 10 80       	push   $0x80108056
80107424:	e8 67 8f ff ff       	call   80100390 <panic>
80107429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107430 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	57                   	push   %edi
80107434:	56                   	push   %esi
80107435:	53                   	push   %ebx
80107436:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107439:	e8 22 ff ff ff       	call   80107360 <setupkvm>
8010743e:	85 c0                	test   %eax,%eax
80107440:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107443:	0f 84 9f 00 00 00    	je     801074e8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107449:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010744c:	85 c9                	test   %ecx,%ecx
8010744e:	0f 84 94 00 00 00    	je     801074e8 <copyuvm+0xb8>
80107454:	31 ff                	xor    %edi,%edi
80107456:	eb 4a                	jmp    801074a2 <copyuvm+0x72>
80107458:	90                   	nop
80107459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107460:	83 ec 04             	sub    $0x4,%esp
80107463:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107469:	68 00 10 00 00       	push   $0x1000
8010746e:	53                   	push   %ebx
8010746f:	50                   	push   %eax
80107470:	e8 eb d6 ff ff       	call   80104b60 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107475:	58                   	pop    %eax
80107476:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010747c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107481:	5a                   	pop    %edx
80107482:	ff 75 e4             	pushl  -0x1c(%ebp)
80107485:	50                   	push   %eax
80107486:	89 fa                	mov    %edi,%edx
80107488:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010748b:	e8 c0 f8 ff ff       	call   80106d50 <mappages>
80107490:	83 c4 10             	add    $0x10,%esp
80107493:	85 c0                	test   %eax,%eax
80107495:	78 61                	js     801074f8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107497:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010749d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801074a0:	76 46                	jbe    801074e8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801074a2:	8b 45 08             	mov    0x8(%ebp),%eax
801074a5:	31 c9                	xor    %ecx,%ecx
801074a7:	89 fa                	mov    %edi,%edx
801074a9:	e8 22 f8 ff ff       	call   80106cd0 <walkpgdir>
801074ae:	85 c0                	test   %eax,%eax
801074b0:	74 61                	je     80107513 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801074b2:	8b 00                	mov    (%eax),%eax
801074b4:	a8 01                	test   $0x1,%al
801074b6:	74 4e                	je     80107506 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801074b8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801074ba:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801074bf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801074c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801074c8:	e8 33 b0 ff ff       	call   80102500 <kalloc>
801074cd:	85 c0                	test   %eax,%eax
801074cf:	89 c6                	mov    %eax,%esi
801074d1:	75 8d                	jne    80107460 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801074d3:	83 ec 0c             	sub    $0xc,%esp
801074d6:	ff 75 e0             	pushl  -0x20(%ebp)
801074d9:	e8 02 fe ff ff       	call   801072e0 <freevm>
  return 0;
801074de:	83 c4 10             	add    $0x10,%esp
801074e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801074e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ee:	5b                   	pop    %ebx
801074ef:	5e                   	pop    %esi
801074f0:	5f                   	pop    %edi
801074f1:	5d                   	pop    %ebp
801074f2:	c3                   	ret    
801074f3:	90                   	nop
801074f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801074f8:	83 ec 0c             	sub    $0xc,%esp
801074fb:	56                   	push   %esi
801074fc:	e8 4f ae ff ff       	call   80102350 <kfree>
      goto bad;
80107501:	83 c4 10             	add    $0x10,%esp
80107504:	eb cd                	jmp    801074d3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107506:	83 ec 0c             	sub    $0xc,%esp
80107509:	68 7a 80 10 80       	push   $0x8010807a
8010750e:	e8 7d 8e ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107513:	83 ec 0c             	sub    $0xc,%esp
80107516:	68 60 80 10 80       	push   $0x80108060
8010751b:	e8 70 8e ff ff       	call   80100390 <panic>

80107520 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107520:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107521:	31 c9                	xor    %ecx,%ecx
{
80107523:	89 e5                	mov    %esp,%ebp
80107525:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107528:	8b 55 0c             	mov    0xc(%ebp),%edx
8010752b:	8b 45 08             	mov    0x8(%ebp),%eax
8010752e:	e8 9d f7 ff ff       	call   80106cd0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107533:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107535:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107536:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107538:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010753d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107540:	05 00 00 00 80       	add    $0x80000000,%eax
80107545:	83 fa 05             	cmp    $0x5,%edx
80107548:	ba 00 00 00 00       	mov    $0x0,%edx
8010754d:	0f 45 c2             	cmovne %edx,%eax
}
80107550:	c3                   	ret    
80107551:	eb 0d                	jmp    80107560 <copyout>
80107553:	90                   	nop
80107554:	90                   	nop
80107555:	90                   	nop
80107556:	90                   	nop
80107557:	90                   	nop
80107558:	90                   	nop
80107559:	90                   	nop
8010755a:	90                   	nop
8010755b:	90                   	nop
8010755c:	90                   	nop
8010755d:	90                   	nop
8010755e:	90                   	nop
8010755f:	90                   	nop

80107560 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107560:	55                   	push   %ebp
80107561:	89 e5                	mov    %esp,%ebp
80107563:	57                   	push   %edi
80107564:	56                   	push   %esi
80107565:	53                   	push   %ebx
80107566:	83 ec 1c             	sub    $0x1c,%esp
80107569:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010756c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010756f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107572:	85 db                	test   %ebx,%ebx
80107574:	75 40                	jne    801075b6 <copyout+0x56>
80107576:	eb 70                	jmp    801075e8 <copyout+0x88>
80107578:	90                   	nop
80107579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107580:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107583:	89 f1                	mov    %esi,%ecx
80107585:	29 d1                	sub    %edx,%ecx
80107587:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010758d:	39 d9                	cmp    %ebx,%ecx
8010758f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107592:	29 f2                	sub    %esi,%edx
80107594:	83 ec 04             	sub    $0x4,%esp
80107597:	01 d0                	add    %edx,%eax
80107599:	51                   	push   %ecx
8010759a:	57                   	push   %edi
8010759b:	50                   	push   %eax
8010759c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010759f:	e8 bc d5 ff ff       	call   80104b60 <memmove>
    len -= n;
    buf += n;
801075a4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801075a7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801075aa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801075b0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801075b2:	29 cb                	sub    %ecx,%ebx
801075b4:	74 32                	je     801075e8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801075b6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801075b8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801075bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801075be:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801075c4:	56                   	push   %esi
801075c5:	ff 75 08             	pushl  0x8(%ebp)
801075c8:	e8 53 ff ff ff       	call   80107520 <uva2ka>
    if(pa0 == 0)
801075cd:	83 c4 10             	add    $0x10,%esp
801075d0:	85 c0                	test   %eax,%eax
801075d2:	75 ac                	jne    80107580 <copyout+0x20>
  }
  return 0;
}
801075d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801075d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075dc:	5b                   	pop    %ebx
801075dd:	5e                   	pop    %esi
801075de:	5f                   	pop    %edi
801075df:	5d                   	pop    %ebp
801075e0:	c3                   	ret    
801075e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075eb:	31 c0                	xor    %eax,%eax
}
801075ed:	5b                   	pop    %ebx
801075ee:	5e                   	pop    %esi
801075ef:	5f                   	pop    %edi
801075f0:	5d                   	pop    %ebp
801075f1:	c3                   	ret    
