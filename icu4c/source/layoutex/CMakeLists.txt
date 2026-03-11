message(WARNING "Currently not support")
return()

add_icu_library(lx)
target_sources(lx
  PRIVATE
  LXUtilities.cpp
  ParagraphLayout.cpp
  RunArrays.cpp
  playout.cpp
  plruns.cpp
)
target_link_libraries(lx
  PUBLIC
  uc
)
