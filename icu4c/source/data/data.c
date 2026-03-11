#include "unicode/utypes.h"
#include <stdalign.h>

alignas(16) U_EXPORT const unsigned char U_ICUDATA_ENTRY_POINT[] = {
#if HAVE_EMBED
  // TODO: use #embed here
#else
#include "data.inc"
#endif
};
