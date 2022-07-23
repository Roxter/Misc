// Test_WinApi.cpp: ���������� ����� ����� ��� ����������� ����������.
//

#include "stdafx.h"
#include "VolumeOutMaster.h"
#include "VolumeInXXX.h"

#define MIN_VOLUME 65000
#define MAX_VOLUME 65535

LRESULT CALLBACK _tWndProc(HWND, UINT, WPARAM, LPARAM);
bool CALLBACK EnumInputLineProc( UINT uLineIndex, MIXERLINE* pLineInfo, DWORD dwUserValue );
DWORD WINAPI autochangeVolmic( LPVOID lpParam );

const TCHAR CLASS_NAME[] = _T("Main Window Class");	// ��� �������� ������
TCHAR _tWinName[] = _T("MainFrame");		// ��� TCHAR ������������� � wchar_t, ���� ���������� ��������� _UNICODE, � � char, ���� ��������� �� ����������
bool vol_is_active = FALSE;
static HANDLE hThread = NULL;
bool close_status = FALSE;

// ���������������� �������
void SetWindowPosSize(HWND hMainWnd, int x, int y, int width, int height) {
	RECT rect;
	GetWindowRect(hMainWnd, &rect);
	LONG window_width = rect.right - rect.left;
	LONG window_height = rect.bottom - rect.top;
	if (x > -1 && y > -1) {		// ���� ����� Pos
		if (width > 0 && height > 0)		// ���� ����� Size
			MoveWindow(hMainWnd, x, y , width, height, NULL);
		else	// ���� ����� Pos, �� �� ����� Size, �� ����� �������� Size
			MoveWindow(hMainWnd, x, y , window_width, window_height, NULL);
	}
	else	// ���� �� ����� Pos
		if (width > 0 && height > 0)	// Size �� ����� ������ ���� �����
			MoveWindow(hMainWnd, rect.left, rect.top, width, height, NULL);
}

// ���������������� �������
void print(std::string str) {
	std::string n = "\n";
	std::string out = str + n;
	OutputDebugString(out.c_str());
}

std::string convert_i_to_str(int i);

// ���������������� �������
void print(int i) {
	std::string out;
	out = convert_i_to_str(i);
	print(out);
}

// ���������������� �������
std::string convert_i_to_str(int i) {
	const size_t buflen = 256;
	TCHAR s[buflen];
	_sntprintf(s, buflen, _T("%d"), i);
	return s;
}

// ���������������� �������
void changeVolume() {
	UINT uMicrophoneLineIndex = (UINT)-1;
	if ( !CVolumeInXXX::EnumerateInputLines( EnumInputLineProc, (DWORD)&uMicrophoneLineIndex ) )
	{
		print("No Input Lines!");
	}
	if ( uMicrophoneLineIndex == (UINT)-1 )
	{
		print("Impossible record mic access!");
	}
	IVolume* pMicrophoneVolume = (IVolume*)new CVolumeInXXX( uMicrophoneLineIndex );
	if ( !pMicrophoneVolume || !pMicrophoneVolume->IsAvailable() )
	{
		print("Microphone Volume is not Available!");
	}
}

// ���������������� �������
void findDevice() {
	UINT n_devices = waveInGetNumDevs();	// 2
	WAVEINCAPS waveInCaps;
	for (UINT i = 0; i < n_devices; i++) {
		if (waveInGetDevCaps(i, &waveInCaps, sizeof(WAVEINCAPS)) != MMSYSERR_NOERROR) {
			print("could not determine capabilities for device: {}" + convert_i_to_str(i));
		}
		else
			TRACE(waveInCaps.szPname);
	}
	//return id;
}

// ���������������� �������
DWORD WINAPI autoChangeVolMic(LPVOID lpParam) {
	int _device_id = 0;
	CVolumeInXXX vol (_device_id);
	while (!close_status) {
		if (vol_is_active) {
			if (vol.GetCurrentVolume() < MIN_VOLUME)
				vol.SetCurrentVolume ((DWORD) MAX_VOLUME);
		}
		Sleep(100);
	}
	return 0;
}

// ���������������� �������
void runTask() {
    DWORD dwThreadId = 1;
	hThread = CreateThread(
		NULL,                   // default security attributes
		0,                      // use default stack size  
		autoChangeVolMic,       // thread function name
		0,          // argument to thread function 
		0,                      // use default creation flags 
		&dwThreadId);   // returns the thread identifier
	//ExitProcess(2);
}

