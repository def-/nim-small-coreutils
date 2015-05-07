proc main(argc: int, argv: cstringArray): int =
  var
    buf = CharBuf[4096](fd: stdout)
    start = 1
    file = stdin
    stdinRead = false

  if argc > 1 and argv[start][0] ==  '-':
    inc start

  for i in start .. <argc:
    if strcmp(argv[i], "-") == 0:
      file = stdin
