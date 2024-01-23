########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: f9303f7bbd9cecf24d5930e06c828c902d074bfc
# Date: 2016-05-29 20:28:36 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: c6a0e4c4bc5e75eca1ad01ab1b0d40b8ca635b81
# Date: 2016-05-26 16:37:08 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 6712f810fa4f127b371e3e32fa02cc889c0ffb93
# Date: 2016-05-26 14:13:26 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 58ca6b5c8eade494f10a3bf60bc4968e7c5234ca
# Date: 2016-05-11 20:46:04 +0000
########## End of Keysight Technologies Notice ##########
// stdafx.cpp : source file that includes just the standard includes
// ToastNotifications.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"
#include <string>
#include <sstream>

void dll_log_s(const char *function, int line, const char *format, ...)
{
  static const size_t STRBUFSIZE = 512;
  static char str[STRBUFSIZE];
  std::stringstream message;
  va_list argptr;
  va_start(argptr, format);
  sprintf_s(str, STRBUFSIZE, "%s:%d: ", function, line);
  vsprintf_s(&str[strlen(str)], STRBUFSIZE - strlen(str), format, argptr);
  OutputDebugStringA(str);
  va_end(argptr);
}

void dll_logw_s(const wchar_t *function, int line, const wchar_t *format, ...)
{
  static const size_t STRBUFSIZE = 512;
  static wchar_t wstr[STRBUFSIZE];
  va_list argptr;
  va_start(argptr, format);
  swprintf_s(wstr, STRBUFSIZE, TEXT("%s:%d: "), function, line);
  vswprintf_s(&wstr[_tcslen(wstr)], STRBUFSIZE - _tcslen(wstr), format, argptr);
  OutputDebugStringW(wstr);
  va_end(argptr);
}
