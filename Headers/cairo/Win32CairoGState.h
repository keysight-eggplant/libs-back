########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: 05640cbf486e802f65ab548937a057f237dd31c7
# Date: 2016-04-03 20:59:32 +0000
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
# Commit ID: f7d566721cadd9b56b1929004e94a45ffd1d4fc1
# Date: 2012-08-08 23:02:51 +0000
########## End of Keysight Technologies Notice ##########
/*
   Copyright (C) 2004 Free Software Foundation, Inc.

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

#ifndef Win32CairoGState_h
#define Win32CairoGState_h

#include "cairo/CairoGState.h"
#include <AppKit/NSBezierPath.h>


@interface Win32CairoGState : CairoGState
{
  NSBezierPath *_lastPath;
}

- (HDC) getHDC;
- (void) releaseHDC: (HDC)hdc;

@end

#endif
