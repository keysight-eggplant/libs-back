########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: d9947de1b5f9dba597ae665fc4a3073b589aec3c
# Date: 2017-06-22 20:00:16 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 25949d2ae1182a3b18fccf1b0e9eb8c00cb01ce7
# Date: 2016-11-25 17:02:59 +0000
--------------------
# Committed by: Paul Landers
# Commit ID: 71864f8dea9a7fe625662d2b4c8bc2ba915bafde
# Date: 2016-10-12 16:30:03 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 09301e648cdda5d430a51d11ec75dcafacf04878
# Date: 2013-05-19 19:45:05 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: aae0f7748c44cc465e02c8ce9cccfdc4a0bbfbf4
# Date: 2012-11-21 20:53:22 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: f018376f1267e7b494ff529b86e7e819ebe1998a
# Date: 2012-11-14 19:06:57 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 7a892f25ce6b4ecb2083a7ebf30d22e3c9799e66
# Date: 2012-08-29 21:34:21 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: c276a5d4d01387a2f390178047a867f57a0526d3
# Date: 2012-08-08 22:27:23 +0000
########## End of Keysight Technologies Notice ##########
/* WIN32Server - Implements window handling for MSWindows

   Copyright (C) 2005 Free Software Foundation, Inc.

   Written by: Fred Kiefer <FredKiefer@gmx.de>
   Date: March 2002
   Part of this code have been re-written by:
   Tom MacSween <macsweent@sympatico.ca>
   Date August 2005
   This file is part of the GNU Objective C User Interface Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; see the file COPYING.LIB.
   If not, see <http://www.gnu.org/licenses/> or write to the 
   Free Software Foundation, 51 Franklin Street, Fifth Floor, 
   Boston, MA 02110-1301, USA.
*/

#include "config.h"
#include <AppKit/NSEvent.h>
#include <AppKit/NSWindow.h>
#include <Foundation/NSBundle.h>

#include "win32/WIN32Server.h"
#include "win32/WIN32Geometry.h"

@implementation WIN32Server (w32_create)


- (LRESULT) decodeWM_NCCREATEParams: (WPARAM)wParam : (LPARAM)lParam 
                                   : (HWND)hwnd
{
  return TRUE;
}

- (LRESULT) decodeWM_CREATEParams: (WPARAM)wParam : (LPARAM)lParam 
                                 : (HWND)hwnd
{
  WIN_INTERN *win;
  IME_INFO_T *ime;
  NSBackingStoreType type = (NSBackingStoreType)((LPCREATESTRUCT)lParam)->lpCreateParams;
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *iconName = nil;
  NSString *iconPath = nil;

  // Initialize the window. 
  NSDebugLLog(@"NSEvent", @"Got Message %s for %d", "CREATE", hwnd);
  /* For windows with backingstore we create a compatible DC, that 
	   is stored in the extra fields for this window. Drawing operations 
	   work on this buffer. */
  win = malloc(sizeof(WIN_INTERN));
  ime = malloc(sizeof(IME_INFO_T));
  
  // Initialize win internals structure...
  memset(win, 0, sizeof(WIN_INTERN));
  memset(ime, 0, sizeof(IME_INFO_T));
  win->type = type;
  win->useHDC = NO;

  // Save win internals structure pointer for window handle...
  SetWindowLongPtr(hwnd, GWLP_USERDATA, (LONG_PTR)win);
  SetWindowLongPtr(hwnd, IME_INFO, (LONG_PTR)ime);

  [self windowbacking: type : (NSInteger)hwnd];

  // Find the icon file, assume it has the same name as the "icon" which
  // was specified in the bundle's dictionary...
  iconName = [[bundle infoDictionary] objectForKey: @"NSIcon"];
  if (iconName == nil)
    {
      iconName = [[bundle infoDictionary] 
		    objectForKey: @"CFBundleIconFile"];
    }

  // If the icon name is set, get the path...
  if (iconName != nil)
    {
      iconName = [iconName stringByDeletingPathExtension];
      iconPath = [[NSBundle mainBundle] pathForResource: iconName 
						 ofType: @"ico"];
      iconPath = [iconPath stringByStandardizingPath];
    }
  
  // If the path is set, load the icon file and set it as the
  // icon on the window.
  if (iconPath != nil)
    {
      HICON icon = NULL;
      const char *cpath = [iconPath cString];
      
      icon = LoadImage(NULL, 
		       cpath,
		       IMAGE_ICON,0,0,
		       LR_DEFAULTSIZE|LR_LOADFROMFILE);
      HICON oldIcon = (HICON)SetClassLongPtr(hwnd,GCLP_HICON,(LONG_PTR)icon);
      if (oldIcon != NULL)
        DestroyIcon(oldIcon);
    }

  return 0;
}
@end
