
# TODO: add icu-le-hb support
message(WARNING "Currently not support: ${CMAKE_CURRENT_LIST_DIR}")
return()

add_icu_test(letest)
target_sources(letest
  PRIVATE
  letest.cpp
)
target_link_libraries(letest
  PRIVATE
  ctestfw
)
