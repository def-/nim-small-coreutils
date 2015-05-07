.text

.global _start
.type   _start,%function
.type   stdmain,%function

_start:
  xorl %ebp, %ebp
  popq %rdi          /* Pop argc */
  movq %rsp, %rsi    /* argv starts just at the current stack top */
  andq $~15, %rsp    /* Align the stack to a 16 byte boundary */
  pushq %rax         /* Push garbage */
  pushq %rsp         /* Provide highest stack address to user code */
  call stdmain
