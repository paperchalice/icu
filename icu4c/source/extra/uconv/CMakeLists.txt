message(WARNING "Currently not support: ${CMAKE_CURRENT_LIST_DIR}")
return()
add_icu_executable(uconv)
target_sources(uconv
  PRIVATE
  uconv.cpp
)
target_compile_definitions(uconv
  PRIVATE
  UCONVMSG_LINK
)
target_link_libraries(uconv
  PRIVATE
  in
)
