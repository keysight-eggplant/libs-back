########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Frank Le Grand
# Commit ID: 1b82d912b55f817956e396273e2eb6816fa37389
# Date: 2013-08-09 14:21:15 +0000
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

#ifndef CairoGState_h
#define CairoGState_h

#include <cairo.h>
#include "gsc/GSGState.h"


@class CairoSurface;

@interface CairoGState : GSGState
{
  @public
    cairo_t *_ct;
    CairoSurface *_surface;
}

- (void) GSCurrentSurface: (CairoSurface **)surface : (int *)x : (int *)y;
- (void) GSSetSurface: (CairoSurface *)surface : (int)x : (int)y;

- (void) showPage;
@end

#endif
