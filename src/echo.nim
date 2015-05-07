proc main(argc: int, argv: cstringArray): int =
  var
    buf = CharBuf[4096](fd: stdout)
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

  buf.flush()
