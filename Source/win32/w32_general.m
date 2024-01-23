########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: 25949d2ae1182a3b18fccf1b0e9eb8c00cb01ce7
# Date: 2016-11-25 17:02:59 +0000
--------------------
# Committed by: Paul Landers
# Commit ID: 71864f8dea9a7fe625662d2b4c8bc2ba915bafde
# Date: 2016-10-12 16:30:03 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: b379b7ff5b6adf407e3901502efde851f5d6cbee
# Date: 2013-10-21 18:00:44 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: 128d09da60de4b749d17101f9cb11508523d40c6
# Date: 2013-10-03 20:28:20 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: 1b82d912b55f817956e396273e2eb6816fa37389
# Date: 2013-08-09 14:21:15 +0000
--------------------
# Committed by: Doug Simons
# Commit ID: 2a6477c928c4ee4283280cee520f3be371841981
# Date: 2013-01-11 03:12:56 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: f018376f1267e7b494ff529b86e7e819ebe1998a
# Date: 2012-11-14 19:06:57 +0000
########## End of Keysight Technologies Notice ##########
/* WIN32Server - Implements window handling for MSWindows

   Copyright (C) 2005 Free Software Foundation, Inc.

   Written by: Fred Kiefer <FredKiefer@gmx.de>
   Date: March 2002
   Part of this code have been written by:
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

#include <AppKit/NSEvent.h>
#include <AppKit/NSWindow.h>
#include "win32/WIN32Server.h"
#include "win32/WIN32Geometry.h"
#include <GNUstepGUI/GSTheme.h>

@interface NSCursor (NSCursor_w32_General)

+ (NSMutableArray *) stack;
+ (void) resetStack;

@end


@implementation WIN32Server (w32_General)

- (void) decodeWM_CLOSEParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd
{
  NSEvent *ev;
  NSPoint eventLocation = NSMakePoint(0, 0);

  ev = [NSEvent otherEventWithType: NSAppKitDefined
		      location: eventLocation
		      modifierFlags: 0
		      timestamp: 0
		      windowNumber: (NSInteger)hwnd
		      context: GSCurrentContext()
		      subtype: GSAppKitWindowClose
		      data1: 0
		      data2: 0];
		    
  // Sending the event directly to the window bypasses the event queue,
  // which can cause a modal loop to lock up.
  [GSCurrentServer() postEvent: ev atStart: NO];
  
  flags._eventHandled = YES;
}
      
- (void) decodeWM_NCDESTROYParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd
{
}

- (void) decodeWM_DESTROYParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd
{
  WIN_INTERN *win = (WIN_INTERN *)GetWindowLongPtr(hwnd, GWLP_USERDATA);

  // Clean up window-specific data objects. 
	
  if (win->useHDC)
    {
      HGDIOBJ old;
	    
      old = SelectObject(win->hdc, win->old);
      DeleteObject(old);
      DeleteDC(win->hdc);
    }
  free(win);
  free((IME_INFO_T*)GetWindowLongPtr(hwnd, IME_INFO));
  flags._eventHandled=YES;
}

- (void) decodeWM_QUERYOPENParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd
{
}

- (void) decodeWM_SYSCOMMANDParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd
{
  // stubbed for future development

   switch (wParam)
   {
      case SC_CLOSE:
      break;
      case SC_CONTEXTHELP:
      break;
      case SC_HOTKEY:
      break;
      case SC_HSCROLL:
      break;
      case SC_KEYMENU:
      break;
      case SC_MAXIMIZE:
      break;
      case SC_MINIMIZE:
       flags.HOLD_MINI_FOR_SIZE=TRUE;
      break;
      case SC_MONITORPOWER:
      break;
      case SC_MOUSEMENU:
      break;
      case SC_MOVE:
      break;
      case SC_NEXTWINDOW:
      break;  
      case SC_PREVWINDOW:
      break;
      case SC_RESTORE:
      break;
      case SC_SCREENSAVE:
      break;
      case SC_SIZE:
      break;
      case SC_TASKLIST:
      break;
      case SC_VSCROLL:
      break;
        
      default:
      break;
   }
}

- (void) decodeWM_COMMANDParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd
{
  [[GSTheme theme] processCommand: (void *)wParam];
} 

- (void) decodeWM_THEMECHANGEDParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd
{
  // Reactivate the theme when the host system changes it's theme...
  [[GSTheme theme] activate];
}

- (void) decodeWM_SETCURSORParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd
{
  // Are we in a cursor rectangle?
  if ([[NSCursor stack] count] > 0)
    {
	  // if so, we've already taken care of setting our cursor, otherwise
	  // if we don't mark the event as handled, we'll let Windows handle it,
	  // e.g. to show the resizing cursors around a windows.
	  flags._eventHandled = YES;
	}
}

- (void) decodeWM_NCMOUSELEAVEParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd
{
  [NSCursor resetStack];
}

@end 
