# Small coreutils in Nim

This uses the methods from [my blog post](http://hookrace.net/blog/nim-binary-size/) to implement small coreutils in Nim. Current file sizes:

| Tool | Size glibc | Size x86 | Size x86_64 |
| ---- | ----------:| --------:| -----------:|
| true |      27 KB |    100 B |       130 B |
| false|      27 KB |    100 B |       133 B |
| echo |      31 KB |    694 B |       822 B |
| env  |      31 KB |    357 B |       366 B |
| cat  |      51 KB |          |             |

For quick testing you can compile like this:

    $ nim -d:release --putEnv:file=echo -o:echo c src/framework
