foreach(tgt dtfmtrtperf normperf simplenormperf)
  add_icu_perf_test(${tgt})
  target_sources(${tgt}
    PRIVATE
    ${tgt}.cpp
  )
  target_link_libraries(${tgt}
    PRIVATE
    ctestfw
  )
endforeach()
