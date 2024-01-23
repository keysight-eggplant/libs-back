########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: 21a32342aa618a59d1be420f84c730f2dbd8b109
# Date: 2020-03-05 14:33:58 -0500
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 8e43e75cf5bea127220e4e01bce0356228898a7e
# Date: 2020-03-05 13:24:51 -0500
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 3b2fc608844f5592319ca708aea381a8d0035b5a
# Date: 2020-03-05 13:14:43 -0500
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 535348a54d14e714b4e38af7fa06b802b2d80240
# Date: 2020-03-04 14:14:59 -0500
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 168d5d5a65ff0ce9be7fcd9e800f036369650c69
# Date: 2020-03-04 11:22:51 -0500
########## End of Keysight Technologies Notice ##########
#  Copyright (C) 2004 Free Software Foundation, Inc.
#
#  Author: Banlu Kemiyatorn <object at gmail dot com>
#
#  This file is part of the GNUstep Backend.
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library; see the file COPYING.LIB.
#  If not, see <http://www.gnu.org/licenses/> or write to the 
#  Free Software Foundation, 51 Franklin Street, Fifth Floor, 
#  Boston, MA 02110-1301, USA.

PACKAGE_NAME = gnustep-back
GNUSTEP_LOCAL_ADDITIONAL_MAKEFILES=../../back.make
include $(GNUSTEP_MAKEFILES)/common.make

include ../../config.make

SUBPROJECT_NAME=headlesslib

# The Objective-C source files to be compiled
headlesslib_OBJC_FILES = \
  HeadlessSurface.m \
  HeadlessFontInfo.m \
  HeadlessGState.m \
  HeadlessContext.m \
  HeadlessFontEnumerator.m \
  HeadlessFaceInfo.m \



ifeq ($(BUILD_SERVER),xheadless)
  headlesslib_OBJC_FILES += HeadlessModernSurface.m
endif

headlesslib_OBJC_FILES += 

-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/subproject.make

-include GNUmakefile.postamble

