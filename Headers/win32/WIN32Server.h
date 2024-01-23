########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: d9947de1b5f9dba597ae665fc4a3073b589aec3c
# Date: 2017-06-22 20:00:16 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: c1b52babfb21ae4b56761a836a767f4c9275db5b
# Date: 2016-12-07 21:45:00 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 66866885ef9c70dfa4913a714c961f4e55eff59d
# Date: 2016-10-06 14:00:51 +0000
--------------------
# Committed by: Aarti Munjal
# Commit ID: 457ca77b6b7839c93e31610eeccbcd17a96c66a8
# Date: 2016-03-08 16:27:48 +0000
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
# Committed by: Marcian Lytwyn
# Commit ID: a91ebbd8b8af865cc582360c5e1862fc2db34d44
# Date: 2013-01-17 23:09:35 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 57f71dadc3fc4ac88122429d47b79ea55b7bab48
# Date: 2013-01-15 17:02:18 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: f018376f1267e7b494ff529b86e7e819ebe1998a
# Date: 2012-11-14 19:06:57 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: aa519f55a8a8b3e3fcf786da578958ac4e5cdee8
# Date: 2012-10-17 20:08:34 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 7a892f25ce6b4ecb2083a7ebf30d22e3c9799e66
# Date: 2012-08-29 21:34:21 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: c58a4af6816841618420deeb3888bf97b3dc4e96
# Date: 2012-08-08 22:28:34 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 999c4362968a8e5cf56c874ea96afbc1f3412230
# Date: 2012-06-27 17:59:11 +0000
########## End of Keysight Technologies Notice ##########
/* WIN32Server - Implements window handling for MSWindows

   Copyright (C) 2002,2005 Free Software Foundation, Inc.

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

#ifndef _WIN32Server_h_INCLUDE
#define _WIN32Server_h_INCLUDE

#include <Foundation/NSNotification.h>
#include <Foundation/NSDebug.h>
#include <Foundation/NSString.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSValue.h>
#include <Foundation/NSConnection.h>
#include <Foundation/NSRunLoop.h>
#include <Foundation/NSTimer.h>
#include <AppKit/AppKitExceptions.h>
#include <AppKit/NSApplication.h>
#include <AppKit/NSGraphics.h>
#include <AppKit/NSMenu.h>
#include <AppKit/NSWindow.h>
#include <AppKit/NSView.h>
#include <AppKit/NSEvent.h>
#include <AppKit/NSCursor.h>
#include <AppKit/NSText.h>
#include <AppKit/NSPopUpButton.h>
#include <AppKit/NSPanel.h>
#include <AppKit/DPSOperators.h>
#include <AppKit/NSImage.h>

#include <GNUstepGUI/GSDisplayServer.h>
#include <config.h>
#include <windows.h>

/*
 This standard windows macros are missing in MinGW.  The definition
 here is almost correct, but will fail for multi monitor systems
*/
#ifndef GET_X_LPARAM
#define GET_X_LPARAM(p) ((int)(short)LOWORD(p))
#endif
#ifndef GET_Y_LPARAM
#define GET_Y_LPARAM(p) ((int)(short)HIWORD(p))
#endif

// The horizontal mousehweel message is missing in MinGW 
#ifndef WM_MOUSEHWHEEL
#define WM_MOUSEHWHEEL 0x020E
#endif

#define EVENT_WINDOW(lp) (GSWindowWithNumber((int)lp)) 

DWORD windowStyleForGSStyle(unsigned int style);
   
typedef struct w32serverFlags 
{
  BOOL HOLD_MINI_FOR_SIZE;        // override GS size event on miniturize
  BOOL _eventHandled;             // did we handle the event?
} serverFlags;

@interface WIN32Server : GSDisplayServer
{
  BOOL handlesWindowDecorations;
  BOOL usesNativeTaskbar;

  serverFlags flags;
  HINSTANCE hinstance;

  HWND currentFocus;
  HWND desiredFocus;
  HWND currentActive;
  HICON  currentAppIcon;
  NSMutableArray *monitorInfo;
  NSMutableDictionary *systemCursors;
  NSMutableArray *listOfCursorsFailed;
}

- (BOOL) handlesWindowDecorations;
- (void) setHandlesWindowDecorations: (BOOL) b;

- (BOOL) usesNativeTaskbar;
- (void) setUsesNativeTaskbar: (BOOL) b;

+ (void) initializeBackend;

- (LRESULT) windowEventProc: (HWND)hwnd : (UINT)uMsg 
		       : (WPARAM)wParam : (LPARAM)lParam;
			
- (void) setFlagsforEventLoop: (HWND)hwnd;

- (DWORD) windowStyleForGSStyle: (unsigned int) style;

