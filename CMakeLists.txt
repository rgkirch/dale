cmake_minimum_required(VERSION 3.7)

project(Dale)

message(STATUS "ENV:PKG_CONFIG_MSVC_SYNTAX: $ENV{PKG_CONFIG_MSVC_SYNTAX}")

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    message (STATUS "detected Windows")
endif()

#Semicolon-separated list of directories, represented using forward slashes,
#specifying a search path for CMake modules to be loaded by the include() or
#find_package() commands before checking the default modules that come with
#CMake. By default it is empty. It is intended to be set by the project.

# If I can't replace this with a more meaningful default then it should just be
# an error. I do need to set this.
set (DEFAULT_CMAKE_MODULE_PATH "C:/Users/User/vcpkg/scripts")
message (STATUS "SCRIPTS: ${SCRIPTS}")
message (STATUS "CMAKE_CURRENT_LIST_DIR: ${CMAKE_CURRENT_LIST_DIR}")

include(execute_process)
#include(vcpkg_acquire_msys)
#include(vcpkg_add_to_path)
#include(vcpkg_apply_patches)
#include(vcpkg_backup_restore_env_vars)
#include(vcpkg_build_cmake)
#include(vcpkg_build_make)
#include(vcpkg_build_msbuild)
#include(vcpkg_build_ninja)
#include(vcpkg_build_nmake)
#include(vcpkg_build_qmake)
#include(vcpkg_buildpath_length_warning)
#include(vcpkg_check_features)
#include(vcpkg_check_linkage)
#include(vcpkg_clean_executables_in_bin)
#include(vcpkg_clean_msbuild)
#include(vcpkg_configure_cmake)
#include(vcpkg_configure_gn)
#include(vcpkg_configure_make)
#include(vcpkg_configure_meson)
#include(vcpkg_configure_qmake)
#include(vcpkg_copy_pdbs)
#include(vcpkg_copy_tool_dependencies)
#include(vcpkg_copy_tools)
#include(vcpkg_download_distfile)
#include(vcpkg_download_sourceforge)
#include(vcpkg_execute_build_process)
include(vcpkg_execute_required_process)
#include(vcpkg_execute_required_process_repeat)
#include(vcpkg_extract_archive)
include(vcpkg_extract_source_archive)
include(vcpkg_extract_source_archive_ex)
#include(vcpkg_fail_port_install)
#include(vcpkg_find_acquire_program)
#include(vcpkg_fixup_cmake_targets)
#include(vcpkg_fixup_pkgconfig)
#include(vcpkg_from_bitbucket)
include(vcpkg_from_git)
#include(vcpkg_from_github)
#include(vcpkg_from_gitlab)
#include(vcpkg_from_sourceforge)
#include(vcpkg_get_program_files_platform_bitness)
#include(vcpkg_get_windows_sdk)
#include(vcpkg_host_path_list)
#include(vcpkg_install_cmake)
#include(vcpkg_install_copyright)
#include(vcpkg_install_gn)
#include(vcpkg_install_make)
#include(vcpkg_install_meson)
#include(vcpkg_install_msbuild)
#include(vcpkg_install_nmake)
#include(vcpkg_install_qmake)
include(vcpkg_list)
#include(vcpkg_minimum_required)
#include(vcpkg_replace_string)
#include(vcpkg_test_cmake)

include(z_vcpkg_apply_patches)
include(z_vcpkg_forward_output_variable)
#include(z_vcpkg_function_arguments)
#include(z_vcpkg_get_cmake_vars)
include(z_vcpkg_prettify_command_line)
#include(z_vcpkg_setup_pkgconfig_path)

#include(z_vcpkg_fixup_rpath)

#https://github.com/microsoft/vcpkg/blob/master/scripts/cmake/vcpkg_from_git.cmake
include(vcpkg_execute_in_download_mode)

if(DEFINED ENV{CMAKE_MODULE_PATH})
    message (STATUS "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")
    message (STATUS "reading CMAKE_MODULE_PATH from the environment: $ENV{CMAKE_MODULE_PATH}")
    set (CMAKE_MODULE_PATH $ENV{CMAKE_MODULE_PATH})
elseif (DEFINED CMAKE_MODULE_PATH)
    message (STATUS "CMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}")
else()
    message (STATUS "using default CMAKE_MODULE_PATH: ${DEFAULT_CMAKE_MODULE_PATH}")
    set (CMAKE_MODULE_PATH DEFAULT_CMAKE_MODULE_PATH)
endif()

# I'm not sure that I need this. I'm debugging vcpkg_from_git.
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    execute_process (COMMAND "cd.exe"
                     OUTPUT_VARIABLE CURRENT_WORKING_DIRECTORY
                     OUTPUT_STRIP_TRAILING_WHITESPACE)
