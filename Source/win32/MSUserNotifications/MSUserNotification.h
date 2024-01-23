########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Paul Landers
# Commit ID: 71864f8dea9a7fe625662d2b4c8bc2ba915bafde
# Date: 2016-10-12 16:30:03 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 58ca6b5c8eade494f10a3bf60bc4968e7c5234ca
# Date: 2016-05-11 20:46:04 +0000
########## End of Keysight Technologies Notice ##########
/* Interface for DKUserNotification for GNUstep
   Copyright (C) 2014 Free Software Foundation, Inc.

   Written by:  Marcus Mueller <znek@mulle-kybernetik.com>
   Date: 2014

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02111 USA.
*/

// NOTE: for the time being, NSUserNotificationCenter needs this feature.
// Whenever this restriction is lifted, we can get rid of it here as well.
#if __has_feature(objc_default_synthesize_properties)

#include <GNUstepBase/GSConfig.h>
#include <windows.h>

// C++ header includes...
#include <string>

#include "MSUserNotificationAPI.h"

#import <GNUstepBase/GSVersionMacros.h>

#if OS_API_VERSION(MAC_OS_X_VERSION_10_8,GS_API_LATEST)
#include <Foundation/NSUUID.h>

#import <Foundation/NSUserNotification.h>

#if defined(__cplusplus)
extern "C" {
#endif

// DLL API Function prototypes...
typedef BOOL __cdecl (*SendNotificationFunctionPtr)(HWND, HICON, SEND_NOTE_INFO_PTR);
typedef BOOL __cdecl (*RemoveNotificationFunctionPtr)(HICON, REMOVE_NOTE_INFO_PTR);
typedef BOOL __cdecl (*ActivationCallbackFunctionPtr)(void);
typedef BOOL __cdecl (*SetActivationCallbackPtr)(ActivationCallbackFunctionPtr);

@class NSConnection;
@class NSArray;
@class NSMutableDictionary;

@protocol Notifications;

@interface MSUserNotificationCenter : NSUserNotificationCenter
{
  HICON                appIcon;
  NSString            *appIconPath;
  NSMutableDictionary *imageToIcon;
  NSArray             *caps;
  NSUInteger           uniqueID;
  NSMutableDictionary *idToNotes;
}

@end

#if defined(__cplusplus)
}
#endif

#endif /* OS_API_VERSION(MAC_OS_X_VERSION_10_8,GS_API_LATEST) */
#endif /* __has_feature(objc_default_synthesize_properties) */
