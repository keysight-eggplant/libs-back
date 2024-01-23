########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: d5c31414b19fdb4dc0fec213fe3437f5d6655cae
# Date: 2017-03-04 21:44:14 +0000
--------------------
# Committed by: Paul Landers
# Commit ID: 71864f8dea9a7fe625662d2b4c8bc2ba915bafde
# Date: 2016-10-12 16:30:03 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: c0c0af046b705ebb3560a375603ac14a1daebc87
# Date: 2016-07-19 15:52:53 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: f878112bedcf2de593f59ec2b1e98b07892d3b06
# Date: 2016-06-10 13:26:21 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: c2f3640e2ae4c17f4b2dc5eca60db22fa8db3888
# Date: 2016-06-01 19:24:10 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: a1e3abba63e4e08e9c612dd1f2a93e5b30902e37
# Date: 2016-06-01 16:17:42 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: f9303f7bbd9cecf24d5930e06c828c902d074bfc
# Date: 2016-05-29 20:28:36 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: f8ce8e4ccd9204b6ad0e72d3f030f2768f208d4b
# Date: 2016-05-26 17:28:06 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: dc7101d1c43c92836b2f5744709d108142c56a88
# Date: 2016-05-26 17:27:30 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 58ca6b5c8eade494f10a3bf60bc4968e7c5234ca
# Date: 2016-05-11 20:46:04 +0000
########## End of Keysight Technologies Notice ##########
/* Implementation for NSUserNotification for GNUstep/Windows
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

#define EXPOSE_NSUserNotification_IVARS 1
#define EXPOSE_NSUserNotificationCenter_IVARS 1

#import "MSUserNotification.h"
#import <GNUstepBase/GNUstep.h>
#import "GNUstepBase/NSObject+GNUstepBase.h"
#import "GNUstepBase/NSDebug+GNUstepBase.h"
#import <AppKit/NSGraphics.h>
#import <AppKit/NSImage.h>
#import <AppKit/NSWindow.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSAutoreleasePool.h>
#import <Foundation/NSBundle.h>
#import <Foundation/NSDictionary.h>
#import "Foundation/NSException.h"
#import <Foundation/NSProcessInfo.h>
#import <Foundation/NSScanner.h>
#import <Foundation/NSString.h>
#import <Foundation/NSURL.h>
#import <Foundation/NSUUID.h>
#import <Foundation/NSValue.h>

#include <stdio.h>
#include <windows.h>
#include <ShellAPI.h>
#define CINTERFACE
#define interface struct
#include <shlwapi.h>
#undef interface
#include <gdiplus/gdiplus.h>

#include <iostream>
#include <string>

#if defined(__cplusplus)
extern "C" {
#endif

static SendNotificationFunctionPtr   pSendNotification   = NULL;
static RemoveNotificationFunctionPtr pRemoveNotification = NULL;
static HMODULE                       hNotificationLib    = NULL;

static NSString * const kButtonActionKey = @"show";

@interface NSImage (Private)
- (NSString*)_filename;
@end

@implementation NSImage (Private)
- (void)_setFilename:(NSString*)filename
{
#if 0
  _fileName = [filename copy];
#else
  ASSIGN(_fileName, filename);
#endif
}

- (NSString*)_filename
{
  return _fileName;
}
@end

@interface NSUserNotification ()
@property (readwrite, retain) NSDate *actualDeliveryDate;
@property (readwrite, getter=isPresented) BOOL presented;
@property (readwrite) NSUserNotificationActivationType activationType;
@end

@interface NSUserNotificationCenter (Private)
- (NSUserNotification *) deliveredNotificationWithUniqueId: (id)uniqueId;
@end

@interface MSUserNotificationCenter (Private)
- (NSString *) cleanupTextIfNecessary: (NSString *)rawText;
@end

@implementation MSUserNotificationCenter

- (id) init
{
  NSDebugLLog(@"NSUserNotification", @"initializing...");
  self = [super init];
  if (self)
  {
    NS_DURING
    {
      // Initialize instance variables...
      imageToIcon = [NSMutableDictionary new];
      uniqueID    = 1;

      NSBundle     *classBundle = [NSBundle bundleForClass: [self class]];
      NSBundle     *mainBundle  = [NSBundle mainBundle];
      NSDictionary *infoDict    = [mainBundle infoDictionary];
      NSString     *imageName   = [[infoDict objectForKey:@"CFBundleIconFiles"] objectAtIndex:0];
      NSString     *imageType   = @"";
      NSString     *path        = nil;
      NSImage      *image       = [self _imageForBundleInfo:infoDict];

      appIcon     = [self _iconFromImage:image];
      appIconPath = [[image _filename] copy];
      NSWarnMLog(@"bundle: %@ image: %@ icon: %p path: %@", classBundle, image, appIcon, appIconPath);
      
      if (appIcon == NULL)
      {
        NSLog(@"%s:unable to load icon for bundle: %@ GetLastError: %ld", __PRETTY_FUNCTION__, mainBundle, GetLastError());
      }
      
      OSVERSIONINFO osvi = { 0 };
      WINBOOL bIsWindows81orLater = false;

      ZeroMemory(&osvi, sizeof(OSVERSIONINFO));
      osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
      
      if (GetVersionEx(&osvi)== 0)
      {
        NSLog(@"%s:failed getting OS version with error id: %ld", __PRETTY_FUNCTION__, GetLastError());
      }
      else
      {
        NSWarnMLog(@"version number is: %d", osvi.dwMajorVersion);

        if  (osvi.dwMajorVersion >= 6)
        {
          if (osvi.dwMinorVersion == 1)
          {
            bIsWindows81orLater = 0;
          }
          else
          {
            bIsWindows81orLater = 1;
          }
        
          if(bIsWindows81orLater)
            path = [classBundle pathForResource: @"ToastNotifications-0" ofType: @"dll"];
          else 
            path = [classBundle pathForResource: @"TaskbarNotifications-0" ofType: @"dll"];

          // Try loading the corresponding DLL required for notifications...
          hNotificationLib = LoadLibrary([path UTF8String]);

          // For for not good conditions...
          if (hNotificationLib == NULL)
          {
            NSLog(@"%s:DLL load error: %ld", __PRETTY_FUNCTION__, GetLastError());
          }
          else
          {
            pSendNotification = (SendNotificationFunctionPtr)GetProcAddress(hNotificationLib, "sendNotification");
            pRemoveNotification = (RemoveNotificationFunctionPtr)GetProcAddress(hNotificationLib, "removeNotification");
            NSWarnMLog(@"DLL ptr: %p send notification ptr: %p remove ptr: %p", hNotificationLib, pSendNotification, pRemoveNotification);
          }
        }
      }
    }
    NS_HANDLER
    {
    }
    NS_ENDHANDLER
  }
  return self;
}

- (void) dealloc
{
  // Cleanup any icons we generated...
  NSEnumerator *iter = [imageToIcon objectEnumerator];
  HICON         icon = NULL;
  while ((icon = (HICON)[[iter nextObject] pointerValue]) != NULL)
  {
    DestroyIcon(icon);
  }
  
  DESTROY(appIconPath);
  DESTROY(imageToIcon);
  [super dealloc];
}

- (NSImage*) _imageForBundleInfo:(NSDictionary*)infoDict
{
  NSImage  *image       = nil;
  NSString *appIconFile = [infoDict objectForKey: @"NSIcon"];
  
  if (appIconFile && ![appIconFile isEqual: @""])
  {
    image = [NSImage imageNamed: appIconFile];
  }
  
  if (image == nil)
  {
    // Try to look up the icns file.
    appIconFile = [infoDict objectForKey: @"CFBundleIconFile"];
    if (appIconFile && ![appIconFile isEqual: @""])
    {
      image = [NSImage imageNamed: appIconFile];
    }

    if (image == nil)
    {
      NSBundle *bundle = [NSBundle bundleForClass: [self class]];
      appIconFile      = [bundle pathForResource:@"GNUstep" ofType:@"png"];
      image            = AUTORELEASE([[NSImage alloc] initWithContentsOfFile:appIconFile]);
      [image setName:@"NSUserNotificationIcon"];
      [image _setFilename:appIconFile];
    }
    else
    {
      /* Set the new image to be named 'NSApplicationIcon' ... to do that we
       * must first check that any existing image of the same name has its
       * name removed.
       */
      //[(NSImage*)[NSImage imageNamed: @"NSApplicationIcon"] setName: nil];
      // We need to copy the image as we may have a proxy here
      image = AUTORELEASE([image copy]);
      [image setName: @"NSUserNotificationIcon"];
    }
  }
  return image;
}

