include(GenDataRules)
include(AddICUData)

gen_data_rules()
set(LIBRARY_DATA_DIR ${CMAKE_CURRENT_LIST_DIR})
set(ICUDATA_OUT_DIR
    "${CMAKE_CURRENT_BINARY_DIR}/out"
)
set(ICUDATA_TMP_DIR "${CMAKE_CURRENT_BINARY_DIR}/out/testdata")

include(rules.cmake)

add_icu_dat(testdata
    SOURCE_DIR ${ICUDATA_OUT_DIR}
    DEST_DIR ${ICUDATA_OUT_DIR}
    LIST_FILE ${ICUDATA_TMP_DIR}/testdata.lst
    DEPENDS ${TESTDATA_ALL_OUTPUT_FILES}
    MODE archive
)

add_custom_target(testdata
    DEPENDS "${ICUDATA_OUT_DIR}/testdata.dat"
)
