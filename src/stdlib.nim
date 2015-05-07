import syscall

const
  stdin* = 0
  stdout* = 1
  stderr* = 2

proc exit*(n: clong) {.inline, noReturn.} =
  discard syscall(EXIT, n)

proc write*(fd: cint, buf: cstring, len: csize): clong {.inline, discardable.} =
  syscall(WRITE, fd, buf, len)