- (HICON) _iconFromImage: (NSImage *)image
{
  // Default the return cursur ID to NULL...
  HICON result = NULL;

  if ([image name] == nil)
  {
    NSLog(@"%s:cannot create/store image icon for NIL image names: %@", __PRETTY_FUNCTION__, result, [image name]);
  }
  else if ([imageToIcon objectForKey:[image name]])
  {
    result = (HICON)[[imageToIcon objectForKey: image] pointerValue];
  }
  else
  {
    // Try to create the icon from the image...
    Gdiplus::GdiplusStartupInput  startupInput;
    Gdiplus::GdiplusStartupOutput startupOutput;
    ULONG_PTR                     gdiplusToken;
    
    // Using GDI Plus requires startup/shutdown...
    Gdiplus::Status startStatus = Gdiplus::GdiplusStartup(&gdiplusToken, &startupInput, &startupOutput);
    if (startStatus != Gdiplus::Ok)
    {
        NSLog(@"%s:error on GdiplusStartup - status: %d GetLastError: %d", __PRETTY_FUNCTION__, startStatus, GetLastError());
    }
    else
    {
      std::string  filename8 = [[image _filename] UTF8String];
      std::wstring filename16(filename8.length(), L' ');                 // Make room for characters
      std::copy(filename8.begin(), filename8.end(), filename16.begin()); // Copy string to wstring.
      Gdiplus::Bitmap *bitmap = new Gdiplus::Bitmap(filename16.c_str());
      Gdiplus::Status status = bitmap->GetHICON(&result);

      // Check icon create status...
      if (status != Gdiplus::Ok)
      {
        NSLog(@"%s:error creating icon from bitmap - status: %d GetLastError: %d", __PRETTY_FUNCTION__, status, GetLastError());
      }
#if 0 // For debugging...
      else
      {
        ICONINFO iconinfo;
        if (GetIconInfo(result, &iconinfo) == 0)
        {
          NSLog(@"%s:error GetIconInfo error - status: %d GetLastError: %d", __PRETTY_FUNCTION__, GetLastError());
          DestroyIcon(result);
        }
        NSLog(@"%s:result: %p fIcon: %d X: %d Y: %d", __PRETTY_FUNCTION__, result, iconinfo.fIcon, iconinfo.xHotspot, iconinfo.yHotspot);
      }
#endif
      
      // Cleanup objects abnd shutdown GDI Plus...
      delete bitmap;
      Gdiplus::GdiplusShutdown(gdiplusToken);
    }
      
    // Need to save these created cursors to remove later...
    if (result != NULL)
    {
      [imageToIcon setObject:[NSValue valueWithPointer:result] forKey:[image name]];
    }
  }
  
  // Return whatever we were able to generate...
  return(result);
}

