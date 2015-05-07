.text

.global _start
.type   _start,%function
.type   stdmain,%function

_start:
  xorl %ebp, %ebp
  popl %esi          /* Pop argc */
  movl %esp, %ecx    /* argv starts at the current stack top */
  andl $0xfffffff0, %esp /* align stack to a 16 byte boundary */
  pushl %eax         /* Push garbage */
  pushl %esp         /* Provide highest stack address to user code */
  pushl %ecx         /* argv */
  pushl %esi         /* argc */
  call stdmain
