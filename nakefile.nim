import nake, osproc

const
  payloadFile = "src/nimcache/payload"
  payloadBin = "src/nimcache/payload.bin"

type Platform = enum x86, x86_64

proc build(platform: Platform) =
  let
    scriptFile = "tools" / $platform / "script.ld"
    elfFile = "tools" / $platform / "elf.s"

  var
    nim = nimExe
    ld = "ld"

  if platform == x86:
    nim = nim & " --cpu:i386 --passC:-m32 --passL:-m32"
    ld = ld & " -m elf_i386"

  createDir "bin" / $platform

  for file in walkFiles "src/*.nim":
    let
      (_, name, ext) = splitFile file
      objFile = "src/nimcache" / name & ".o"
      outFile = "bin" / $platform / name

    if name in ["panicoverride", "stdlib"]:
      continue

    direShell nim, "--verbosity:0 --hints:off --nolinking --os:standalone -d:release --noMain --passC:-ffunction-sections --passC:-fdata-sections --passL:-Wl,--gc-sections c", file
    direShell ld, "--gc-sections -e _start -T", scriptFile, "-o", payloadFile, objFile
    direShell "objcopy -j combined -O binary", payLoadFile, payLoadBin

    var entry: string
    for line in splitLines execProcess "nm -f posix src/nimcache/payload":
      if line.startsWith "_start ":
        entry = line.split(" ")[2]

    direShell "nasm -f bin -o", outFile, "-D entry=0x" & entry, elfFile
    inclFilePermissions outFile, {fpUserExec, fpGroupExec, fpOthersExec}

task "clean", "Clean up build directories":
  removeDir "bin"
  removeDir "nimcache"
  removeDir "src/nimcache"
  removeFile "payload"
  removeFile "payload.bin"

task "all", "Build the small coreutils for x86-64 and x86":
  build x86_64
  build x86

task "x86", "Build the small coreutils for x86":
  build x86

task "x86-64", "Build the small coreutils for x86":
  build x86_64
