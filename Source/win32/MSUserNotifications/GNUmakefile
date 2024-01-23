########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Paul Landers
# Commit ID: 52b5e5b88ca06a14371e696b6427ea6aca4bda39
# Date: 2019-04-02 10:52:59 -0600
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: c2f3640e2ae4c17f4b2dc5eca60db22fa8db3888
# Date: 2016-06-01 19:24:10 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: dc7101d1c43c92836b2f5744709d108142c56a88
# Date: 2016-05-26 17:27:30 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 4b5a47e2b245df3c82698f98bb0158762b546ebf
# Date: 2016-05-12 16:14:20 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 58ca6b5c8eade494f10a3bf60bc4968e7c5234ca
# Date: 2016-05-11 20:46:04 +0000
########## End of Keysight Technologies Notice ##########
ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
  ifeq ($(GNUSTEP_MAKEFILES),)
    $(warning )
    $(warning Unable to obtain GNUSTEP_MAKEFILES setting from gnustep-config!)
    $(warning Perhaps gnustep-make is not properly installed,)
    $(warning so gnustep-config is not in your PATH.)
    $(warning )
    $(warning Your PATH is currently $(PATH))
    $(warning )
  endif
endif

ifeq ($(GNUSTEP_MAKEFILES),)
  $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

BUNDLE_NAME = NSUserNotification

# Get common definitions - needed for base version information
-include $(GNUSTEP_MAKEFILES)/common.make

NSUserNotification_NEEDS_GUI = NO
NSUserNotification_CFLAGS += -DWINVER=0x0600 -D_WIN32_IE=0x0600 -DBUILD_DLL -fms-extensions -fno-cxx-exceptions
NSUserNotification_OBJCFLAGS += -DWINVER=0x0600 -D_WIN32_IE=0x0600 -DBUILD_DLL -fms-extensions -fno-cxx-exceptions
NSUserNotification_OBJCCFLAGS += -DWINVER=0x0600 -D_WIN32_IE=0x0600 -DBUILD_DLL -fms-extensions -fno-cxx-exceptions
NSUserNotification_PRINCIPAL_CLASS = MSUserNotificationCenter
NSUserNotification_OBJC_FILES =
NSUserNotification_OBJCC_FILES = MSUserNotification.mm
NSUserNotification_BUNDLE_LIBS = -lgnustep-gui -lgdi32 -lgdiplus
#NSUserNotification_LIBS = stdc++
#NSUserNotification_INCLUDE_DIRS += \
#  -I/mingw/lib/gcc/mingw32/4.8.1/include/c++/mingw32 \
#  -I/mingw/lib/gcc/mingw32/4.8.1/include/c++
NSUserNotification_RESOURCE_FILES = \
  Images/GNUstep.png \
  ToastNotifications/obj/ToastNotifications-0.dll \
  TaskbarNotifications/obj/TaskbarNotifications-0.dll
#NSUserNotification_SUBPROJECTS = ToastNotifications TaskbarNotifications
SUBPROJECTS = ToastNotifications TaskbarNotifications

# Set this to the ROOT DIRECTORY of your GNUstep build that contains the 'core' directory...
ifdef GNUSTEP_BASE_MAJOR_VERSION
  ifdef GNUSTEP_BASE_MINOR_VERSION
    BASE_VERSION_DEFINED=1
  endif
endif
ifndef BASE_VERSION_DEFINED
  ifeq ($(GNUSTEP_BUILD_ROOT),)
    $(error You need to checkout core/base and/or set GNUSTEP_BUILD_ROOT to your gnustep root containing 'core/base' before compiling!)
  endif
  include ${GNUSTEP_BUILD_ROOT}/core/base/Version
  GNUSTEP_BASE_MAJOR_VERSION=$(MAJOR_VERSION)
  GNUSTEP_BASE_MAJOR_VERSION=$(MINOR_VERSION)
  BASE_VERSION_DEFINED=1
endif
libgnustep-base_INTERFACE_VERSION=$(GNUSTEP_BASE_MAJOR_VERSION).$(GNUSTEP_BASE_MINOR_VERSION)
NSUserNotification_INSTALL_DIR = $(GNUSTEP_LIBRARY)/Libraries/gnustep-base/Versions/$(libgnustep-base_INTERFACE_VERSION)/Resources/

#include GNUmakefile.postamble

include $(GNUSTEP_MAKEFILES)/common.make
include $(GNUSTEP_MAKEFILES)/aggregate.make
include $(GNUSTEP_MAKEFILES)/bundle.make
