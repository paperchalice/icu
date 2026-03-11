set(CMAKE_FOLDER test/perf)

message(WARNING "perf test currently not support")
return()

function(add_icu_perf_test name)
  add_icu_executable(${name} NO_INSTALL)
  add_test(NAME perf-${name}
    COMMAND ${PERL_EXECUTABLE} CharPerf.pl
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
  )
  set_tests_properties(perf-${name}
    PROPERTIES DISABLED $<NOT:$<BOOL:${Perl_FOUND}>>
  )
endfunction()

add_subdirectory(charperf)
add_subdirectory(collationperf)
add_subdirectory(collperf)
add_subdirectory(convperf)
add_subdirectory(DateFmtPerf)
add_subdirectory(dicttrieperf)
add_subdirectory(howExpensiveIs)
add_subdirectory(localecanperf)
add_subdirectory(normperf)
add_subdirectory(perldriver)
add_subdirectory(strsrchperf)
add_subdirectory(ubrkperf)
add_subdirectory(ucnvavailperf)
add_subdirectory(unisetperf)
add_subdirectory(usetperf)
add_subdirectory(ustrperf)
add_subdirectory(utfperf)
add_subdirectory(utrie2perf)
