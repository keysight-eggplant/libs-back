########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: 4dc6f34ac8c2c74fb58da603626a8a56848f7fd2
# Date: 2018-01-12 23:27:18 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: e67d8442e9164d14610ed9a9b2e53c6bbb2c7f2a
# Date: 2016-04-13 21:08:01 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 6e1de7df76e370a8cae7d5cae862e9fe8ed14eca
# Date: 2016-04-04 14:50:09 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 05640cbf486e802f65ab548937a057f237dd31c7
# Date: 2016-04-03 20:59:32 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: a56731c3574d3ca17080ea2592669040af2ac598
# Date: 2014-03-11 22:24:20 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: 45e9f8b8e04a3c268eb8c97e6631310064390510
# Date: 2013-08-09 16:06:05 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: 1b82d912b55f817956e396273e2eb6816fa37389
# Date: 2013-08-09 14:21:15 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 598be2609a0cba9ae2e45e291c9f0fcefe96bcb4
# Date: 2012-08-08 22:21:19 +0000
########## End of Keysight Technologies Notice ##########
/*
   Win32CairoGState.m

   Copyright (C) 2003 Free Software Foundation, Inc.

   August 8, 2012
 
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

#include "cairo/Win32CairoGState.h"
#include "cairo/CairoSurface.h"
#include <cairo-win32.h>

@interface CairoGState (Private)
- (void) _setPath;
@end

@implementation Win32CairoGState 

static inline
POINT GSWindowPointToMS(GSGState *s, NSPoint p)
{
  POINT p1;
  
  p1.x = p.x - s->offset.x;
  p1.y = s->offset.y - p.y;
  
  return p1;
}

+ (void) initialize
{
  if (self == [Win32CairoGState class])
    {
    }
}

- (void) dealloc
{
  DESTROY(_lastPath);
  [super dealloc];
}

- (id)copyWithZone: (NSZone *)zone
{
  Win32CairoGState *object = [super copyWithZone: zone];
  object->_lastPath = [_lastPath copy];
  return object;
}

- (HDC) getHDC
{
  NSDebugMLLog(@"Win32CairoGState", @"self: %p path: %@ _lastpath: %@", self, path, _lastPath);
  if (_surface)
    {
      cairo_surface_flush([_surface surface]);
      HDC hdc = cairo_win32_surface_get_dc([_surface surface]);
      NSDebugLLog(@"CairoGState",
                  @"%s:_surface: %p hdc: %p\n", __PRETTY_FUNCTION__,
                  _surface, hdc);
      
      // The WinUXTheme (and maybe others in the future?) draw directly into the HDC...
      // Controls are always given the _bounds to draw into regardless of the actual invalid
      // rectangle requested.  NSView only locks the focus for the invalid rectangle given,
      // which in the failure case, is a partial rectangle for the control.
      
      // This drawing outside of cairo seems to bypass the clipping area, causing controls
      // drawn using MSDN theme button backgrounds OUTSIDE of the actual invalid rectangle
      // when they happen to intersect THRU a control rather than including the entire control.
      // This is an unfortunate side effect of using unions i.e. NSUnionRect for the invalid rectangle,
      // which causes this problem.
      
      // As a side note, it turns out that Apple Cocoa keeps individual rectangles and invokes the
      // drawRect for each rectangle in turn.
      
      // Save the HDC...
      SaveDC(hdc);
      
      // and setup the clipping path region if we have one...
      [self _clipRegionForHDC: hdc];
      
      // Return the HDC...
      return hdc;
    }
  return NULL;
}

- (void) releaseHDC: (HDC)hdc
{
  NSDebugMLLog(@"Win32CairoGState", @"self: %p path: %@ _lastpath: %@", self, path, _lastPath);
  if (hdc && _surface)
    {
      if (hdc != cairo_win32_surface_get_dc([_surface surface]))
      {
        NSLog(@"%s:expHDC: %p recHDC: %p", __PRETTY_FUNCTION__, cairo_win32_surface_get_dc([_surface surface]), hdc);
      }
      else
      {
        // Restore the HDC...
        RestoreDC(hdc, -1);
        
        // and inform cairo that we modified it...
        cairo_surface_mark_dirty([_surface surface]);
      }
    }
}

- (void) _clipRegionForHDC: (HDC)hDC
{
  if (!hDC)
  {
    return;
  }
  NSDebugMLLog(@"Win32CairoGState", @"self: %p path: %@ _lastpath: %@", self, path, _lastPath);

  if (_lastPath == nil)
  {
    return;
  }
  
  unsigned count = [_lastPath elementCount];
  if (count)
  {
    NSBezierPathElement type;
    NSPoint   points[3];
    unsigned	j, i = 0;
    POINT p;
    
    BeginPath(hDC);
    
    for (j = 0; j < count; j++)
    {
      type = [_lastPath elementAtIndex: j associatedPoints: points];
      switch(type)
      {
        case NSMoveToBezierPathElement:
          p = GSWindowPointToMS(self, points[0]);
          MoveToEx(hDC, p.x, p.y, NULL);
          break;
        case NSLineToBezierPathElement:
          p = GSWindowPointToMS(self, points[0]);
          // FIXME This gives one pixel too few
          LineTo(hDC, p.x, p.y);
          break;
        case NSCurveToBezierPathElement:
        {
          POINT bp[3];
          
          for (i = 0; i < 3; i++)
          {
            bp[i] = GSWindowPointToMS(self, points[i]);
          }
          PolyBezierTo(hDC, bp, 3);
        }
          break;
        case NSClosePathBezierPathElement:
          CloseFigure(hDC);
          break;
        default:
          break;
      }
    }
    EndPath(hDC);
    
    // Select the clip path...
    SelectClipPath(hDC, RGN_AND);
  }
  
  // Clear the used clip path...
  // TESTPLANT-MAL-01122018: modified to keep the last path in case
  // the HDC is used again with the current clipping context...
  //DESTROY(_lastPath);
}

- (void) DPSinitclip
{
  NSDebugMLLog(@"Win32CairoGState", @"self: %p path: %@ _lastpath: %@", self, path, _lastPath);
  // Destroy any clipping path we're holding...
  DESTROY(_lastPath);
  
  // and invoke super...
  [super DPSinitclip];
}

- (void) DPSclip
{
  // Invoke super...
  [super DPSclip];
  NSDebugMLLog(@"Win32CairoGState", @"self: %p path: %@ _lastpath: %@", self, path, _lastPath);
  
  // Keep a copy for ourselves for theme drawing directly to HDC...
  if (_lastPath == nil)
  {
    _lastPath = [path copy];
  }
  else
  {
    [_lastPath appendBezierPath: path];
  }
}

@end
