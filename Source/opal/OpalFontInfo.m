########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Frank Le Grand
# Commit ID: 1b82d912b55f817956e396273e2eb6816fa37389
# Date: 2013-08-09 14:21:15 +0000
########## End of Keysight Technologies Notice ##########
/*
   OpalFontInfo.m

   Copyright (C) 2013 Free Software Foundation, Inc.

   Author: Ivan Vucica <ivan@vucica.net>
   Date: June 2013

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

#import <Foundation/Foundation.h>
#import "opal/OpalFontInfo.h"

@implementation OpalFontInfo

- (id) initWithFontName: (NSString *)name 
                 matrix: (const CGFloat *)fmatrix 
             screenFont: (BOOL)p_screenFont
{
  NSDebugLLog(@"OpalFontInfo", @"OpalFontInfo: instantiating font info for %@", name);
  return [super init];
}
- (NSRect) boundingRectForGlyph: (NSGlyph)glyph
{
  NSDebugLLog(@"OpalFontInfo", @"OpalFontInfo: %s - %c", __PRETTY_FUNCTION__, glyph);
  return NSMakeRect(0, 0, 10, 10);
}
- (CGFloat) widthOfString: (NSString *)string
{
  NSDebugLLog(@"OpalFontInfo", @"OpalFontInfo: %s - %@", __PRETTY_FUNCTION__, string);
  return [string length] * 10;
}
- (NSSize) advancementForGlyph: (NSGlyph)glyph
{
  NSDebugLLog(@"OpalFontInfo", @"OpalFontInfo: %s - %c", __PRETTY_FUNCTION__, glyph);
  return NSMakeSize(100,100);
}
- (NSGlyph) glyphWithName: (NSString *) glyphName
{
  NSDebugLLog(@"OpalFontInfo", @"OpalFontInfo: %s - %@", __PRETTY_FUNCTION__, glyphName);

  // FIXME: incorrect
  NSGlyph g = [glyphName cString][0];
  return g;
}
- (NSGlyph) glyphForCharacter: (unichar)c
{
  // FIXME: default in 'gui' uses -glyphIsEncoded: or otherwise
  // returns null glyph. the default should be sufficient, and is
  // sufficient for cairo backend.
   
  return c;
}
- (void) appendBezierPathWithGlyphs: (NSGlyph *)glyphs 
                              count: (int)length 
                       toBezierPath: (NSBezierPath *)path
{
  [path lineToPoint: NSMakePoint(length*10, 10)];
}
@end
