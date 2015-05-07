type StackBuf*[S: static[int], T] = object
  buf*: array[S, T]
  pos*: int

proc add[S](s: var StackBuf[S, char], x: char) =
  s.buf[s.pos] = x
  inc s.pos
  if s.pos >= S:
    stdout.write s.buf, s.pos
    s.pos = 0

proc main(argc: int, argv: cstringArray): int =
  var
    buf: StackBuf[4096, char]
    start = 1
    newLine = true

  if argc > 1 and strcmp(argv[start], "-n") == 0:
    inc start
    newLine = false

  block outer:
    for i in start .. <argc:
      var j = 0
      while true:
        case argv[i][j]
        of '\0': break
        of '\\':
          inc j
          case argv[i][j]
          of 'a':  buf.add '\a'
          of 'b':  buf.add '\b'
          of 'c':  break outer
          of 'f':  buf.add '\f'
          of 'n':  buf.add '\l'
          of 'r':  buf.add '\r'
          of 't':  buf.add '\t'
          of 'v':  buf.add '\v'
          of '\\': buf.add '\\'
          else:
            buf.add '\\'
            buf.add argv[i][j]
        else:
          buf.add argv[i][j]
        inc j
      if i < argc - 1:
        buf.add ' '

    if newLine:
      buf.add '\l'

  stdout.write buf.buf, buf.pos
  result = 0
