########## Keysight Technologies Added Changes To Satisfy LGPL 2.x Section 2(a) Requirements ##########
# Committed by: Marcian Lytwyn
# Commit ID: f9303f7bbd9cecf24d5930e06c828c902d074bfc
# Date: 2016-05-29 20:28:36 +0000
--------------------
# Committed by: Marcian Lytwyn
# Commit ID: 58ca6b5c8eade494f10a3bf60bc4968e7c5234ca
# Date: 2016-05-11 20:46:04 +0000
########## End of Keysight Technologies Notice ##########
#pragma once

typedef ABI::Windows::Foundation::ITypedEventHandler<ABI::Windows::UI::Notifications::ToastNotification *, ::IInspectable *> DesktopToastActivatedEventHandler;
typedef ABI::Windows::Foundation::ITypedEventHandler<ABI::Windows::UI::Notifications::ToastNotification *, ABI::Windows::UI::Notifications::ToastDismissedEventArgs *> DesktopToastDismissedEventHandler;
typedef ABI::Windows::Foundation::ITypedEventHandler<ABI::Windows::UI::Notifications::ToastNotification *, ABI::Windows::UI::Notifications::ToastFailedEventArgs *> DesktopToastFailedEventHandler;

class ToastEventHandler :
    public Microsoft::WRL::Implements<DesktopToastActivatedEventHandler, DesktopToastDismissedEventHandler, DesktopToastFailedEventHandler>
{
public:
    ToastEventHandler::ToastEventHandler(_In_ HWND hToActivate, _In_ HWND hEdit);
    ~ToastEventHandler();
        
    // DesktopToastActivatedEventHandler 
    IFACEMETHODIMP Invoke(_In_ ABI::Windows::UI::Notifications::IToastNotification *sender, _In_ IInspectable* args);

    // DesktopToastDismissedEventHandler
    IFACEMETHODIMP Invoke(_In_ ABI::Windows::UI::Notifications::IToastNotification *sender, _In_ ABI::Windows::UI::Notifications::IToastDismissedEventArgs *e);
        
    // DesktopToastFailedEventHandler
    IFACEMETHODIMP Invoke(_In_ ABI::Windows::UI::Notifications::IToastNotification *sender, _In_ ABI::Windows::UI::Notifications::IToastFailedEventArgs *e);

    // IUnknown
    IFACEMETHODIMP_(ULONG) AddRef();

    IFACEMETHODIMP_(ULONG) Release();

    IFACEMETHODIMP QueryInterface(_In_ REFIID riid, _COM_Outptr_ void **ppv) {
        if (IsEqualIID(riid, IID_IUnknown))
            *ppv = static_cast<IUnknown*>(static_cast<DesktopToastActivatedEventHandler*>(this));
        else if (IsEqualIID(riid, __uuidof(DesktopToastActivatedEventHandler)))
            *ppv = static_cast<DesktopToastActivatedEventHandler*>(this);
        else if (IsEqualIID(riid, __uuidof(DesktopToastDismissedEventHandler)))
            *ppv = static_cast<DesktopToastDismissedEventHandler*>(this);
        else if (IsEqualIID(riid, __uuidof(DesktopToastFailedEventHandler)))
            *ppv = static_cast<DesktopToastFailedEventHandler*>(this);
        else *ppv = nullptr;

        if (*ppv) {
            reinterpret_cast<IUnknown*>(*ppv)->AddRef();
            return S_OK;
        }

        return E_NOINTERFACE;
    }
    
private:
    ULONG _ref;
    HWND _hToActivate;
    HWND _hEdit;
};
