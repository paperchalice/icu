# FIXME: did not build
message(WARNING "Currently not support: ${CMAKE_CURRENT_LIST_DIR}")
return()

add_icu_perf_test(howExpensiveIs)
target_sources(howExpensiveIs
  PRIVATE
  howExpensiveIs.cpp
  sieve.cpp
)
target_link_libraries(howExpensiveIs
  PRIVATE
  ctestfw tu
)
