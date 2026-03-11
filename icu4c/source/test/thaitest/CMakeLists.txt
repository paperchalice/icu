add_icu_test(thaitest)
target_sources(thaitest
  PRIVATE
  thaitest.cpp
)
target_link_libraries(thaitest
  PRIVATE
  uc
)

set_tests_properties(thaitest
  PROPERTIES
  ENVIRONMENT_MODIFICATION
  "PATH=path_list_append:$<TARGET_FILE_DIR:uc>;PATH=path_list_append:$<TARGET_FILE_DIR:dt>"
)
