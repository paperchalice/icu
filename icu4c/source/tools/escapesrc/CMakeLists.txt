add_icu_executable(tblgen)
target_sources(tblgen PRIVATE tblgen.cpp)
target_link_libraries(tblgen PRIVATE uc)
set_target_properties(tblgen PROPERTIES EXCLUDE_FROM_ALL ON)

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_LIST_DIR}/cptbl.h
    COMMAND tblgen > ${CMAKE_CURRENT_LIST_DIR}/cptbl.h
)
add_custom_target(gen_table COMMAND tblgen > ${CMAKE_CURRENT_LIST_DIR}/cptbl.h)

add_icu_executable(escapesrc)
target_sources(escapesrc PRIVATE escapesrc.cpp)
target_link_libraries(escapesrc PRIVATE uc)
install_icu_target(escapesrc)
