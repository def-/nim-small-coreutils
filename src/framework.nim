import syscall, macros

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
      return -1
    if a[i] > b[i]:
      return 1

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
