import syscall

template `+`*[T](p: ptr T, off: int): ptr T =
  cast[ptr type(p[])](cast[ByteAddress](p) +% off * sizeof(p[]))

template `+=`*[T](p: ptr T, off: int) =
  p = p + off

template `-`*[T](p: ptr T, off: int): ptr T =
  cast[ptr type(p[])](cast[ByteAddress](p) -% off * sizeof(p[]))

template `-=`*[T](p: ptr T, off: int) =
  p = p - off

template `[]`*[T](p: ptr T, off: int): T =
  (p + off)[]

template `[]=`*[T](p: ptr T, off: int, val: T) =
  (p + off)[] = val

const
  stdin* = 0
  stdout* = 1
  stderr* = 2

proc exit*(n: cint) {.inline, noReturn.} =
  discard syscall(EXIT, n)

proc write*(fd: cint, buf: cstring, len: csize): clong {.inline, discardable.} =
  syscall(WRITE, fd, buf, len)

proc strlen*(s: cstring): csize =
  while s[result] != '\0':
    inc result

proc strcmp*(a, b: cstring): int =
  for i in 0 .. int.high:
    if a[i] == '\0' and b[i] == '\0':
      return 0
    if a[i] < b[i]:
      return -i
    if a[i] > b[i]:
      return i

template init* {.dirty, immediate.} =
  proc stdmain*(argc: int, argv: cstringArray): cint =
    exit main(argc, argv)

  proc start* {.exportc: "_start".} =
    when defined(x86_64):
      {.emit: """asm volatile(
        "xorl %ebp, %ebp\n"
        "popq %rdi\n"       // Pop argc
        "movq %rsp, %rsi\n" // argv starts just at the current stack top
        "andq $~15, %rsp\n" // Align the stack to a 16 byte boundary
        "pushq %rax\n"      // Push garbage
        "pushq %rsp\n"      // Provide highest stack address to user code
        "call `stdmain`");""".}
    elif defined(x86):
      {.emit: """asm volatile(
        "xorl %ebp, %ebp\n"
        "popl %esi\n"       // Pop argc
        "movl %esp, %ecx\n" // argv starts at the current stack top
        "andl $~15, %esp\n" // align stack to a 16 byte boundary
        "pushl %eax\n"      // Push garbage
        "pushl %esp\n"      // Provide highest stack address to user code
        "pushl %ecx\n"      // argv
        "pushl %esi\n"      // argc
        "call `stdmain`");""".}
    else:
      error "_start not implemented for this platform"
