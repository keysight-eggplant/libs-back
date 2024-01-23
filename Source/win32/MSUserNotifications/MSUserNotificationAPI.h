########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: 58ca6b5c8eade494f10a3bf60bc4968e7c5234ca
# Date: 2016-05-11 20:46:04 +0000
########## End of Keysight Technologies Notice ##########
#pragma once

#include <string>

#if defined(__cplusplus)
extern "C" { // Only if you are using C++ rather than C
#endif

typedef struct _SEND_NOTE_INFO
{
  const char *uuidString;
  const char *title;
  const char *informativeText;
  HICON       contentIcon;
  const char *appIconPath;
} SEND_NOTE_INFO_T, *SEND_NOTE_INFO_PTR;

typedef struct _REMOVE_NOTE_INFO
{
  UINT uniqueID;
} REMOVE_NOTE_INFO_T, *REMOVE_NOTE_INFO_PTR;

#if defined(__cplusplus)
}
#endif
