import stdlib

proc main(argc: int, argv: cstringArray): cint {.inline.} =
  var
    start = 1
    newLine = true

  if strcmp(argv[start], "-n") == 0:
    inc start
    newLine = false

  for i in start .. <argc:
    stdout.write argv[i], strlen(argv[i])
    if i < argc - 1:
      stdout.write " ", 1

  if newLine:
    stdout.write "\n", 1
  return 0

init()
