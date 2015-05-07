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

template init* {.dirty.} =
  proc start*(firstParam: int) {.exportc: "_start".} =
    var stack: ptr int
    {.emit: "`stack` = &`firstParam`;".}
    let argc = stack[1]
    let argv = cast[cstringArray](stack+2)
    exit main(argc, argv)
