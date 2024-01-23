########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: c43e4677848a4965d825835e0c39377983f4124f
# Date: 2015-07-14 22:36:43 +0000
--------------------
# Committed by: Frank Le Grand
# Commit ID: 1b82d912b55f817956e396273e2eb6816fa37389
# Date: 2013-08-09 14:21:15 +0000
########## End of Keysight Technologies Notice ##########
/*
   OpalGState.h

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

#import <CoreGraphics/CoreGraphics.h>
#import "gsc/GSGState.h"

@class OpalSurface;

@interface OpalGState : GSGState
{
  OpalSurface * _opalSurface;

  /** When a surface's gstate is being switched away from,
      we store the current gstate in _opGState.

      When a surface's gstate is being switched back to,
      if _opGState is not nil, we apply the stored gstate.

      To facilitate OpalGState class instance copying, we 
      also store a copy of the gstate inside _opGState when
      gstate's -copyWithZone: is being run. This is because
      the same _opalSurface should be used in both new and
      old OpalGState. 

      The same is done in Cairo backend, with one key 
      difference: since all graphics state operations in 
      Cairo are done directly on cairo_t and are unrelated
      to the surface, Opal mixes the concepts of a gstate
      and a surface into a context. Hence, when gstate is
      switched, it's OpalContext's duty to apply the stored
      copy of a gstate from _opGState. No such trickery
      is needed with Cairo, as Cairo backend can simply
      have a different cairo_t with the same surface.
   **/
  OPGStateRef _opGState;
}
@end

@interface OpalGState (InitializationMethods)
- (void) DPSinitgraphics;
- (void) GSSetSurface: (OpalSurface *)opalSurface
                     : (int)x
                     : (int)y;
- (void) GSCurrentSurface: (OpalSurface **)surface
                         : (int *)x
                         : (int *)y;
@end

@interface OpalGState (Accessors)
- (CGContextRef) CGContext;
- (OPGStateRef) OPGState;
- (void) setOPGState: (OPGStateRef) opGState;
@end

@interface OpalGState (NonrequiredMethods)
- (void) DPSgsave;
- (void) DPSgrestore;
@end
