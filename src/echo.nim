proc main(argc: int, argv: cstringArray): int =
  var
    start = 1
    newLine = true

  if argc > 1 and strcmp(argv[start], "-n") == 0:
    inc start
    newLine = false

  for i in start .. <argc:
    stdout.write argv[i], strlen(argv[i])
    if i < argc - 1:
      stdout.write " ", 1

  if newLine:
    stdout.write "\n", 1
