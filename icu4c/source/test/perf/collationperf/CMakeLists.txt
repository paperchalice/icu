message(WARNING "Currently not support: ${CMAKE_CURRENT_LIST_DIR}")
return()
add_icu_perf_test(collationperf)
target_sources(collationperf
  PRIVATE
  collperf.cpp
)
target_link_libraries(collationperf
  PRIVATE
  ctestfw tu
)