else()
    execute_process (COMMAND "pwd"
                     OUTPUT_VARIABLE CURRENT_WORKING_DIRECTORY
                     OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()

message (STATUS "CURRENT_WORKING_DIRECTORY: ${CURRENT_WORKING_DIRECTORY}")

if(DEFINED ENV{DOWNLOADS})
    message (STATUS "DOWNLOADS: ${DOWNLOADS}")
    message (STATUS "reading DOWNLOADS from the environment: $ENV{DOWNLOADS}")
    set (DOWNLOADS $ENV{DOWNLOADS})
elseif (DEFINED DOWNLOADS)
    message (STATUS "DOWNLOADS: ${DOWNLOADS}")
else()
    message (STATUS "using default DOWNLOADS: ${DEFAULT_DOWNLOADS}")
    set (DOWNLOADS DEFAULT_DOWNLOADS)
endif()

#set (ENV{TARGET_TRIPLET} ".")

#We set CURRENT_BUILDTREES_DIR because vcpkg_from_git uses it to set
#WORKING_DIRECTORY to "${CURRENT_BUILDTREES_DIR}/src/head".
#set (ENV{CURRENT_BUILDTREES_DIR} CURRENT_WORKING_DIRECTORY)

#set (TARGET_TRIPLET ENV{TARGET_TRIPLET})
#set (CURRENT_BUILDTREES_DIR ENV{CURRENT_BUILDTREES_DIR})

set(GNULIB_REF "7941742a51e468b0f4ba07c395d0a46528352a81")
#set(SOURCE_PATH ".")
vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "https://git.savannah.gnu.org/git/gnulib.git"
    REF "${GNULIB_REF}"
)
message (STATUS "SOURCE_PATH: ${SOURCE_PATH}")


find_program(LLVM_CONFIG llvm-config DOC "path to llvm-config")
find_program(CLANG clang DOC "path to clang")

if (NOT LLVM_CONFIG)
    message (FATAL_ERROR "llvm-config executable not found. Re-run cmake with -DLLVM_CONFIG={path-to-llvm-config}.")
endif()

# This check is supposed to confirm that the llvm-config executable
# exists and can be executed, but --help appears to return 0 on macOS
# at least.  There is probably a better way to check for this.

# execute_process (COMMAND ${LLVM_CONFIG} --help
#                  RESULT_VARIABLE RESULT
#                  OUTPUT_QUIET
#                  ERROR_QUIET)
# if (NOT ${RESULT} EQUAL 1)
#     message (FATAL_ERROR "Unable to execute '${LLVM_CONFIG}': ${RESULT}")
# endif ()