- (GUID)guidFromUUIDString:(NSString*)uuidString
{
  GUID       theGUID    = { 0 };
  unsigned int value      = 0;
  NSArray   *components = [uuidString componentsSeparatedByString: @"-"];
  NSScanner *scanner1   = [NSScanner scannerWithString: [components objectAtIndex: 0]];
  NSScanner *scanner2   = [NSScanner scannerWithString: [components objectAtIndex: 1]];
  NSScanner *scanner3   = [NSScanner scannerWithString: [components objectAtIndex: 2]];
  NSString  *data4      = [[components objectAtIndex: 3] stringByAppendingString: [components objectAtIndex: 4]];
  NSScanner *scanner4   = [NSScanner scannerWithString: data4];

  [scanner1 scanHexInt: (unsigned int*)&theGUID.Data1];
  [scanner2 scanHexInt: &value];
  theGUID.Data2 = (WORD) value;
  [scanner3 scanHexInt: &value];
  theGUID.Data3 = (WORD) value;

  return theGUID;
}

- (GUID)guidFromUUID:(NSUUID*)uuid
{
  // Note: This is an example GUID only and should not be used.
  // Normally, you should use a GUID-generating tool to provide the value to
  // assign to guidItem.
  return([self guidFromUUIDString:[uuid UUIDString]]);
}

