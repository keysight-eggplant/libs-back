########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: f9303f7bbd9cecf24d5930e06c828c902d074bfc
# Date: 2016-05-29 20:28:36 +0000
########## End of Keysight Technologies Notice ##########
#pragma once
#include "afx.h"

class ToastEventHandler;

class CToastNotification : public CObject
{
public:
  CToastNotification(ABI::Windows::UI::Notifications::IToastNotification * toastNotification, HWND _hwnd);
  ~CToastNotification();

protected:

private:
  ABI::Windows::UI::Notifications::IToastNotification *toastNotification;
  ToastEventHandler                                   *toastEventHandler;
  EventRegistrationToken activatedToken;
  EventRegistrationToken dismissedToken;
  EventRegistrationToken failedToken;
};