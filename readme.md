# Small coreutils in Nim

This uses the methods from [my blog post](http://hookrace.net/blog/nim-binary-size/) to implement small coreutils in Nim. Current file sizes:

| Tool | Size glibc | Size x86 | Size x86_64 |
| ---- | ----------:| --------:| -----------:|
| true |      27 KB |     97 B |       129 B |
| false|      27 KB |     97 B |       132 B |
| echo |      31 KB |    356 B |       381 B |
