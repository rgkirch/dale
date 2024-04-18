call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
IF NOT EXIST "C:\Users\User\vcpkg\vcpkg.exe" call "C:/Users/User/vcpkg/bootstrap-vcpkg.bat"
SET PKG_CONFIG_PATH=C:/Users/User/vcpkg/installed/x64-windows/lib/pkgconfig
REM SET CMAKE_MODULE_PATH=C:/Users/User/vcpkg/scripts/cmake
echo. > C:\Users\User\dale2\out.txt 2>&1
SET PKG_CONFIG_MSVC_SYNTAX=1
SET PKG_CONFIG_DEBUG_SPEW=1
cmake ^
    -DCURRENT_BUILDTREES_DIR=C:/Users/User/dale2-build ^
    -DDOWNLOADS=C:/Users/User/Downloads ^
    -DCMAKE_MODULE_PATH=C:/Users/User/vcpkg/scripts/cmake ^
    -DCMAKE_TOOLCHAIN_FILE=C:/Users/User/vcpkg/scripts/buildsystems/vcpkg.cmake ^
    -DLLVM_CONFIG=C:/Users/User/llvm-build/bin/llvm-config.exe ^
    -S C:\Users\User\dale2 ^
    -B C:\Users\User\dale2-build ^
    -G Ninja ^
    >> C:\Users\User\dale2\out.txt 2>&1
REM cmake --build C:\Users\User\dale2-build >> C:\Users\User\dale2\out.txt 2>&1
cd C:\Users\User\dale2-build
ninja >> C:\Users\User\dale2\out.txt 2>&1
powershell -command "cp C:\Users\User\dale2\out.txt \\tsclient\C\Users\me\out.txt"
