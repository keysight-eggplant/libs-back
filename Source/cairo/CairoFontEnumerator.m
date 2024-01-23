########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: c43e4677848a4965d825835e0c39377983f4124f
# Date: 2015-07-14 22:36:43 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: aae0f7748c44cc465e02c8ce9cccfdc4a0bbfbf4
# Date: 2012-11-21 20:53:22 +0000
########## End of Keysight Technologies Notice ##########
/*
   CairoFontEnumerator.m
 
   Copyright (C) 2003 Free Software Foundation, Inc.

   August 31, 2003
   Written by Banlu Kemiyatorn <object at gmail dot com>
   Base on original code of Alex Malmberg
   Rewrite: Fred Kiefer <fredkiefer@gmx.de>
   Date: Jan 2006
 
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

#include "cairo/CairoFontEnumerator.h"
#include "cairo/CairoFontInfo.h"

@implementation CairoFontEnumerator 

+ (Class) faceInfoClass
{
  return [CairoFaceInfo class];
    }

+ (CairoFaceInfo *) fontWithName: (NSString *) name
{
  return (CairoFaceInfo *) [super fontWithName: name];
    }

@end

