#! /usr/bin/env cmake -P

set(content
    [[
// © 2016 and later: Unicode, Inc. and others.
// License & terms of use: http://www.unicode.org/copyright.html
/******************************************************************************
*
*   Copyright (C) 2001, International Business Machines
*   Corporation and others.  All Rights Reserved.
*
*******************************************************************************
*   file name:  data.c.in
*
*   data template code
*/

#include "unicode/utypes.h"
#include <stdalign.h>

U_EXPORT alignas(16) const char ${ICU_DATA_ENTRY_POINT}[]  = {
#if __STDC_VERSION__ >= 202311L
#embed "${ICU_DATA_PATH}"
#else
#include "${ICU_DATA_PATH}"
#endif
};
]]
)

if(NOT DEFINED ICU_DATA_ENTRY)
    set(ICU_DATA_ENTRY ${ICU_DATA_NAME}_dat)
endif()

if(NOT DEFINED ICU_DATA_PATH)
    set(ICU_DATA_PATH ${CMAKE_CURRENT_SOURCE_DIR}/${ICU_DATA_NAME}.dat)
endif()

string(MAKE_C_IDENTIFIER ${ICU_DATA_ENTRY} ICU_DATA_ENTRY_POINT)

file(CONFIGURE OUTPUT ${ICU_DATA_NAME}.c CONTENT "${content}")