- (void) resizeBackingStoreFor: (HWND)hwnd;

- (HDC) createHdcForScreen: (int)screen;
- (void) deleteScreenHdc: (HDC)hdc;

@end

@interface WIN32Server (w32_activate)

#if 0
- (LRESULT) decodeWM_MOUSEACTIVATEParams: (WPARAM)wParam : (LPARAM)lParam
						: (HWND)hwnd;
#endif
- (LRESULT) decodeWM_ACTIVEParams: (WPARAM)wParam : (LPARAM)lParam
				 : (HWND)hwnd;
- (LRESULT) decodeWM_ACTIVEAPPParams: (HWND)hwnd : (WPARAM)wParam 
				    : (LPARAM)lParam;
- (void) decodeWM_NCACTIVATEParams: (WPARAM)wParam : (LPARAM)lParam 
				  : (HWND)hwnd;

@end

@interface WIN32Server (w32_movesize)

- (LRESULT) decodeWM_SIZEParams: (HWND)hwnd : (WPARAM)wParam : (LPARAM)lParam;
- (LRESULT) decodeWM_MOVEParams: (HWND)hwnd : (WPARAM)wParam : (LPARAM)lParam;
- (void) decodeWM_NCCALCSIZEParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_WINDOWPOSCHANGINGParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_WINDOWPOSCHANGEDParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (LRESULT) decodeWM_GETMINMAXINFOParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (LRESULT) decodeWM_ENTERSIZEMOVEParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (LRESULT) decodeWM_EXITSIZEMOVEParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (LRESULT) decodeWM_MOVINGParams: (HWND)hwnd : (WPARAM)wParam : (LPARAM)lParam;
- (LRESULT) decodeWM_SIZINGParams: (HWND)hwnd : (WPARAM)wParam : (LPARAM)lParam;

@end

@interface WIN32Server (w32_create)

- (LRESULT) decodeWM_NCCREATEParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (LRESULT) decodeWM_CREATEParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;

@end

@interface WIN32Server (w32_windowdisplay)

- (void) decodeWM_SHOWWINDOWParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_NCPAINTParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (LRESULT) decodeWM_ERASEBKGNDParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_PAINTParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_SYNCPAINTParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_CAPTURECHANGEDParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (HICON) decodeWM_GETICONParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (HICON) decodeWM_SETICONParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;

@end

@interface WIN32Server (w32_text_focus)

//- (LRESULT) decodeWM_SETTEXTParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (LRESULT) decodeWM_SETFOCUSParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_KILLFOCUSParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_GETTEXTParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;

@end

@interface WIN32Server (w32_General)

- (void) decodeWM_CLOSEParams: (WPARAM)wParam :(LPARAM)lParam :(HWND)hwnd;
- (void) decodeWM_DESTROYParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_NCDESTROYParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_QUERYOPENParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_SYSCOMMANDParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_COMMANDParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_THEMECHANGEDParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_SETCURSORParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;
- (void) decodeWM_NCMOUSELEAVEParams: (WPARAM)wParam : (LPARAM)lParam : (HWND)hwnd;

@end

// FIXME: Keep all of the extra window data in one place

// Extra window data accessed via GetWindowLong

enum _WIN_EXTRA_BYTES
{
  OFF_LEVEL       = 0,                          // Value
  OFF_ORDERED     = OFF_LEVEL + sizeof(LONG),   // Value
  IME_INFO        = OFF_ORDERED + sizeof(LONG), // Pointer
  WIN_EXTRABYTES  = IME_INFO + sizeof(LONG_PTR) // Pointer
};


// Pointer to this struct set in IME_INFO extra bytes space for
// handling IME composition processing between various windows...
typedef struct IME_INFO_S
{
  DWORD   isOpened;
  BOOL    isComposing;
  UINT    inProgress;
  BOOL    useCompositionWindow;
  
  LPVOID  readString;
  DWORD   readStringLength;
  LPVOID  compString;
  DWORD   compStringLength;
  
  DWORD   compositionMode;
  DWORD   sentenceMode;
} IME_INFO_T;


// Extra window data allocated using objc_malloc in WM_CREATE and accessed via
// the GWL_USERDATA pointer

typedef struct _win_intern {
  BOOL useHDC;
  BOOL backingStoreEmpty;
  HDC hdc; 
  HGDIOBJ old;
  MINMAXINFO minmax;
  NSBackingStoreType type;
#if (BUILD_GRAPHICS==GRAPHICS_cairo)
  void *surface;
#endif
} WIN_INTERN;

#endif /* _WIN32Server_h_INCLUDE */
