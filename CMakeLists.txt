# Set root project name
set(ROOT_PROJECT_NAME template)

# DO NOT EDIT THE BELOW!

# Set minimum CMake version required
cmake_minimum_required(VERSION 3.16.3)
cmake_policy(SET CMP0126 NEW)
macro(override_default var override)
  get_property(
    CURRENT_TYPE
    CACHE ${var}
    PROPERTY TYPE)
  if(NOT DEFINED CURRENT_TYPE)
    set(${var} ${override})
  endif()
endmacro()
macro(update_cache var type)
  get_property(
    CURRENT_TYPE
    CACHE ${var}
    PROPERTY TYPE)
  if(DEFINED CURRENT_TYPE)
    set(type ${CURRENT_TYPE})
  endif()
  get_property(
    CURRENT_HELPSTRING
    CACHE ${var}
    PROPERTY HELPSTRING)
  set(${var}
      ${${var}}
      CACHE ${type} "${CURRENT_HELPSTRING}" FORCE)
endmacro()

# Override default generator
if(CMAKE_GENERATOR STREQUAL "Ninja")
  configure_file(${CMAKE_SOURCE_DIR}/Makefile ./Makefile COPYONLY)
  override_default(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
else()
  override_default(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
endif()
override_default(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

# Override default C/C++ compiler
override_default(CMAKE_C_COMPILER "clang")
override_default(CMAKE_CXX_COMPILER "clang++")
update_cache(CMAKE_C_COMPILER FILEPATH)
update_cache(CMAKE_CXX_COMPILER FILEPATH)

# Override default C/C++ standard and extension to use
override_default(CMAKE_C_STANDARD "11")
override_default(CMAKE_C_EXTENSIONS TRUE)
override_default(CMAKE_CXX_STANDARD "20")
override_default(CMAKE_CXX_EXTENSIONS TRUE)

# Set our C/C++ default build flags
set(C_FLAGS
    -fdiagnostics-color=always
    -frecord-gcc-switches
    -save-temps=obj
    -masm=intel
    -fverbose-asm
    -Wall
    -Wextra
    -Werror)
set(CXX_FLAGS ${C_FLAGS})

# Set our C/C++ `Debug` build flags
set(FLAGS_DEBUG_COMMON -fno-omit-frame-pointer -g3 -gdwarf-5)
set(C_FLAGS_DEBUG -Og ${FLAGS_DEBUG_COMMON})
set(CXX_FLAGS_DEBUG ${C_FLAGS_DEBUG})

# Set our C/C++ `Release` build flags
set(C_FLAGS_REL_COMMON -DNDEBUG -march=native -ftree-vectorize)
set(CXX_FLAGS_REL_COMMON ${C_FLAGS_REL_COMMON})
set(GCC_FLAGS_REL_COMMON -fvect-cost-model=very-cheap)
if(CMAKE_C_COMPILER MATCHES ".*gcc.*")
  set(C_FLAGS_REL_COMMON ${C_FLAGS_REL_COMMON} ${GCC_FLAGS_REL_COMMON})
endif()
if(CMAKE_CXX_COMPILER MATCHES "^(g.+.+.*|.*-g.+.+.*)$")
  set(CXX_FLAGS_REL_COMMON ${CXX_FLAGS_REL_COMMON} ${GCC_FLAGS_REL_COMMON})
endif()
set(C_FLAGS_RELEASE -O2)
set(C_FLAGS_MINSIZEREL -Os -fmerge-all-constants -ffunction-sections
                       -fdata-sections)
set(C_FLAGS_RELWITHDEBINFO -O2 ${FLAGS_DEBUG_COMMON})
set(CXX_FLAGS_RELEASE ${C_FLAGS_RELEASE} ${CXX_FLAGS_REL_COMMON})
set(CXX_FLAGS_MINSIZEREL ${C_FLAGS_MINSIZEREL} ${CXX_FLAGS_REL_COMMON})
set(CXX_FLAGS_RELWITHDEBINFO ${C_FLAGS_RELWITHDEBINFO} ${CXX_FLAGS_REL_COMMON})
set(C_FLAGS_RELEASE ${C_FLAGS_RELEASE} ${C_FLAGS_REL_COMMON})
set(C_FLAGS_MINSIZEREL ${C_FLAGS_MINSIZEREL} ${C_FLAGS_REL_COMMON})
set(C_FLAGS_RELWITHDEBINFO ${C_FLAGS_RELWITHDEBINFO} ${C_FLAGS_REL_COMMON})
set(CLANG_FLAGS_LTO -flto=full)
set(GCC_FLAGS_LTO -flto -ffat-lto-objects)
if(CMAKE_C_COMPILER MATCHES ".*clang.*")
  set(C_FLAGS_MINSIZEREL ${C_FLAGS_MINSIZEREL} ${CLANG_FLAGS_LTO})
elseif(CMAKE_C_COMPILER MATCHES ".*gcc.*")
  set(C_FLAGS_MINSIZEREL ${C_FLAGS_MINSIZEREL} ${GCC_FLAGS_LTO})
endif()
if(CMAKE_CXX_COMPILER MATCHES ".*clang.+.+.*")
  set(CXX_FLAGS_MINSIZEREL ${CXX_FLAGS_MINSIZEREL} ${CLANG_FLAGS_LTO})
elseif(CMAKE_CXX_COMPILER MATCHES "^(g.+.+.*|.*-g.+.+.*)$")
  set(CXX_FLAGS_MINSIZEREL ${CXX_FLAGS_MINSIZEREL} ${GCC_FLAGS_LTO})
endif()

# Set our linker flags
set(LINKER lld)
override_default(CMAKE_LINKER "ld.${LINKER}")
set(LINKER_FLAGS_COMMON -fuse-ld=${LINKER} -Wl,--no-whole-archive
                        -Wl,--as-needed -Wl,--gc-sections)
set(LINKER_FLAGS_DEBUG -Wl,--export-dynamic)
set(LINKER_FLAGS_RELEASE -Wl,--strip-all)

# Handle build type
override_default(CMAKE_BUILD_TYPE "Debug")
string(REPLACE ";" " " C_FLAGS "${C_FLAGS}")
string(REPLACE ";" " " C_FLAGS_DEBUG "${C_FLAGS_DEBUG}")
string(REPLACE ";" " " C_FLAGS_RELEASE "${C_FLAGS_RELEASE}")
string(REPLACE ";" " " C_FLAGS_MINSIZEREL "${C_FLAGS_MINSIZEREL}")
string(REPLACE ";" " " C_FLAGS_RELWITHDEBINFO "${C_FLAGS_RELWITHDEBINFO}")
string(REPLACE ";" " " CXX_FLAGS "${CXX_FLAGS}")
string(REPLACE ";" " " CXX_FLAGS_DEBUG "${CXX_FLAGS_DEBUG}")
string(REPLACE ";" " " CXX_FLAGS_RELEASE "${CXX_FLAGS_RELEASE}")
string(REPLACE ";" " " CXX_FLAGS_MINSIZEREL "${CXX_FLAGS_MINSIZEREL}")
string(REPLACE ";" " " CXX_FLAGS_RELWITHDEBINFO "${CXX_FLAGS_RELWITHDEBINFO}")
string(REPLACE ";" " " LINKER_FLAGS_COMMON "${LINKER_FLAGS_COMMON}")
string(REPLACE ";" " " LINKER_FLAGS_DEBUG "${LINKER_FLAGS_DEBUG}")
string(REPLACE ";" " " LINKER_FLAGS_RELEASE "${LINKER_FLAGS_RELEASE}")
override_default(CMAKE_C_FLAGS ${C_FLAGS})
override_default(CMAKE_C_FLAGS_DEBUG ${C_FLAGS_DEBUG})
override_default(CMAKE_C_FLAGS_RELEASE ${C_FLAGS_RELEASE})
override_default(CMAKE_C_FLAGS_MINSIZEREL ${C_FLAGS_MINSIZEREL})
override_default(CMAKE_C_FLAGS_RELWITHDEBINFO ${C_FLAGS_RELWITHDEBINFO})
override_default(CMAKE_CXX_FLAGS ${CXX_FLAGS})
override_default(CMAKE_CXX_FLAGS_DEBUG ${CXX_FLAGS_DEBUG})
override_default(CMAKE_CXX_FLAGS_RELEASE ${CXX_FLAGS_RELEASE})
override_default(CMAKE_CXX_FLAGS_MINSIZEREL ${CXX_FLAGS_MINSIZEREL})
override_default(CMAKE_CXX_FLAGS_RELWITHDEBINFO ${CXX_FLAGS_RELWITHDEBINFO})
override_default(CMAKE_EXE_LINKER_FLAGS ${LINKER_FLAGS_COMMON})
override_default(CMAKE_EXE_LINKER_FLAGS_DEBUG ${LINKER_FLAGS_DEBUG})
override_default(CMAKE_EXE_LINKER_FLAGS_RELEASE ${LINKER_FLAGS_RELEASE})
override_default(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL ${LINKER_FLAGS_RELEASE})
override_default(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO ${LINKER_FLAGS_DEBUG})
override_default(CMAKE_SHARED_LINKER_FLAGS ${LINKER_FLAGS_COMMON})
override_default(CMAKE_SHARED_LINKER_FLAGS_DEBUG ${LINKER_FLAGS_DEBUG})
override_default(CMAKE_SHARED_LINKER_FLAGS_RELEASE ${LINKER_FLAGS_RELEASE})
override_default(CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL ${LINKER_FLAGS_RELEASE})
override_default(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO ${LINKER_FLAGS_DEBUG})
override_default(CMAKE_MODULE_LINKER_FLAGS ${LINKER_FLAGS_COMMON})
override_default(CMAKE_MODULE_LINKER_FLAGS_DEBUG ${LINKER_FLAGS_DEBUG})
override_default(CMAKE_MODULE_LINKER_FLAGS_RELEASE ${LINKER_FLAGS_RELEASE})
override_default(CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL ${LINKER_FLAGS_RELEASE})
override_default(CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO ${LINKER_FLAGS_DEBUG})

# Set output path
override_default(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
override_default(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
override_default(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")

# Set install path
override_default(CMAKE_INSTALL_PREFIX "/usr/local")

# Declare top-level project
project(${ROOT_PROJECT_NAME})

# Update cache after project initialization
update_cache(CMAKE_BUILD_WITH_INSTALL_RPATH BOOL)
update_cache(CMAKE_EXPORT_COMPILE_COMMANDS BOOL)
update_cache(CMAKE_LINKER FILEPATH)
update_cache(CMAKE_C_STANDARD STRING)
update_cache(CMAKE_C_EXTENSIONS BOOL)
update_cache(CMAKE_CXX_STANDARD STRING)
update_cache(CMAKE_CXX_EXTENSIONS BOOL)
update_cache(CMAKE_BUILD_TYPE STRING)
update_cache(CMAKE_C_FLAGS STRING)
update_cache(CMAKE_C_FLAGS_DEBUG STRING)
update_cache(CMAKE_C_FLAGS_RELEASE STRING)
update_cache(CMAKE_C_FLAGS_MINSIZEREL STRING)
update_cache(CMAKE_C_FLAGS_RELWITHDEBINFO STRING)
update_cache(CMAKE_CXX_FLAGS STRING)
update_cache(CMAKE_CXX_FLAGS_DEBUG STRING)
update_cache(CMAKE_CXX_FLAGS_RELEASE STRING)
update_cache(CMAKE_CXX_FLAGS_MINSIZEREL STRING)
update_cache(CMAKE_CXX_FLAGS_RELWITHDEBINFO STRING)
update_cache(CMAKE_EXE_LINKER_FLAGS STRING)
update_cache(CMAKE_EXE_LINKER_FLAGS_DEBUG STRING)
update_cache(CMAKE_EXE_LINKER_FLAGS_RELEASE STRING)
update_cache(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL STRING)
update_cache(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO STRING)
update_cache(CMAKE_SHARED_LINKER_FLAGS STRING)
update_cache(CMAKE_SHARED_LINKER_FLAGS_DEBUG STRING)
update_cache(CMAKE_SHARED_LINKER_FLAGS_RELEASE STRING)
update_cache(CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL STRING)
update_cache(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO STRING)
update_cache(CMAKE_MODULE_LINKER_FLAGS STRING)
update_cache(CMAKE_MODULE_LINKER_FLAGS_DEBUG STRING)
update_cache(CMAKE_MODULE_LINKER_FLAGS_RELEASE STRING)
update_cache(CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL STRING)
update_cache(CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO STRING)
update_cache(CMAKE_RUNTIME_OUTPUT_DIRECTORY PATH)
update_cache(CMAKE_ARCHIVE_OUTPUT_DIRECTORY PATH)
update_cache(CMAKE_LIBRARY_OUTPUT_DIRECTORY PATH)
update_cache(CMAKE_INSTALL_PREFIX PATH)

# Add CMake source subdirectories
add_subdirectory(lib)