- (NSUUID*)generateUUID
{
  return [NSUUID UUID];
}

- (GUID)generateGUID
{
  return [self guidFromUUID:[self generateUUID]];
}

- (NSNumber*)_showNotification:(NSUserNotification*)note forWindow:(NSWindow*)forWindow
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSNumber          *result = nil;
  
  if (pSendNotification != NULL)
  {
    NSUUID      *uuid       = [self generateUUID];
    NSString    *UUIDString = [uuid UUIDString];
    std::string  uuidString = std::string([UUIDString UTF8String]);

    // Try to send the notification...
    SEND_NOTE_INFO_T noteInfo = { 0 };
    noteInfo.uuidString       = [UUIDString UTF8String];
    noteInfo.title            = [note.title UTF8String];
    noteInfo.informativeText  = [note.informativeText UTF8String];
    noteInfo.appIconPath      = [appIconPath UTF8String];

    // Content image is for displaying within the notification...
    // i.e. Shell notes - within the balloon somwhere...
    //      Toast notes - with the toast window somewhere
    // Check for content image and generate a windows icon from it...
    if (note.contentImage != nil)
    {
      // Attempt to create a window icon from image...
      noteInfo.contentIcon = [self _iconFromImage:note.contentImage];
    }

    BOOL status = pSendNotification((HWND)GetModuleHandle(NULL), appIcon, &noteInfo);
    
    if (status)
    {
      note.identifier = [[UUIDString copy] autorelease];
      note.presented = YES;

      return [NSNumber numberWithBool:uniqueID++];
    }
  }	

  // Cleanup...
  [pool drain];
  
  // TODO: Should we return something else here????
  return [NSNumber numberWithBool:0];
}

