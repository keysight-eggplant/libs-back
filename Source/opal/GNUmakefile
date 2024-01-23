########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Frank Le Grand
# Commit ID: 1b82d912b55f817956e396273e2eb6816fa37389
# Date: 2013-08-09 14:21:15 +0000
########## End of Keysight Technologies Notice ##########
#  Copyright (C) 2013 Free Software Foundation, Inc.
#
#  Author: Ivan Vucica <ivan@vucica.net>
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

SUBPROJECT_NAME=opal

# The Objective-C source files to be compiled
opal_OBJC_FILES = OpalSurface.m \
  OpalFontInfo.m \
  OpalGState.m \
  OpalContext.m \
  OpalFontEnumerator.m \
  OpalFaceInfo.m \
  OpalPSSurface.m \
  OpalPDFSurface.m \

ifeq ($(BUILD_SERVER),x11DISABLED)
  ifeq ($(WITH_GLITZ),yes)
    opal_OBJC_FILES += XGCairoGlitzSurface.m
  else
    opal_OBJC_FILES += XGCairoSurface.m XGCairoXImageSurface.m XGCairoModernSurface.m
  endif
else
  ifeq ($(BUILD_GRAPHICS),opalDISABLED)
    ifeq ($(WITH_GLITZ),yes)
      opal_OBJC_FILES += Win32CairoGlitzSurface.m
    else
      opal_OBJC_FILES += Win32CairoSurface.m Win32CairoGState.m
      # Win32CairoXImageSurface.m 
    endif
  endif
endif

opal_OBJC_FILES += 

-include GNUmakefile.preamble

include $(GNUSTEP_MAKEFILES)/subproject.make

-include GNUmakefile.postamble

