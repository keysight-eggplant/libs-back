########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: 21a32342aa618a59d1be420f84c730f2dbd8b109
# Date: 2020-03-05 14:33:58 -0500
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: ab5a7d11988ac671273ec9a47c85d5fe65e49c3f
# Date: 2020-03-05 10:42:47 -0500
########## End of Keysight Technologies Notice ##########
/*
   Copyright (C) 2004 Free Software Foundation, Inc.

   Author:  Banlu Kemiyatorn <object at gmail dot com>

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

#ifndef HeadlessGState_h
#define HeadlessGState_h

#include "gsc/GSGState.h"


@class HeadlessSurface;

@interface HeadlessGState : GSGState
{
  @public
    void *_ct;
    HeadlessSurface *_surface;
}

- (void) GSCurrentSurface: (HeadlessSurface **)surface : (int *)x : (int *)y;
- (void) GSSetSurface: (HeadlessSurface *)surface : (int)x : (int)y;

- (void) showPage;
@end

#endif
