include(GenDataRules)
include(AddICUData)

set(tgt_name data)
set(tgt_alias dt)
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set(tgt_name dt)
    set(tgt_alias data)
endif()

if(CMAKE_C_BYTE_ORDER STREQUAL "BIG_ENDIAN")
    set(ICUDATA_CHAR "b")
else()
    set(ICUDATA_CHAR "l")
endif()
set(ICUDATA_PLATFORM_NAME "icudt${ICU_VERSION_MAJOR}${ICUDATA_CHAR}")
set(ICUDATA_OUT_DIR
    "${CMAKE_CURRENT_BINARY_DIR}/out/build/${ICUDATA_PLATFORM_NAME}"
)
set(ICUDATA_TMP_DIR "${CMAKE_CURRENT_BINARY_DIR}/out/tmp")

gen_data_rules()
include(SetupNativeICU)

include(rules.cmake)

add_icu_dat(${ICUDATA_PLATFORM_NAME}
    SOURCE_DIR ${ICUDATA_OUT_DIR}
    DEST_DIR ${ICUDATA_TMP_DIR}
    LIST_FILE ${ICUDATA_TMP_DIR}/icudata.lst
    MODE ${ICU_WITH_DATA_PACKAGING}
    DEPENDS ${ICUDATA_ALL_OUTPUT_FILES} ICU_NATIVE
    ENTRY U_ICUDATA_ENTRY_POINT
    TARGET ${tgt_name}
    ICUPKG_TOOL ${ICU_TOOL_PREFIX}/icupkg
)

add_library(${tgt_alias} ALIAS ${tgt_name})

install_icu_target(data)
