#!/bin/bash

#/usr/bin/python3 waf configure CC=gcc.exe --check-c-compiler=gcc --prefix="/d/mpv-install"
#pacman -S mingw-w64-x86_64-{spirv-cross,shaderc,ffnvcodec}

meson setup build -Dlibmpv=true --prefix="/d/mpv-install"
meson compile -C build
meson install -C build

cd /d/mpv-install/bin
originPATH=${PATH}
PATH="/c/Program Files (x86)/Microsoft Visual Studio/2019/BuildTools/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64/":${PATH}

echo LIBRARY libmpv-2 > libmpv-2.def
echo EXPORTS >> libmpv-2.def
dumpbin -EXPORTS libmpv-2.dll >> libmpv-2-exports.txt
#for i in $(cat libmpv-2-exports.txt | grep "mpv_" | awk '{print $4}'); do echo $i; done
for i in $(cat libmpv-2-exports.txt | grep "mpv_" | awk '{print $4}')
do
    echo $i >> libmpv-2.def
done
cat libmpv-2.def
lib -def:libmpv-2.def -out:libmpv-2.lib -machine:X64

PATH=${originPATH}

./mpv.exe "d:\\blue.mkv"
