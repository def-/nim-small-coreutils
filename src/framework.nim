import syscall, macros

# Pointer arithmetic

template `+`[T](p: ptr T, off: int): ptr T =
  cast[ptr type(p[])](cast[ByteAddress](p) +% off * sizeof(p[]))

template `+=`[T](p: ptr T, off: int) =
  p = p + off

template `-`[T](p: ptr T, off: int): ptr T =
  cast[ptr type(p[])](cast[ByteAddress](p) -% off * sizeof(p[]))

template `-=`[T](p: ptr T, off: int) =
  p = p - off

template `[]`[T](p: ptr T, off: int): T =
  (p + off)[]

template `[]=`[T](p: ptr T, off: int, val: T) =
  (p + off)[] = val

# File Descriptors
const
  stdin = 0
  stdout = 1
  stderr = 2

# Syscalls

proc exit(n: cint) {.inline, noReturn.} =
  discard syscall(EXIT, n)

proc write(fd: cint, buf: cstring, len: csize): clong {.inline, discardable.} =
  syscall(WRITE, fd, buf, len)

# Stdlib

proc strlen(s: cstring): csize =
  while s[result] != '\0':
    inc result

proc strcmp(a, b: cstring): int =
  for i in 0 .. int.high:
    if a[i] == '\0' and b[i] == '\0':
      return 0
    if a[i] < b[i]:
      return -1
    if a[i] > b[i]:
      return 1

# Helpers

type CharBuf[S: static[int]] = object
  buf: array[S, char]
  pos: int
  fd: cint

proc flush[S](s: var CharBuf[S]) =
  write s.fd, s.buf, s.pos
  s.pos = 0

proc add[S](s: var CharBuf[S], x: char) =
  s.buf[s.pos] = x
  inc s.pos
  if s.pos >= S:
    s.flush()

proc add[S](s: var CharBuf[S], x: cstring) =
  for i in 0 .. int.high:
    if x[i] == '\0': return
    s.add x[i]

macro includeIt: stmt =
  const file = staticExec("echo $file")
  result = parseStmt("include " & file)
includeIt()

when compiles(main()):
  proc stdmain {.exportc: "_start".} =
    exit main().cint
else:
  when defined(x86_64):
    {.compile: "tools/x86_64/start.s".}
  elif defined(x86):
    {.compile: "tools/x86/start.s".}
  else:
    {.error: "No _start defined for this architecture".}

  proc stdmain(argc: cint, argv: cstringArray) {.exportc.} =
    when compiles(main(argc.int, argv)):
      exit main(argc.int, argv).cint
    else:
      let envp = cast[cstringArray](addr argv[argc + 1])
      exit main(argc.int, argv, envp).cint
