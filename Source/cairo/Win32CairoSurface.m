########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Bill Everett
# Commit ID: 82bf9cd7c41c92f1d636ef27e9d98148eabbe33b
# Date: 2018-12-13 23:13:42 +0000
--------------------
# Committed by: Bill Everett
# Commit ID: e7a47cdce31973fb6ea35b581f4523781ad5f35e
# Date: 2018-12-13 21:21:35 +0000
--------------------
# Committed by: Bill Everett
# Commit ID: 99017762cc802a6f5a7ae38a7960f0ff4d10fe0a
# Date: 2018-12-08 22:19:44 +0000
--------------------
# Committed by: Paul Landers
# Commit ID: 71864f8dea9a7fe625662d2b4c8bc2ba915bafde
# Date: 2016-10-12 16:30:03 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: c43e4677848a4965d825835e0c39377983f4124f
# Date: 2015-07-14 22:36:43 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: aaa0a6e5c228a4a6260253bd6fdf87a7e5c568a8
# Date: 2014-02-27 22:01:29 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: 1b82d912b55f817956e396273e2eb6816fa37389
# Date: 2013-08-09 14:21:15 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: afe41336df2ce6abdc48417e14c6dc330737482f
# Date: 2013-07-20 16:32:35 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 95a8e8d68f84f7bb33fa2d7019faaacf7172ee06
# Date: 2013-05-19 22:46:35 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 16ef33d4c4368a7431b99b8bf1f8dbc8f0edcbdc
# Date: 2013-05-09 01:49:46 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 612a141f28210cb62355f2053c58eab4bb18a867
# Date: 2013-05-09 01:32:02 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: a91ebbd8b8af865cc582360c5e1862fc2db34d44
# Date: 2013-01-17 23:09:35 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 0ebb1b141154e22133ccbe26fec22b551cacf30c
# Date: 2012-10-25 21:28:28 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 2d72a18f1a29f00377f76a1ac4bd94fb5869a26b
# Date: 2012-10-25 19:26:26 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: e5e02267f94155ee57763f53a22819f2ffd625b4
# Date: 2012-10-25 19:15:48 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 41ebb7a852ac62f6264da80a9f94fe90719f0c17
# Date: 2012-10-25 18:53:03 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: aa519f55a8a8b3e3fcf786da578958ac4e5cdee8
# Date: 2012-10-17 20:08:34 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 9b0f83a5d9b6f2639b4255360aac62cc646c4086
# Date: 2012-10-11 20:40:21 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 0cfb23088f75422242becc547643db98350dad66
# Date: 2012-09-19 18:06:44 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: a63d526943e627a7ea2221815973f6ee41be7d7f
# Date: 2012-09-07 20:04:11 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 7a892f25ce6b4ecb2083a7ebf30d22e3c9799e66
# Date: 2012-08-29 21:34:21 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: f5c781e78ff2c4fd13a914170c541e1a7b9fb57e
# Date: 2012-08-08 22:22:10 +0000
########## End of Keysight Technologies Notice ##########
/*
   Win32CairoSurface.m

   Copyright (C) 2008 Free Software Foundation, Inc.

   Author: Xavier Glattard <xavier.glattard@online.fr>
   Based on the work of:
     Banlu Kemiyatorn <object at gmail dot com>

   This file is part of GNUstep.
   
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

#include "cairo/Win32CairoSurface.h"
#include "win32/WIN32Geometry.h"
#include "win32/WIN32Server.h"
#include <cairo-win32.h>


@implementation Win32CairoSurface

- (HWND)gsDevice
{
  return (HWND)gsDevice;
}

- (id) initWithDevice: (void *)device
{
  if (self)
    {
      // Save/set initial state...
      gsDevice = device;
      _surface = NULL;
  
      WIN_INTERN *win = (WIN_INTERN *)GetWindowLongPtr(device, GWLP_USERDATA);
      HDC         hDC = GetDC(device);

      if (hDC == NULL)
        {
          NSWarnMLog(@"Win32CairoSurface line: %d : no device context", __LINE__);
          
          // And deallocate ourselves...
          DESTROY(self);
        }
      else
        {
          // Create the cairo surfaces...
          // NSBackingStoreRetained works like Buffered since 10.5 (See apple docs)...
          // NOTE: According to Apple docs NSBackingStoreBuffered should be the only one
          //       ever used anymore....others are NOT recommended...
#if 0     // FIXME:
          // Non-retained backing store type on windows doesn't re-display correctly
          // after first time (see additional comments in method -[CairoContext flushGraphics])
          // Currently handling such windows as buffered store types until a fix can be resolved.
          if (win && (win->type == NSBackingStoreNonretained))
            {
              // This is the raw DC surface...
              _surface = cairo_win32_surface_create(hDC);

              // Check for error...
              if (cairo_surface_status(_surface) != CAIRO_STATUS_SUCCESS)
                {
                  // Output the surface create error...
                  cairo_status_t status = cairo_surface_status(_surface);
                  NSWarnMLog(@"surface create FAILED - status: %s\n", cairo_status_to_string(status));
                  
                  // Destroy the initial surface created...
                  cairo_surface_destroy(_surface);
                  
                  // And deallocate ourselves...
                  DESTROY(self);
                  
                  // Release the device context...
                  ReleaseDC(device, hDC);
                }
            }
          else
#endif
            {
              NSSize csize = [self size];
          
              // This is the raw DC surface...
              cairo_surface_t *window = cairo_win32_surface_create(hDC);
              
              // Check for error...
              if (cairo_surface_status(window) != CAIRO_STATUS_SUCCESS)
                {
                  // Output the surface create error...
                  cairo_status_t status = cairo_surface_status(window);
                  NSWarnMLog(@"surface create FAILED - status: %s\n",  cairo_status_to_string(status));
                  
                  // And deallocate ourselves...
                  DESTROY(self);
                }
              else
                {
                  // and this is the in-memory DC surface...surface owns its DC...
                  // NOTE: For some reason we get an init sequence with zero width/height,
                  //       which creates problems in the cairo layer.  It tries to clear
                  //       the 'similar' surface it's creating, and with a zero width/height
                  //       it incorrectly thinks the clear failed...so we will init with
                  //       a minimum size of 1 for width/height...
                  _surface = cairo_surface_create_similar(window, CAIRO_CONTENT_COLOR_ALPHA,
                                                          MAX(1, csize.width),
                                                          MAX(1, csize.height));

                  // Check for error...
                  if (cairo_surface_status(_surface) != CAIRO_STATUS_SUCCESS)
                    {
                      // Output the surface create error...
                      cairo_status_t status = cairo_surface_status(_surface);
                      NSWarnMLog(@"surface create FAILED - status: %s\n",  cairo_status_to_string(status));
                      
                      // Destroy the surface created...
                      cairo_surface_destroy(_surface);
                      
                      // And deallocate ourselves...
                      DESTROY(self);
                    }
                }
              
              // Destroy the initial surface created...
              cairo_surface_destroy(window);
              
              // Release the device context...
              ReleaseDC(device, hDC);
            }

          if (self)
            {
              // We need this for handleExposeEvent in WIN32Server...
              win->surface = (void*)self;
            }
        }
    }
  return self;
}

- (void) dealloc
{
  // After further testing and monitoring USER/GDI object counts found
  // that releasing the HDC is redundant and unnecessary...
  [super dealloc];
}

- (NSString*) description
{
  NSMutableString *description = AUTORELEASE([[super description] mutableCopy]);
  HDC shdc = NULL;

  if (_surface)
    {
      shdc = cairo_win32_surface_get_dc(_surface);
    }
  [description appendFormat: @" size: %@",NSStringFromSize([self size])];
  [description appendFormat: @" _surface: %p",_surface];
  [description appendFormat: @" surfDC: %p",shdc];
  return [NSString stringWithString:description];
}

- (NSSize) size
{
  NSWindow *window = GSWindowWithNumber(gsDevice);
  
  RECT desktop;
  const HWND hDesktop = GetDesktopWindow();
  GetWindowRect(hDesktop, &desktop);
  float screenWidth = desktop.right;
  float screenHeight = desktop.bottom;
    
  if (([window styleMask] & (~NSUnscaledWindowMask) & (~NSFullScreenWindowMask) & (~NSWindowStyleMaskFullScreen)) == 0 && ([window frame].size.width >= screenWidth || [window frame].size.height >= screenHeight)) {
	return [window frame].size;
  }
  else {
	RECT csize;

	GetClientRect([self gsDevice], &csize);
	return NSMakeSize(csize.right - csize.left, csize.bottom - csize.top);
  }
}

- (void) setSize: (NSSize)newSize
{
  NSDebugMLLog(@"Win32CairoSurface", @"size: %@\n", NSStringFromSize(newSize));
}

- (void) handleExposeRect: (NSRect)rect
{
  // If the surface is buffered then we will have been invoked...
  HDC hdc = GetDC([self gsDevice]);
  
  // Make sure we got a HDC...
  if (hdc == NULL)
    {
      NSWarnMLog(@"ERROR: cannot get a HDC for surface: %@\n", self);
    }
  else
    {
      // Create a cairo surface for the hDC...
      cairo_surface_t *window = cairo_win32_surface_create(hdc);
      
      // If the surface is buffered then...
      if (window == NULL)
        {
          NSWarnMLog(@"ERROR: cannot create cairo surface for: %@\n", self);
        }
      else
        {
          // First check the current status of the foreground surface...
          if (cairo_surface_status(window) != CAIRO_STATUS_SUCCESS)
            {
              NSWarnMLog(@"cairo initial window error status: %s\n",
                         cairo_status_to_string(cairo_surface_status(window)));
            }
          else
            {
              cairo_t *context = cairo_create(window);

              if (cairo_status(context) != CAIRO_STATUS_SUCCESS)
                {
                  NSWarnMLog(@"cairo context create error - status: _surface: %s window: %s windowCtxt: %s (%d)",
                             cairo_status_to_string(cairo_surface_status(_surface)),
                             cairo_status_to_string(cairo_surface_status(window)),
                             cairo_status_to_string(cairo_status(context)), cairo_get_reference_count(context));
                }
              else
                {
                  double  backupOffsetX = 0;
                  double  backupOffsetY = 0;
                  RECT    msRect        = GSWindowRectToMS((WIN32Server*)GSCurrentServer(), [self gsDevice], rect);

                  // Need to save the device offset context...
                  cairo_surface_get_device_offset(_surface, &backupOffsetX, &backupOffsetY);
                  cairo_surface_set_device_offset(_surface, 0, 0);

                  cairo_rectangle(context, msRect.left, msRect.top, rect.size.width, rect.size.height);
                  cairo_clip(context);
                  cairo_set_source_surface(context, _surface, 0, 0);
                  cairo_set_operator(context, CAIRO_OPERATOR_SOURCE);
                  cairo_paint(context);
                  
                  if (cairo_status(context) != CAIRO_STATUS_SUCCESS)
                  {
                    NSWarnMLog(@"cairo expose error - status: _surface: %s window: %s windowCtxt: %s",
                               cairo_status_to_string(cairo_surface_status(_surface)),
                               cairo_status_to_string(cairo_surface_status(window)),
                               cairo_status_to_string(cairo_status(context)));
                  }

                  // Cleanup...
                  cairo_destroy(context);

                  // Restore device offset
                  cairo_surface_set_device_offset(_surface, backupOffsetX, backupOffsetY);
                }
            }
          
          // Destroy the surface...
          cairo_surface_destroy(window);
        }

      // Release the aquired HDC...
      ReleaseDC([self gsDevice], hdc);
    }
}

@end

@implementation WIN32Server (ScreenCapture)

- (NSImage *) contentsOfScreen: (int)screen inRect: (NSRect)rect
{
  NSImage *result = nil;
  HDC      hdc    = [self createHdcForScreen:screen];
  
  // We need a screen device context for this to work...
  if (hdc == NULL)
    {
      NSWarnMLog(@"invalid screen request: %d", screen);
    }
  else
    {
      // Convert rect to flipped coordinates
      NSRect    boundsForScreen = [self boundsForScreen:screen];
      rect.origin.y             = boundsForScreen.size.height - NSMaxY(rect);
      NSInteger width           = rect.size.width;
      NSInteger height          = rect.size.height;
      
      // Create a bitmap representation for capturing the screen area...
      NSBitmapImageRep *bmp = [[[NSBitmapImageRep alloc] initWithBitmapDataPlanes: NULL
                                                                       pixelsWide: width
                                                                       pixelsHigh: height
                                                                    bitsPerSample: 8
                                                                  samplesPerPixel: 4
                                                                         hasAlpha: YES
                                                                         isPlanar: NO
                                                                   colorSpaceName: NSDeviceRGBColorSpace
                                                                     bitmapFormat: 0
                                                                      bytesPerRow: 0
                                                                     bitsPerPixel: 32] autorelease];

      // Create the required surfaces...
      cairo_surface_t *src = cairo_win32_surface_create(hdc);
      cairo_surface_t *dst = cairo_image_surface_create_for_data([bmp bitmapData],
                                                                 CAIRO_FORMAT_ARGB32,
                                                                 width, height,
                                                                 [bmp bytesPerRow]);
      
      // Ensure we were able to generate the required surfaces...
      if (cairo_surface_status(src) != CAIRO_STATUS_SUCCESS)
      {
        NSWarnMLog(@"cairo screen surface error status: %s\n",
                   cairo_status_to_string(cairo_surface_status(src)));
      }
      else if (cairo_surface_status(dst) != CAIRO_STATUS_SUCCESS)
      {
        NSWarnMLog(@"cairo screen surface error status: %s\n",
                   cairo_status_to_string(cairo_surface_status(dst)));
        cairo_surface_destroy(src);
      }
      else
      {
        // Capture the requested screen rectangle...
        cairo_t *cr = cairo_create(dst);
        cairo_set_source_surface(cr, src, -1 * rect.origin.x, -1 * rect.origin.y);
        cairo_paint(cr);
        cairo_destroy(cr);

        // Cleanup the cairo surfaces...
        cairo_surface_destroy(src);
        cairo_surface_destroy(dst);
        
        // Convert BGRA to RGBA
        // Original code located in XGCairSurface.m
        {
          NSInteger stride;
          NSInteger x, y;
          unsigned char *cdata;
          
          stride = [bmp bytesPerRow];
          cdata = [bmp bitmapData];
          
          for (y = 0; y < height; y++)
            {
              for (x = 0; x < width; x++)
                {
                  NSInteger i = (y * stride) + (x * 4);
                  unsigned char d = cdata[i];
                  
#if GS_WORDS_BIGENDIAN
                  cdata[i + 0] = cdata[i + 1];
                  cdata[i + 1] = cdata[i + 2];
                  cdata[i + 2] = cdata[i + 3];
                  cdata[i + 3] = d;
#else
                  cdata[i + 0] = cdata[i + 2];
                  //cdata[i + 1] = cdata[i + 1];
                  cdata[i + 2] = d;
                  //cdata[i + 3] = cdata[i + 3];
#endif 
                }
            }
        }

        // Create the image and add the bitmap representation...
        result = [[[NSImage alloc] initWithSize: NSMakeSize(width, height)] autorelease];
        [result addRepresentation: bmp];
      }
      
      // Cleanup the screen HDC...
      [self deleteScreenHdc:hdc];
    }
  
  // Return whatever we got...
  return result;
}
@end