- (void) _deliverNotification: (NSUserNotification *)un
{
  NSAutoreleasePool *pool         = [NSAutoreleasePool new];
  NSString          *appName      = nil;
  NSString          *imageName    = nil;
  NSURL             *imageURL     = nil;
  NSURL             *soundFileURL = nil;

  NSBundle *bundle = [NSBundle mainBundle];
  if (bundle)
    {
      NSDictionary *info = [bundle localizedInfoDictionary];
      if (info)
        {
          appName   = [info objectForKey: @"NSBundleName"];
          imageName = [info objectForKey: @"NSIcon"];
          if (imageName)
            imageURL = [bundle URLForResource: imageName withExtension: nil];
        }
      if (un.soundName && [caps containsObject:@"sound"])
        {
          soundFileURL = [bundle URLForResource: un.soundName
                                  withExtension: nil];
        }
    }

  // fallback
  if (!appName)
    appName = [[NSProcessInfo processInfo] processName];

  NSMutableArray *actions = [NSMutableArray array];
#if 0
  if ([un hasActionButton])
    {
      NSString *actionButtonTitle = un.actionButtonTitle;
      if (!actionButtonTitle)
        actionButtonTitle = _(@"Show");

      // NOTE: don't use "default", as it's used by convention and seems
      // to remove the actionButton entirely
      // (tested with Notification Daemon (0.3.7))
      [actions addObject: kButtonActionKey];
      [actions addObject: [self cleanupTextIfNecessary: actionButtonTitle]];
    }
#endif

  NSDebugMLLog(@"NSUserNotification",
               @"appName: %@ imageName: %@ imageURL: %@ soundFileURL: %@",
               appName, imageName, imageURL, soundFileURL);

  NSMutableDictionary *hints = [NSMutableDictionary dictionary];
  if (un.userInfo)
    [hints addEntriesFromDictionary: un.userInfo];

  if (imageURL)
    [hints setObject: [imageURL absoluteString] forKey: @"image-path"];
  if (soundFileURL)
    [hints setObject: [soundFileURL path] forKey: @"sound-file"];

  NSString *summary  = [self cleanupTextIfNecessary: un.title];
  NSString *body     = [self cleanupTextIfNecessary: un.informativeText];
  NSNumber *uniqueId = [self _showNotification:un forWindow: nil];

  ASSIGN(un->_uniqueId, uniqueId);
  un.presented = ([uniqueId integerValue] != 0) ? YES : NO;
      
  [pool drain];
}

- (void)_removeDeliveredNotification:(NSUserNotification *)theNote
{
  if (pRemoveNotification != NULL)
  {
    REMOVE_NOTE_INFO_T noteInfo = { 0 };
    noteInfo.uniqueID = [theNote->_uniqueId integerValue];
    pRemoveNotification(appIcon, &noteInfo);
  }
}

- (NSString *)cleanupTextIfNecessary:(NSString *)rawText
{
  if (!rawText || ![caps containsObject:@"body-markup"])
    return nil;

  NSMutableString *t = (NSMutableString *)[rawText mutableCopy];
  [t replaceOccurrencesOfString: @"&"  withString: @"&amp;"  options: 0 range: NSMakeRange(0, [t length])];  // must be first!
  [t replaceOccurrencesOfString: @"<"  withString: @"&lt;"   options: 0 range: NSMakeRange(0, [t length])];
  [t replaceOccurrencesOfString: @">"  withString: @"&gt;"   options: 0 range: NSMakeRange(0, [t length])];
  [t replaceOccurrencesOfString: @"\"" withString: @"&quot;" options: 0 range: NSMakeRange(0, [t length])];
  [t replaceOccurrencesOfString: @"'"  withString: @"&apos;" options: 0 range: NSMakeRange(0, [t length])];
  return t;
}

// SIGNALS

- (void)receiveNotificationClosedNotification:(NSNotification *)n
{
  id nId = [[n userInfo] objectForKey: @"arg0"];
  NSUserNotification *un = [self deliveredNotificationWithUniqueId: nId];
  NSDebugMLLog(@"NSUserNotification", @"%@", un);
}

- (void)receiveActionInvokedNotification:(NSNotification *)n
{
  id nId = [[n userInfo] objectForKey: @"arg0"];
  NSUserNotification *un = [self deliveredNotificationWithUniqueId: nId];
  NSString *action = [[n userInfo] objectForKey: @"arg1"];

  NSDebugMLLog(@"NSUserNotification", @"%@ -- action: %@", un, action);
  if ([action isEqual:kButtonActionKey])
    un.activationType = NSUserNotificationActivationTypeActionButtonClicked;
  else
    un.activationType = NSUserNotificationActivationTypeContentsClicked;

  if (self.delegate && [self.delegate respondsToSelector:@selector(userNotificationCenter:didActivateNotification:)])
    [self.delegate userNotificationCenter: self didActivateNotification: un];
}

@end

#if defined(__cplusplus)
}
#endif

#endif /* __has_feature(objc_default_synthesize_properties) */
