add_icu_executable(genrb)
target_sources(genrb
  PRIVATE
  errmsg.c
  filterrb.cpp
  genrb.cpp
  parse.cpp
  prscmnts.cpp
  rbutil.c
  read.c
  reslist.cpp
  rle.c
  ustr.c
  wrtjava.cpp
  wrtxml.cpp
)
target_link_libraries(genrb
  PRIVATE
  tu
)
configure_file(genrb.1.in genrb.1 @ONLY)
install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/genrb.1
  DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
  COMPONENT Doc
)

if(NOT ICU_IS_BOOTSTRAPPING)
  add_icu_executable(derb)
  target_sources(derb
    PRIVATE
    derb.cpp
  )
  target_link_libraries(derb
    PRIVATE
    tu io
  )

  configure_file(derb.1.in derb.1 @ONLY)
  install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/derb.1
    DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
    COMPONENT Doc
  )
endif()
