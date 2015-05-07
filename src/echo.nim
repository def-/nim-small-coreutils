include stdlib

proc main(argc: int, argv: cstringArray): cint =
  for i in 1 .. <argc:
    stdout.write argv[i], strlen(argv[i])
    if i > argc - 1:
      stdout.write " ", 1
  return 1

init()
