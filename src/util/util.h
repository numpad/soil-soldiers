#ifndef UTIL_H
#define UTIL_H

#include <stddef.h>

// defines
#define UTIL_FOR(_i, max) for (size_t _i = 0; _i < max; ++_i)

// string utils
const char *str_match_bracket(const char *str, size_t len, char open, char close);

#endif

