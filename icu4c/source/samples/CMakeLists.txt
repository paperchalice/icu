if(ICU_DISABLE_SAMPLES)
  return()
endif()

set(CMAKE_FOLDER samples)

add_subdirectory(coll)
add_subdirectory(strsrch)
add_subdirectory(translit)
add_subdirectory(ugrep)
