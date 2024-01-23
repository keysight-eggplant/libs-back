########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: ab5a7d11988ac671273ec9a47c85d5fe65e49c3f
# Date: 2020-03-05 10:42:47 -0500
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 168d5d5a65ff0ce9be7fcd9e800f036369650c69
# Date: 2020-03-04 11:22:51 -0500
--------------------
# Committed by: Frank Le Grand
# Commit ID: 1b82d912b55f817956e396273e2eb6816fa37389
# Date: 2013-08-09 14:21:15 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 7a892f25ce6b4ecb2083a7ebf30d22e3c9799e66
# Date: 2012-08-29 21:34:21 +0000
########## End of Keysight Technologies Notice ##########
/* GSBackend - backend initialize class

   Copyright (C) 2002 Free Software Foundation, Inc.

   Author: Adam Fedor <fedor@gnu.org>
   Date: Mar 2002

   This file is part of the GNUstep GUI Library.

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
#include <Foundation/NSObject.h>
#include <Foundation/NSException.h>
#include <Foundation/NSUserDefaults.h>

@interface GSBackend : NSObject
{
}
+ (void) initializeBackend;
@end

#if (BUILD_SERVER == SERVER_x11) || (BUILD_SERVER == SERVER_xheadless)
#include <x11/XGServer.h>
@interface XGServer (Initialize)
+ (void) initializeBackend;
@end
#elif BUILD_SERVER == SERVER_win32
#include <win32/WIN32Server.h>
@interface WIN32Server (Initialize)
+ (void) initializeBackend;
@end
#endif

/* Call the correct initalization routines for the choosen
   backend. This depends both on configuration data and defaults.
*/
@implementation GSBackend

+ (void) initializeBackend
{
  Class           contextClass;
  NSString       *context = nil;
  NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];

  /* Load in only one server */
#if BUILD_SERVER == SERVER_x11
  [XGServer initializeBackend];
#elif BUILD_SERVER == SERVER_xheadless
  [XGServer initializeBackend];
#elif BUILD_SERVER == SERVER_win32
  [WIN32Server initializeBackend];
#else
  [NSException raise: NSInternalInconsistencyException
	       format: @"No Window Server configured in backend"];
#endif

  /* The way the frontend is currently structured
     it's not possible to have more than one */

  /* What backend context? */
  if ([defs stringForKey: @"GSContext"])
    context = [defs stringForKey: @"GSContext"];
  
  if ((context == nil) || ([context length] == 0))
    {
#if (BUILD_GRAPHICS==GRAPHICS_xdps)
    context = @"NSDPSContext";
#elif (BUILD_GRAPHICS==GRAPHICS_art)
    context = @"ARTContext";
#elif (BUILD_GRAPHICS==GRAPHICS_xlib)
    context = @"XGContext";
#elif (BUILD_GRAPHICS==GRAPHICS_headlesslib)
    context = @"HeadlessContext";
#elif (BUILD_GRAPHICS==GRAPHICS_winlib)
    context = @"WIN32Context";
#elif (BUILD_GRAPHICS==GRAPHICS_cairo)
    context = @"CairoContext";
#elif (BUILD_GRAPHICS==GRAPHICS_opal)
    context = @"OpalContext";
#else
#error INVALID build graphics type
#endif
    }
    
  // Reference the requested build time class...
  contextClass = NSClassFromString(context);
  if (contextClass == nil)
    {
      NSLog(@"%s:Backend context class missing for: %@\n", __PRETTY_FUNCTION__, context);
      exit(1);
    }
  [contextClass initializeBackend];
}

@end


