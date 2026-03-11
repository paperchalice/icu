build_icu_data(testdata
  TMP_DIR testdata
  OUT_DIR build
)

build_icu_data_pkg(testdata
  DATA_NAME testdata
  MODE common
  OUT_DEP obj_dep
  SRC_DIR build
  DST_DIR  ${CMAKE_CURRENT_LIST_DIR}/out
  TMP_DIR build
  LST_DIR testdata
)

add_custom_target(testdata
  DEPENDS ${obj_dep}
)