execute_process (COMMAND ${LLVM_CONFIG} --version
                 OUTPUT_VARIABLE D_LLVM_VERSION
                 OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process (COMMAND ${LLVM_CONFIG} --bindir
                 OUTPUT_VARIABLE LLVM_BIN_DIR
                 OUTPUT_STRIP_TRAILING_WHITESPACE)

string(REGEX MATCH "[^0-9]*([^.]+)\.([^.]+).*" _ ${D_LLVM_VERSION})
set(D_LLVM_VERSION_MAJOR ${CMAKE_MATCH_1})
set(D_LLVM_VERSION_MINOR ${CMAKE_MATCH_2})

if (NOT D_LLVM_VERSION)
    message (FATAL_ERROR "Unable to retrieve version number from llvm-config executable (${LLVM_CONFIG})")
endif ()

set (Dale_VERSION_REV $ENV{Dale_VERSION_REV})
if (NOT Dale_VERSION_REV)
    execute_process (COMMAND git rev-parse --short HEAD
                     OUTPUT_VARIABLE Dale_VERSION_REV
                     OUTPUT_STRIP_TRAILING_WHITESPACE)
    if (NOT Dale_VERSION_REV)
        set (Dale_VERSION_REV 0)
    endif ()
endif ()
message (STATUS "CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")

set (Dale_VERSION_MAJOR 0)
set (Dale_VERSION_MINOR 3)
set (Dale_VERSION         "${Dale_VERSION_MAJOR}.${Dale_VERSION_MINOR}")
set (DALE_INCLUDE_PATH    "${CMAKE_INSTALL_PREFIX}/include/dale")
set (DALE_LIBRARY_PATH    "${CMAKE_INSTALL_PREFIX}/lib/dale")
set (DALE_MODULE_PATH     "${CMAKE_INSTALL_PREFIX}/lib/dale")
set (SYSTEM               "${CMAKE_SYSTEM}")
set (SYSTEM_NAME          "${CMAKE_SYSTEM_NAME}")
set (SYSTEM_PROCESSOR     "${CMAKE_SYSTEM_PROCESSOR}")
set (SIZEOF_DATA_PTR      "${CMAKE_CXX_SIZEOF_DATA_PTR}")
set (D_LLVM_VERSION       "${D_LLVM_VERSION}")
set (D_LLVM_VERSION_MAJOR "${D_LLVM_VERSION_MAJOR}")
set (D_LLVM_VERSION_MINOR "${D_LLVM_VERSION_MINOR}")
set (D_LLVM_VERSION_ORD   "${D_LLVM_VERSION_MAJOR}${D_LLVM_VERSION_MINOR}")
set (LLVM_BIN_DIR         "${LLVM_BIN_DIR}")

if (NOT CMAKE_INSTALL_MANDIR)
    set (CMAKE_INSTALL_MANDIR "${CMAKE_INSTALL_PREFIX}/man")
endif ()

if (NOT CC)
    if (CLANG)
        set (CC "${CLANG}")
    else ()
        set (CC "cc")
    endif ()
endif ()

message (STATUS "LLVM version: ${D_LLVM_VERSION}")
message (STATUS "LLVM version major: ${D_LLVM_VERSION_MAJOR}")
message (STATUS "LLVM version minor: ${D_LLVM_VERSION_MINOR}")
message (STATUS "System name: ${CMAKE_SYSTEM_NAME}")
message (STATUS "System processor: ${CMAKE_SYSTEM_PROCESSOR}")
message (STATUS "System version: ${CMAKE_SYSTEM_VERSION}")

if (${D_LLVM_VERSION_ORD} LESS 32)
    message (FATAL_ERROR "LLVM >= 3.2 is required.")
elseif (${D_LLVM_VERSION_ORD} GREATER 140)
    message (FATAL_ERROR "LLVM <= 14.0 is required.")
endif ()

# Get LLVM configuration details.

execute_process (COMMAND ${LLVM_CONFIG} --libs
                 OUTPUT_VARIABLE LLVM_LIBS
                 OUTPUT_STRIP_TRAILING_WHITESPACE)
separate_arguments(LLVM_LIBS NATIVE_COMMAND ${LLVM_LIBS})
message (STATUS "LLVM_LIBS: ${LLVM_LIBS}")

if (${D_LLVM_VERSION_ORD} GREATER 34)
    execute_process (COMMAND ${LLVM_CONFIG} --system-libs
                     OUTPUT_VARIABLE LLVM_SYSTEM_LIBS
                     OUTPUT_STRIP_TRAILING_WHITESPACE)
    message (STATUS "LLVM_SYSTEM_LIBS: ${LLVM_SYSTEM_LIBS}")
endif ()
execute_process (COMMAND ${LLVM_CONFIG} --ldflags
                 OUTPUT_VARIABLE LLVM_LINK_FLAGS
                 OUTPUT_STRIP_TRAILING_WHITESPACE)
message (STATUS "setting LLVM_LINK_FLAGS to output of ${LLVM_CONFIG} --ldflags: ${LLVM_LINK_FLAGS}")
execute_process (COMMAND ${LLVM_CONFIG} --cppflags
                 OUTPUT_VARIABLE LLVM_CXX_FLAGS
                 OUTPUT_STRIP_TRAILING_WHITESPACE)
message (STATUS "setting LLVM_CXX_FLAGS to output of ${LLVM_CONFIG} --cppflags: ${LLVM_CXX_FLAGS}")

# Confirm that ffi.h and libffi are present.
find_package(PkgConfig REQUIRED)
pkg_search_module(FFI REQUIRED libffi)

# Populate the configuration header.

configure_file("${CMAKE_SOURCE_DIR}/src/dale/Config.h.in"
               "${CMAKE_BINARY_DIR}/Config.h")

# Build type processing. Default is 'Release'.

if (NOT CMAKE_BUILD_TYPE)
    set (CMAKE_BUILD_TYPE Release CACHE STRING
         "Choose the type of build. Options are 'Debug' and 'Release'."
         FORCE)
endif ()

string (TOUPPER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE)

string (COMPARE EQUAL ${CMAKE_BUILD_TYPE} "DEBUG"   IS_DEBUG)
string (COMPARE EQUAL ${CMAKE_BUILD_TYPE} "RELEASE" IS_RELEASE)

if (NOT IS_DEBUG)
    if (NOT IS_RELEASE)
        message (FATAL_ERROR "Invalid CMAKE_BUILD_TYPE specified. Must be either 'Debug' or 'Release'.")
    endif ()
endif ()

message (STATUS "Build type: ${CMAKE_BUILD_TYPE}")

if (IS_DEBUG)
    string (REGEX REPLACE "-DNDEBUG" "" LLVM_CXX_FLAGS ${LLVM_CXX_FLAGS})
endif ()

# Set compile/link flags.
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    if(DEFINED ENV{PKG_CONFIG_PATH})
        message (STATUS "reading PKG_CONFIG_PATH from the environment: $ENV{PKG_CONFIG_PATH}")
        set (PKG_CONFIG_PATH $ENV{PKG_CONFIG_PATH})
    elseif(NOT DEFINED PKG_CONFIG_PATH)
        message (STATUS "PKG_CONFIG_PATH not defined. Setting default PKG_CONFIG_PATH: C:/Users/User/vcpkg/installed/x64-windows/lib/pkgconfig")
        set (PKG_CONFIG_PATH "C:/Users/User/vcpkg/installed/x64-windows/lib/pkgconfig")
    endif()

    message (STATUS "ENV:LDFLAGS: $ENV{LDFLAGS}")
    message (STATUS "LDFLAGS: ${LDFLAGS}")
    message (STATUS "PKG_CONFIG_LIBDIR: ${PKG_CONFIG_LIBDIR}")

    message (STATUS "populating FFI_LINK_FLAGS from pkgconf.exe --msvc-syntax --libs-only-l libffi")
    execute_process (COMMAND "C:/Users/User/vcpkg/packages/pkgconf_x64-windows/tools/pkgconf/pkgconf.exe" --msvc-syntax --libs-only-l libffi
                     OUTPUT_VARIABLE FFI_LINK_FLAGS
                     OUTPUT_STRIP_TRAILING_WHITESPACE)
    message(STATUS "FFI_LINK_FLAGS: ${FFI_LINK_FLAGS}")

    message (STATUS "populating FFI_LIB_FLAGS from pkgconf.exe --msvc-syntax --libs-only-L libffi")
    execute_process (COMMAND "C:/Users/User/vcpkg/packages/pkgconf_x64-windows/tools/pkgconf/pkgconf.exe" --msvc-syntax --libs-only-L libffi
                     OUTPUT_VARIABLE FFI_LIB_FLAGS
                     OUTPUT_STRIP_TRAILING_WHITESPACE)
    message(STATUS "FFI_LIB_FLAGS: ${FFI_LIB_FLAGS}")

#    message (STATUS "checking pkgconf.exe --variable pc_path pkg-config")
#    execute_process (COMMAND "C:/Users/User/vcpkg/packages/pkgconf_x64-windows/tools/pkgconf/pkgconf.exe" --variable pc_path pkg-config
#                     OUTPUT_VARIABLE PKG_CONFIG_PC_PATH
#                     OUTPUT_STRIP_TRAILING_WHITESPACE)
#    message (STATUS "PKG_CONFIG_PC_PATH: ${PKG_CONFIG_PC_PATH}")

    message (STATUS "VCPKG_APPLOCAL_DEPS: ${VCPKG_APPLOCAL_DEPS}")
    message (STATUS "VCPKG_CHAINLOAD_TOOLCHAIN_FILE: ${VCPKG_CHAINLOAD_TOOLCHAIN_FILE}")
    message (STATUS "VCPKG_PREFER_SYSTEM_LIBS: ${VCPKG_PREFER_SYSTEM_LIBS}")
    message (STATUS "Z_VCPKG_POWERSHELL_PATH: ${Z_VCPKG_POWERSHELL_PATH}")
    set (DALEC_LIBDIR_FLAGS_ "$ENV{LDFLAGS} ${FFI_LIB_FLAGS} ${FFI_LINK_FLAGS}")
    message (STATUS "DALEC_LIBDIR_FLAGS_: ${DALEC_LIBDIR_FLAGS_}")
    set (DALEC_LIB_FLAGS_    "")
else()
    message (STATUS "FFI_LDFLAGS: ${FFI_LDFLAGS}")
    message (STATUS "DALEC_LIBDIR_FLAGS_: ${DALEC_LIBDIR_FLAGS_}")
    set (DALEC_LIBDIR_FLAGS_ "$ENV{LDFLAGS} ${FFI_LDFLAGS}")
    set (DALEC_LIB_FLAGS_    "")
endif()

if (${D_LLVM_VERSION_ORD} GREATER 34)
    set (DALEC_LIB_FLAGS_ ${LLVM_SYSTEM_LIBS})
endif ()

if (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
    set (DALEC_LINK_FLAGS "${DALEC_LIBDIR_FLAGS_} -L/usr/local/lib ${DALEC_LIB_FLAGS_}")
elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    #                                        ignore DALEC_LIB_FLAGS_
    set (DALEC_LINK_FLAGS "${DALEC_LIBDIR_FLAGS_} ${DALEC_LIB_FLAGS_}")
else()
    set (DALEC_LINK_FLAGS "${DALEC_LIBDIR_FLAGS_} ${DALEC_LIB_FLAGS_} -ldl")
endif()
string(REGEX REPLACE "^ +" "" DALEC_LINK_FLAGS ${DALEC_LINK_FLAGS})
separate_arguments(DALEC_LINK_FLAGS NATIVE_COMMAND ${DALEC_LINK_FLAGS})
message (STATUS "DALEC_LINK_FLAGS: ${DALEC_LINK_FLAGS}")


if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set (STD_CXX_11 "/std:c++11")
    set (STD_CXX_14 "/std:c++14")
else()
    set (STD_CXX_11 "-std=c++11")
    set (STD_CXX_14 "-std=c++14")
endif()

# LLVM 3.5 relies on C++11, and LLVM 10.0 relies on C++14.
if (${D_LLVM_VERSION_ORD} GREATER_EQUAL 100)
    set (CXX_FLAGS_EXTRA STD_CXX_14)
elseif (${D_LLVM_VERSION_ORD} GREATER_EQUAL 35)
    set (CXX_FLAGS_EXTRA STD_CXX_11)
else ()
    set (CXX_FLAGS_EXTRA "")
endif ()

#https://stackoverflow.com/a/2274040
if(CMAKE_COMPILER_IS_GNUCXX)
    message(STATUS "GCC detected")
    set (CMAKE_CXX_FLAGS       "$ENV{CPPFLAGS} ${FFI_CFLAGS} -Wall -ansi")
    set (CMAKE_CXX_FLAGS_DEBUG "-g -ggdb -O0 -fno-rtti -fno-inline -Wextra -Wno-unused-parameter ${CXX_FLAGS_EXTRA}")
else ()
    message(STATUS "not gcc")
    set (CMAKE_CXX_FLAGS       "$ENV{CPPFLAGS} ${FFI_CFLAGS} /W1 /WL")
    set (CMAKE_CXX_FLAGS_DEBUG "")
endif()

set (CMAKE_CXX_FLAGS_RELEASE "-O3 -fno-rtti -fomit-frame-pointer ${CXX_FLAGS_EXTRA}")

set (DALE_FLAGS_DEBUG   "-O0")
set (DALE_FLAGS_RELEASE "-O3")

if (IS_DEBUG)
    set (DALE_FLAGS ${DALE_FLAGS_DEBUG})
else ()
    set (DALE_FLAGS ${DALE_FLAGS_RELEASE})
endif ()

SET(CMAKE_SKIP_BUILD_RPATH FALSE)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

add_library(dale SHARED
                 Config.h
                 src/dale/Arch/Arch.cpp
                 src/dale/Introspection/Introspection.cpp
                 src/dale/Operation/Cast/Cast.cpp
                 src/dale/Operation/Move/Move.cpp
                 src/dale/Operation/Sizeof/Sizeof.cpp
                 src/dale/Operation/Offsetof/Offsetof.cpp
                 src/dale/Operation/Alignmentof/Alignmentof.cpp
                 src/dale/BasicTypes/BasicTypes.cpp
                 src/dale/Module/Writer/Writer.cpp
                 src/dale/Serialise/Serialise.cpp
                 src/dale/Generator/Generator.cpp
                 src/dale/REPL/REPL.cpp
                 src/dale/Linkage/Linkage.cpp
                 src/dale/Namespace/Namespace.cpp
                 src/dale/Context/Context.cpp
                 src/dale/NamespaceSavePoint/NamespaceSavePoint.cpp
                 src/dale/ContextSavePoint/ContextSavePoint.cpp
                 src/dale/Lexer/Lexer.cpp
                 src/dale/Node/Node.cpp
                 src/dale/Parser/Parser.cpp
                 src/dale/Position/Position.cpp
                 src/dale/Utils/Utils.cpp
                 src/dale/llvmUtils/llvmUtils.cpp
                 src/dale/Token/Token.cpp
                 src/dale/ErrorType/ErrorType.cpp
                 src/dale/Error/Error.cpp
                 src/dale/ErrorReporter/ErrorReporter.cpp
                 src/dale/ParseResult/ParseResult.cpp
                 src/dale/Function/Function.cpp
                 src/dale/BaseType/BaseType.cpp
                 src/dale/TokenType/TokenType.cpp
                 src/dale/Type/Type.cpp
                 src/dale/TypeMap/TypeMap.cpp
                 src/dale/Variable/Variable.cpp
                 src/dale/Struct/Struct.cpp
                 src/dale/NativeTypes/NativeTypes.cpp
                 src/dale/TypeRegister/TypeRegister.cpp
                 src/dale/Decoder/Decoder.cpp
                 src/dale/Form/Proc/Goto/Goto.cpp
                 src/dale/Form/Proc/If/If.cpp
                 src/dale/Form/Proc/Label/Label.cpp
                 src/dale/Form/Proc/Return/Return.cpp
                 src/dale/Form/Proc/Setf/Setf.cpp
                 src/dale/Form/Proc/Dereference/Dereference.cpp
                 src/dale/Form/Proc/Sref/Sref.cpp
                 src/dale/Form/Proc/AddressOf/AddressOf.cpp
                 src/dale/Form/Proc/Aref/Aref.cpp
                 src/dale/Form/Proc/PtrEquals/PtrEquals.cpp
                 src/dale/Form/Proc/PtrAdd/PtrAdd.cpp
                 src/dale/Form/Proc/PtrSubtract/PtrSubtract.cpp
                 src/dale/Form/Proc/PtrLessThan/PtrLessThan.cpp
                 src/dale/Form/Proc/PtrGreaterThan/PtrGreaterThan.cpp
                 src/dale/Form/Proc/VaStart/VaStart.cpp
                 src/dale/Form/Proc/VaEnd/VaEnd.cpp
                 src/dale/Form/Proc/VaArg/VaArg.cpp
                 src/dale/Form/Proc/Null/Null.cpp
                 src/dale/Form/Proc/Quote/Quote.cpp
                 src/dale/Form/Proc/Def/Def.cpp
                 src/dale/Form/Proc/NullPtr/NullPtr.cpp
                 src/dale/Form/Proc/Do/Do.cpp
                 src/dale/Form/Proc/Cast/Cast.cpp
                 src/dale/Form/Proc/Sizeof/Sizeof.cpp
                 src/dale/Form/Proc/Offsetof/Offsetof.cpp
                 src/dale/Form/Proc/Alignmentof/Alignmentof.cpp
                 src/dale/Form/Proc/Funcall/Funcall.cpp
                 src/dale/Form/Proc/UsingNamespace/UsingNamespace.cpp
                 src/dale/Form/Proc/NewScope/NewScope.cpp
                 src/dale/Form/Proc/ArrayOf/ArrayOf.cpp
                 src/dale/Form/Proc/Move/Move.cpp
                 src/dale/Form/ProcBody/ProcBody.cpp
                 src/dale/Form/Macro/ArrayDeref/ArrayDeref.cpp
                 src/dale/Form/Macro/StructDeref/StructDeref.cpp
                 src/dale/Form/Macro/DerefStructDeref/DerefStructDeref.cpp
                 src/dale/Form/Macro/DerefStruct/DerefStruct.cpp
                 src/dale/Form/Macro/Setv/Setv.cpp
                 src/dale/Form/Linkage/Struct/Struct.cpp
                 src/dale/Form/Linkage/Linkage.cpp
                 src/dale/Form/Type/Type.cpp
                 src/dale/Form/Function/Function.cpp
                 src/dale/Form/Proc/Token/Token.cpp
                 src/dale/Form/Proc/Inst/Inst.cpp
                 src/dale/Form/TopLevel/Namespace/Namespace.cpp
                 src/dale/Form/TopLevel/UsingNamespace/UsingNamespace.cpp
                 src/dale/Form/TopLevel/Include/Include.cpp
                 src/dale/Form/TopLevel/Do/Do.cpp
                 src/dale/Form/TopLevel/GlobalVariable/GlobalVariable.cpp
                 src/dale/Form/TopLevel/Function/Function.cpp
                 src/dale/Form/TopLevel/Struct/Struct.cpp
                 src/dale/Form/TopLevel/Macro/Macro.cpp
                 src/dale/Form/Struct/Struct.cpp
                 src/dale/Form/TopLevel/Def/Def.cpp
                 src/dale/Form/TopLevel/Module/Module.cpp
                 src/dale/Form/TopLevel/Import/Import.cpp
                 src/dale/Form/TopLevel/Inst/Inst.cpp
                 src/dale/Form/Initialiser/Struct/Struct.cpp
                 src/dale/Form/Initialiser/Array/Array.cpp
                 src/dale/CoreForms/CoreForms.cpp
                 src/dale/Label/Label.cpp
                 src/dale/CommonDecl/CommonDecl.cpp
                 src/dale/Unit/Unit.cpp
                 src/dale/Units/Units.cpp
                 src/dale/DNodeConverter/DNodeConverter.cpp
                 src/dale/MacroProcessor/MacroProcessor.cpp
                 src/dale/Operation/Coerce/Coerce.cpp
                 src/dale/FunctionProcessor/FunctionProcessor.cpp
                 src/dale/Operation/Destruct/Destruct.cpp
                 src/dale/Operation/Copy/Copy.cpp
                 src/dale/Operation/CloseScope/CloseScope.cpp
                 src/dale/Form/Parameter/Parameter.cpp
                 src/dale/Module/Reader/Reader.cpp
                 src/dale/SavePoint/SavePoint.cpp
                 src/dale/Form/Utils/Utils.cpp
                 src/dale/Form/Proc/Include/Include.cpp
                 src/dale/Form/Literal/Literal.cpp
                 src/dale/Form/Value/Value.cpp)
set_target_properties (dale PROPERTIES VERSION ${Dale_VERSION})
set_target_properties (dale PROPERTIES SOVERSION ${Dale_VERSION_MAJOR})
set_target_properties (dale PROPERTIES COMPILE_FLAGS "${LLVM_CXX_FLAGS} -I. -I${SOURCE_PATH}/lib")

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set_target_properties (dale PROPERTIES LINK_FLAGS "${FFI_LIB_FLAGS} ${FFI_LINK_FLAGS} ${LLVM_LINK_FLAGS}")
    target_link_libraries (dale ${LLVM_LIBS} ${LLVM_LINK_FLAGS})
else()
    set_target_properties (dale PROPERTIES LINK_FLAGS "${DALEC_LINK_FLAGS} ${LLVM_LINK_FLAGS} -rdynamic")
    target_link_libraries (dale ${LLVM_LIBS} ${DALEC_LINK_FLAGS} ${LLVM_LINK_FLAGS})
endif()

install (TARGETS dale LIBRARY DESTINATION lib)

add_executable(daleci src/dale/daleci.cpp)
target_link_libraries (daleci dale)
set_target_properties (daleci PROPERTIES COMPILE_FLAGS "/options:strict ${LLVM_CXX_FLAGS} -I. -I${SOURCE_PATH}/lib")
install (TARGETS daleci DESTINATION bin)

add_executable(dalec src/dale/dalec.cpp)
target_link_libraries (dalec dale)
set_target_properties (dalec PROPERTIES COMPILE_FLAGS "/options:strict ${LLVM_CXX_FLAGS} -I. -I${SOURCE_PATH}/lib")
install (TARGETS dalec DESTINATION bin)

# Run tests.

add_custom_target (tests COMMAND ${CMAKE_SOURCE_DIR}/run-tests ${CMAKE_SOURCE_DIR})
add_dependencies (tests dalec cstdio cstring pthread cfloat ctype cerrno ctime clocale cstdio-core stdlib assert concepts math cstdlib csetjmp csignal unistd shared-ptr unique-ptr vector list set map array algorithms derivations)

# Manfile for the compiler.

add_custom_target (documentation ALL DEPENDS man/dalec.1.gz)
install (FILES man/dalec.1.gz DESTINATION ${CMAKE_INSTALL_MANDIR}/man1)
install (FILES man/daleci.1.gz DESTINATION ${CMAKE_INSTALL_MANDIR}/man1)

# Dale programs.  (module-to-markdown was previously built with
# --static-modules, but there's a problem with that option in some
# environments: see #42.)

add_custom_command (OUTPUT  module-to-markdown
                    COMMAND ${CMAKE_BINARY_DIR}/dalec
                            ${CMAKE_SOURCE_DIR}/eg/module-to-markdown/module-to-markdown.dt
                            -lm -O4
                            -o module-to-markdown)
add_custom_target (programs ALL DEPENDS module-to-markdown)
add_dependencies (programs dalec vector derivations algorithms macros enum)

# Module documentation.

add_custom_target (doc COMMAND ${CMAKE_SOURCE_DIR}/generate-docs ${CMAKE_SOURCE_DIR})
add_dependencies (doc dalec programs array variant)

# Compile and install standard library files.

add_custom_command (OUTPUT  libarithmetic.so
                    COMMAND ${CMAKE_BINARY_DIR}/dalec
                                -c ${CMAKE_SOURCE_DIR}/modules/arithmetic.dt
                                --no-arithmetic
                                --no-drt
                                --static-modules)
add_custom_target (arithmetic ALL DEPENDS libarithmetic.so)
add_dependencies (arithmetic dalec)
install (FILES          ${CMAKE_BINARY_DIR}/libarithmetic.so
                        ${CMAKE_BINARY_DIR}/libarithmetic-nomacros.so
                        ${CMAKE_BINARY_DIR}/libarithmetic.dtm
                        ${CMAKE_BINARY_DIR}/libarithmetic.bc
                        ${CMAKE_BINARY_DIR}/libarithmetic-nomacros.bc
         DESTINATION    lib/dale)

add_custom_command (OUTPUT  libdrt.so
                    COMMAND ${CMAKE_BINARY_DIR}/dalec
                                -c ${CMAKE_SOURCE_DIR}/modules/drt.dt
                                --no-drt
                                --static-modules)
add_custom_target (drt ALL DEPENDS libdrt.so)
add_dependencies (drt arithmetic)
install (FILES          ${CMAKE_BINARY_DIR}/libdrt.so
                        ${CMAKE_BINARY_DIR}/libdrt-nomacros.so
                        ${CMAKE_BINARY_DIR}/libdrt.dtm
                        ${CMAKE_BINARY_DIR}/libdrt.bc
                        ${CMAKE_BINARY_DIR}/libdrt-nomacros.bc
         DESTINATION    lib/dale)

# Extra 'make clean' files.

set (CLEAN_FILES "libdrt.so;libdrt.bc;libdrt.dtm;libdrt-nomacros.bc;libdrt-nomacros.so;libarithmetic.so;libarithmetic.bc;libarithmetic.dtm;libarithmetic-nomacros.bc;libarithmetic-nomacros.so")

macro (standard_library path name)
    add_custom_command(OUTPUT  lib${name}.so
                       COMMAND ${CMAKE_BINARY_DIR}/dalec
                               ${DALE_FLAGS}
                               -c ${CMAKE_SOURCE_DIR}/${path}
                       DEPENDS ${CMAKE_SOURCE_DIR}/${path})
    add_custom_target(${name} ALL DEPENDS lib${name}.so)
    add_dependencies(${name} dalec ${ARGV2} ${ARGV3} ${ARGV4} ${ARGV5})
    install (FILES          ${CMAKE_BINARY_DIR}/lib${name}.so
                            ${CMAKE_BINARY_DIR}/lib${name}-nomacros.so
                            ${CMAKE_BINARY_DIR}/lib${name}.dtm
                            ${CMAKE_BINARY_DIR}/lib${name}.bc
                            ${CMAKE_BINARY_DIR}/lib${name}-nomacros.bc
             DESTINATION    lib/dale)
    set (CLEAN_FILES "${CLEAN_FILES};lib${name}.so;lib${name}-nomacros.so;lib${name}.dtm;lib${name}.bc;lib${name}-nomacros.bc")
endmacro ()

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    standard_library (modules/darwin/cstdio-arch.dt  cstdio-arch  drt macros)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
    standard_library (modules/freebsd/cstdio-arch.dt  cstdio-arch  drt macros)
else ()
    standard_library (modules/linux/cstdio-arch.dt  cstdio-arch  drt macros)
endif ()
standard_library (modules/cstdio.dt  cstdio  drt cstdio-arch macros stdlib)
standard_library (modules/cstring.dt cstring drt)
standard_library (modules/pthread.dt pthread macros)
standard_library (modules/cfloat.dt  cfloat  macros stdlib)
standard_library (modules/cctype.dt  cctype  macros cstdio)
standard_library (modules/ctype.dt   ctype   macros cstdio cctype)
if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    standard_library (modules/darwin/cerrno-arch.dt  cerrno-arch  drt macros stdlib)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
    standard_library (modules/freebsd/cerrno-arch.dt  cerrno-arch  drt macros stdlib)
else ()
    standard_library (modules/linux/cerrno-arch.dt  cerrno-arch  drt macros stdlib)
endif ()
standard_library (modules/cerrno.dt  cerrno  drt cerrno-arch macros stdlib)
standard_library (modules/ctime.dt    ctime  macros)
standard_library (modules/clocale.dt clocale drt)
standard_library (modules/cstdio-core.dt  cstdio-core  drt)
standard_library (modules/introspection.dt   introspection  drt)
standard_library (modules/macros.dt  macros  cstdio-core introspection)
standard_library (modules/stdlib.dt  stdlib  macros introspection)
standard_library (modules/operator-macros.dt  operator-macros macros stdlib)
standard_library (modules/assert.dt  assert  macros cstdio cstdlib stdlib)
standard_library (modules/concepts-core.dt    concepts-core macros assert unistd cstring)
standard_library (modules/concept-defs.dt    concept-defs      concepts-core)
standard_library (modules/concepts.dt    concepts      concept-defs)
standard_library (modules/cmath.dt   cmath   macros)
standard_library (modules/math.dt    math    drt cmath stdlib)
standard_library (modules/cstdlib.dt cstdlib drt macros stdlib)
standard_library (modules/csetjmp.dt  csetjmp  macros)
standard_library (modules/csignal.dt csignal  macros stdlib)
standard_library (modules/unistd.dt unistd  macros stdlib)
standard_library (modules/shared-ptr.dt shared-ptr  utility assert macros)
standard_library (modules/unique-ptr.dt unique-ptr  utility assert macros)

standard_library (modules/utility.dt  utility          concepts cstdio ctype)
standard_library (modules/vector.dt      vector        utility math)
standard_library (modules/list.dt        list          algorithms utility math)
standard_library (modules/set.dt         set           algorithms utility math)
standard_library (modules/map.dt         map           utility math set derivations)
standard_library (modules/array.dt       array         algorithms utility math derivations)
standard_library (modules/algorithms.dt  algorithms    utility)
standard_library (modules/derivations.dt derivations   utility)
standard_library (modules/enum.dt        enum          utility)
standard_library (modules/bitset-enum.dt bitset-enum   enum)
standard_library (modules/variant.dt     variant       enum)

set_directory_properties (PROPERTIES
                          ADDITIONAL_MAKE_CLEAN_FILES
                          "${CLEAN_FILES}")
