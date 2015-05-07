proc main(argc: int, argv, envp: cstringArray): int =
  var i = 0
  while envp[i] != nil:
    stdout.write envp[i], strlen(envp[i])
    stdout.write "\l", 1
    inc i
