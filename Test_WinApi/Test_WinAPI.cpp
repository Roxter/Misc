// Test_WinApi.cpp: определяет точку входа для консольного приложения.
//

#include "stdafx.h"
#include "VolumeOutMaster.h"
#include "VolumeInXXX.h"

#define MIN_VOLUME 65000
#define MAX_VOLUME 65535

LRESULT CALLBACK _tWndProc(HWND, UINT, WPARAM, LPARAM);
bool CALLBACK EnumInputLineProc( UINT uLineIndex, MIXERLINE* pLineInfo, DWORD dwUserValue );
DWORD WINAPI autochangeVolmic( LPVOID lpParam );

const TCHAR CLASS_NAME[] = _T("Main Window Class");	// Имя главного класса
TCHAR _tWinName[] = _T("MainFrame");		// Тип TCHAR преобразуется в wchar_t, если определена константа _UNICODE, и в char, если константа не определена
bool vol_is_active = FALSE;
static HANDLE hThread = NULL;
bool close_status = FALSE;

// Пользовательская функция
void SetWindowPosSize(HWND hMainWnd, int x, int y, int width, int height) {
	RECT rect;
	GetWindowRect(hMainWnd, &rect);
	LONG window_width = rect.right - rect.left;
	LONG window_height = rect.bottom - rect.top;
	if (x > -1 && y > -1) {		// если задан Pos
		if (width > 0 && height > 0)		// если задан Size
			MoveWindow(hMainWnd, x, y , width, height, NULL);
		else	// если задан Pos, но не задан Size, то берем исходный Size
			MoveWindow(hMainWnd, x, y , window_width, window_height, NULL);
	}
	else	// если не задан Pos
		if (width > 0 && height > 0)	// Size всё равно должен быть задан
			MoveWindow(hMainWnd, rect.left, rect.top, width, height, NULL);
}

// Пользовательская функция
void print(std::string str) {
	std::string n = "\n";
	std::string out = str + n;
	OutputDebugString(out.c_str());
}

std::string convert_i_to_str(int i);

// Пользовательская функция
void print(int i) {
	std::string out;
	out = convert_i_to_str(i);
	print(out);
}

// Пользовательская функция
std::string convert_i_to_str(int i) {
	const size_t buflen = 256;
	TCHAR s[buflen];
	_sntprintf(s, buflen, _T("%d"), i);
	return s;
}

// Пользовательская функция
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

// Пользовательская функция
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

// Пользовательская функция
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

// Пользовательская функция
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

int APIENTRY WinMain(HINSTANCE This,	// Дескриптор текущего приложения
	HINSTANCE Prev,						// Хранилище предыдущего экземпляра приложения (в современных системах всегда 0)
	LPSTR cmd,							// Указатель командной строки (эквивалент TCHAR*)
	int mode)							// Режим отображения окна
{
// Определение класса окна
	WNDCLASS wc;	// Класс окна
	wc.hInstance = This;
	wc.lpszClassName = CLASS_NAME;					// Имя класса окна
	wc.lpfnWndProc = _tWndProc;						// Функция окна
	wc.style = FALSE;								// Стиль окна
	wc.hIcon = LoadIcon(NULL, IDI_EXCLAMATION);			// Стандартная иконка
	wc.hCursor = LoadCursor(NULL, IDC_ARROW);		// Стандартный курсор
	wc.lpszMenuName = NULL;							// Нет меню
	wc.cbClsExtra = FALSE;							// Нет дополнительных данных класса
	wc.cbWndExtra = FALSE;							// Нет дополнительных данных окна
	wc.hbrBackground = (HBRUSH) (COLOR_WINDOW+1);	// Заполнение окна белым цветом
	if (!RegisterClass(&wc)) return FALSE;	// Регистрация класса окна

// Создание окна
	// Дескриптор главного окна программы (Каркас Windows-приложения)
	HWND hMainWnd = CreateWindow(CLASS_NAME,	// Имя класса окна
		"AutoVolume Mic",			// Заголовок окна
		WS_OVERLAPPEDWINDOW,					// Стиль окна
		CW_USEDEFAULT,							// x
		CW_USEDEFAULT,							// y
		CW_USEDEFAULT,							// Width
		CW_USEDEFAULT,							// Height
		HWND_DESKTOP,							// Дескриптор родительского окна
		NULL,									// Нет меню
		This,									// Дескриптор приложения
		NULL);									// Дополнительной информации нет

	SetWindowPosSize(hMainWnd, GetSystemMetrics(SM_CXSCREEN) / 2, GetSystemMetrics(SM_CYSCREEN) / 2, 400, 200);		// Задать параметры окна
	ShowWindow(hMainWnd, mode);		// Показать окно
	UpdateWindow(hMainWnd);

	runTask(); // Запуск основной задачи
	
// Цикл обработки сообщений
	MSG msg;	// Структура для хранения сообщения
	while (GetMessage(&msg, NULL, FALSE, FALSE))
	{
		TranslateMessage(&msg);		// Функция трансляции кодов нажатой клавиши
		DispatchMessage(&msg);		// Посылка сообщения функции _tWndProc()
	}
	return msg.wParam;
}

// Оконная функция вызывается операционной системой и получает сообщения из очереди для данного приложения
LRESULT CALLBACK _tWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	#define ID_MYBUTTON 1	// Идентификатор кнопки внутри главного окна

	switch (message)	// Обработчик сообщений
	{
		case WM_CREATE:		// при создании окна внедряем button
			CreateWindow("button",
				"Autochange Volmic Disabled",
				WS_CHILD|BS_PUSHBUTTON|WS_VISIBLE,		// Обозначение дочернего окна, в котором будет использоваться целочисленный идентификатор для оповещения родительского окна
				90, 70, 220, 20,
				hWnd,
				(HMENU) ID_MYBUTTON,
				NULL,
				NULL);
			return FALSE;
		case WM_COMMAND:	// Если нажата кнопка
			if ((HIWORD(wParam) == 0) && (LOWORD(wParam) == 1)) {
				//MessageBox(hWnd, "You pressed my button", "MessageBox", MB_OK|MB_ICONWARNING);
				if (vol_is_active == TRUE) {	// Громкость менять можно
					vol_is_active = FALSE;
					SendMessage(GetDlgItem(hWnd, ID_MYBUTTON), WM_SETTEXT, 0, (LPARAM) "Autochange Volmic Disabled");
					print("proc_autovolmic is paused");
				}
				else {	// Громкость менять нельзя
					vol_is_active = TRUE;
					SendMessage(GetDlgItem(hWnd, ID_MYBUTTON), WM_SETTEXT, 0, (LPARAM) "Autochange Volmic Enabled");
					print("proc_autovolmic is continued");
				}
			}
			return FALSE;
		case WM_DESTROY:
			if (hThread != NULL) {		// Корректное завершение потока
				close_status = TRUE;	// Команда на завершение работы в потоке
				WaitForSingleObject(hThread, INFINITE);		// Ожидание завершения
				CloseHandle(hThread);	// Процедура завершения потока
				hThread = NULL;		// Обнуление дескриптора потока
			}
			PostQuitMessage(FALSE);	// если пользователь закрыл окно
			break;		// Завершение программы
		default: return DefWindowProc(hWnd, message, wParam, lParam);	// Обработка сообщения по умолчанию
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