int APIENTRY WinMain(HINSTANCE This,	// ���������� �������� ����������
	HINSTANCE Prev,						// ��������� ����������� ���������� ���������� (� ����������� �������� ������ 0)
	LPSTR cmd,							// ��������� ��������� ������ (���������� TCHAR*)
	int mode)							// ����� ����������� ����
{
// ����������� ������ ����
	WNDCLASS wc;	// ����� ����
	wc.hInstance = This;
	wc.lpszClassName = CLASS_NAME;					// ��� ������ ����
	wc.lpfnWndProc = _tWndProc;						// ������� ����
	wc.style = FALSE;								// ����� ����
	wc.hIcon = LoadIcon(NULL, IDI_EXCLAMATION);			// ����������� ������
	wc.hCursor = LoadCursor(NULL, IDC_ARROW);		// ����������� ������
	wc.lpszMenuName = NULL;							// ��� ����
	wc.cbClsExtra = FALSE;							// ��� �������������� ������ ������
	wc.cbWndExtra = FALSE;							// ��� �������������� ������ ����
	wc.hbrBackground = (HBRUSH) (COLOR_WINDOW+1);	// ���������� ���� ����� ������
	if (!RegisterClass(&wc)) return FALSE;	// ����������� ������ ����

// �������� ����
	// ���������� �������� ���� ��������� (������ Windows-����������)
	HWND hMainWnd = CreateWindow(CLASS_NAME,	// ��� ������ ����
		"AutoVolume Mic",			// ��������� ����
		WS_OVERLAPPEDWINDOW,					// ����� ����
		CW_USEDEFAULT,							// x
		CW_USEDEFAULT,							// y
		CW_USEDEFAULT,							// Width
		CW_USEDEFAULT,							// Height
		HWND_DESKTOP,							// ���������� ������������� ����
		NULL,									// ��� ����
		This,									// ���������� ����������
		NULL);									// �������������� ���������� ���

	SetWindowPosSize(hMainWnd, GetSystemMetrics(SM_CXSCREEN) / 2, GetSystemMetrics(SM_CYSCREEN) / 2, 400, 200);		// ������ ��������� ����
	ShowWindow(hMainWnd, mode);		// �������� ����
	UpdateWindow(hMainWnd);

	runTask(); // ������ �������� ������
	
// ���� ��������� ���������
	MSG msg;	// ��������� ��� �������� ���������
	while (GetMessage(&msg, NULL, FALSE, FALSE))
	{
		TranslateMessage(&msg);		// ������� ���������� ����� ������� �������
		DispatchMessage(&msg);		// ������� ��������� ������� _tWndProc()
	}
	return msg.wParam;
}

// ������� ������� ���������� ������������ �������� � �������� ��������� �� ������� ��� ������� ����������
LRESULT CALLBACK _tWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	#define ID_MYBUTTON 1	// ������������� ������ ������ �������� ����

	switch (message)	// ���������� ���������
	{
		case WM_CREATE:		// ��� �������� ���� �������� button
			CreateWindow("button",
				"Autochange Volmic Disabled",
				WS_CHILD|BS_PUSHBUTTON|WS_VISIBLE,		// ����������� ��������� ����, � ������� ����� �������������� ������������� ������������� ��� ���������� ������������� ����
				90, 70, 220, 20,
				hWnd,
				(HMENU) ID_MYBUTTON,
				NULL,
				NULL);
			return FALSE;
		case WM_COMMAND:	// ���� ������ ������
			if ((HIWORD(wParam) == 0) && (LOWORD(wParam) == 1)) {
				//MessageBox(hWnd, "You pressed my button", "MessageBox", MB_OK|MB_ICONWARNING);
				if (vol_is_active == TRUE) {	// ��������� ������ �����
					vol_is_active = FALSE;
					SendMessage(GetDlgItem(hWnd, ID_MYBUTTON), WM_SETTEXT, 0, (LPARAM) "Autochange Volmic Disabled");
					print("proc_autovolmic is paused");
				}
				else {	// ��������� ������ ������
					vol_is_active = TRUE;
					SendMessage(GetDlgItem(hWnd, ID_MYBUTTON), WM_SETTEXT, 0, (LPARAM) "Autochange Volmic Enabled");
					print("proc_autovolmic is continued");
				}
			}
			return FALSE;
		case WM_DESTROY:
			if (hThread != NULL) {		// ���������� ���������� ������
				close_status = TRUE;	// ������� �� ���������� ������ � ������
				WaitForSingleObject(hThread, INFINITE);		// �������� ����������
				CloseHandle(hThread);	// ��������� ���������� ������
				hThread = NULL;		// ��������� ����������� ������
			}
			PostQuitMessage(FALSE);	// ���� ������������ ������ ����
			break;		// ���������� ���������
		default: return DefWindowProc(hWnd, message, wParam, lParam);	// ��������� ��������� �� ���������
	}
	return FALSE;
}

bool CALLBACK EnumInputLineProc( UINT uLineIndex, MIXERLINE* pLineInfo, DWORD dwUserValue )
{
        if ( pLineInfo->dwComponentType == MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE )
        {
               *((UINT*)dwUserValue) = uLineIndex;
               return false;
        }
        return true;
}