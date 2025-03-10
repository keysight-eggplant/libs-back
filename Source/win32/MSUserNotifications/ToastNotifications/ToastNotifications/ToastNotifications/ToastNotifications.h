// ========== Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ========== 
// Committed by: Marcian Lytwyn 
// Commit ID: f9303f7bbd9cecf24d5930e06c828c902d074bfc 
// Date: 2016-05-29 20:28:36 +0000 
// ========== End of Keysight Technologies Notice ========== 
// ToastNotifications.h : main header file for the ToastNotifications DLL
//

#pragma once
#
#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols
#include <vector>

const wchar_t AppId[] = L"Testplant.Notifications.Eggplant";

// CToastNotificationsApp
// See ToastNotifications.cpp for the implementation of this class
//
class CToastNotification;

class CToastNotificationsApp : public CWinApp
{
public:
	CToastNotificationsApp();
  ~CToastNotificationsApp();

// Overrides
public:
  virtual BOOL InitInstance();
  virtual BOOL ExitInstance();

	DECLARE_MESSAGE_MAP()
	friend class ToastEventHandler;

public:
  HRESULT DisplayToast(HWND hWnd, wchar_t* notificationTitle, wchar_t* notificationDescription, wchar_t* imagePath);
	HRESULT CreateToastXml(
		_In_ ABI::Windows::UI::Notifications::IToastNotificationManagerStatics *toastManager,
    _Outptr_ ABI::Windows::Data::Xml::Dom::IXmlDocument **xml, wchar_t* notificationTitle, wchar_t* notificationDescription, wchar_t* imagePath);
	HRESULT CreateToast(
		_In_ ABI::Windows::UI::Notifications::IToastNotificationManagerStatics *toastManager,
		_In_ ABI::Windows::Data::Xml::Dom::IXmlDocument *xml, HWND hWnd
		);
	HRESULT SetImageSrc(
		_In_z_ wchar_t *imagePath,
		_In_ ABI::Windows::Data::Xml::Dom::IXmlDocument *toastXml
		);
	HRESULT SetTextValues(
		_In_reads_(textValuesCount) wchar_t **textValues,
		_In_ UINT32 textValuesCount,
		_In_reads_(textValuesCount) UINT32 *textValuesLengths,
		_In_ ABI::Windows::Data::Xml::Dom::IXmlDocument *toastXml
		);
	HRESULT SetNodeValueString(
		_In_ HSTRING onputString,
		_In_ ABI::Windows::Data::Xml::Dom::IXmlNode *node,
		_In_ ABI::Windows::Data::Xml::Dom::IXmlDocument *xml
		);

protected:
  HRESULT TryCreateShortcut();
  HRESULT InstallShortcut(_In_z_ wchar_t *shortcutPath);

private:
	HWND _hwnd;
	HWND _hEdit;
  std::vector<CToastNotification*> toasts;
};
