proc main(argc: int, argv, envp: cstringArray): int =
  var buf = CharBuf[4096](fd: stdout)

  for i in 0 .. int.high:
    if envp[i] == nil:
      break
    buf.add envp[i]
    buf.add '\l'
  buf.flush()
