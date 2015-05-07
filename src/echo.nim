import stdlib

proc main(argv: cstringArray) {.exportc: "_start".} =
  stdout.write "Hello\n", 6
  exit 0
