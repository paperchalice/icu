cmake_minimum_required(VERSION 4.3)

project(ICU
  VERSION 79.0
  COMPAT_VERSION 79
  SPDX_LICENSE Unicode-3.0
  DESCRIPTION "International Components for Unicode"
  HOMEPAGE_URL https://icu.unicode.org/
  LANGUAGES C CXX
)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(GNUInstallDirs)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD 11)

option(BUILD_SHARED_LIBS "build using shared libraries" ON)

# TODO: option(ICU_DISABLE_ICU_CONFIG "do not install icu-config" OFF)
option(ICU_DISABLE_STRICT "do not compile with strict compiler options" OFF)
option(ICU_ENABLE_AUTO_CLEANUP "enable auto cleanup of libraries" OFF)
option(ICU_DISABLE_DRAFT "do not enable draft APIs (and internal APIs)" OFF)
option(ICU_DISABLE_RENAMING "do not add a version suffix to symbols" OFF)
option(ICU_ENABLE_TRACING "enable function and data tracing" OFF)
option(ICU_ENABLE_PLUGINS "enable plugins" OFF)
option(ICU_DISABLE_DYLOAD "disable dynamic loading" OFF)
option(ICU_ENABLE_RPATH "use rpath when linking default is only if necessary" OFF)
# TODO: option(ICU_ENABLE_WEAK_THREADS "weakly reference the threading library" OFF)
option(ICU_DISABLE_EXTRAS "do not build ICU extras" OFF)
option(ICU_DISABLE_ICUIO "do not build ICU's icuio library" OFF)
option(ICU_ENABLE_LAYOUTEX "build ICU's Paragraph Layout library, icu-le-hb must be installed via pkg-config. See http://harfbuzz.org" OFF)
option(ICU_DISABLE_TOOLS "do not build ICU's tools" OFF)
option(ICU_ENABLE_FUZZER "build ICU's fuzzer test targets" OFF)
option(ICU_DISABLE_SAMPLES "do not build ICU samples" OFF)
option(ICU_INSTALL_CMAKE_EXPORT "install cmake package (conflict with FindICU!)" OFF)
option(ICU_USE_EMBED "use #embed if possible" OFF)

# option(ICU_WITH_LIBRARY_BITS "specify how many bits to use for the library (32, 64, 64else32, nochange) default=nochange" nochange)
# set_property(CACHE ICU_WITH_LIBRARY_BITS PROPERTY STRINGS "32;64;64else32;nochange")
option(ICU_WITH_DATA_PACKAGING [[
        archive  build a single icudtXX.dat file
        library  shared library (.dll/.so/etc.)
        static   static library (.a/.lib/etc.)
        auto     build shared if possible (default)
        See https://unicode-org.github.io/icu/userguide/icu_data for more info.
]] auto)
set_property(CACHE ICU_WITH_DATA_PACKAGING PROPERTY STRINGS "archive;library;static;auto")
set(CACHE{ICU_WITH_LIBRARY_SUFFIX} TYPE STRING HELP "tag a suffix to the library names default=" VALUE "")

# internal options
option(ICU_IS_BOOTSTRAPPING "is this build for bootstrapping" OFF)
mark_as_advanced(FORCE ICU_IS_BOOTSTRAPPING)

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH ${ICU_ENABLE_RPATH})


if(ICU_IS_BOOTSTRAPPING)
  set(CACHE{BUILD_SHARED_LIBS} FORCE VALUE OFF)
  set(CACHE{ICU_DISABLE_SAMPLES} FORCE VALUE ON)
  set(CACHE{BUILD_TESTING} FORCE VALUE OFF)
endif()

set_property(GLOBAL APPEND PROPERTY DEBUG_CONFIGURATIONS Debug)
set(CMAKE_DEBUG_POSTFIX d)

if(MSVC)
  # disable exceptions
  block()
  string(REPLACE "/EHsc" "" new_cxx_flags $CACHE{CMAKE_CXX_FLAGS})
  set(CACHE{CMAKE_CXX_FLAGS} FORCE VALUE ${new_cxx_flags})
  endblock()
endif()

include(AddICUTarget)

include(CTest)
add_subdirectory(source)

add_subdirectory(cmake)
