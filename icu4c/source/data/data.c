#include "unicode/utypes.h"
#include <stdalign.h>

alignas(16) U_EXPORT const unsigned char U_ICUDATA_ENTRY_POINT[] = {
#if HAVE_EMBED
#embed ICU_DAT_FILE
#else
#include "data.inc"
#endif
};
