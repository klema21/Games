#include <iostream>

using namespace std;

#include <Windows.h>

int nScreenWidth = 80;
int nScreenHeight = 30;
wstring tetromino[7];
int nFieldWidth = 12;
int nFieldHeight = 18;
unsigned char *pField = nullptr;

int Rotate(int px, int py, int r)
{
    int pi = 0;
    switch (r % 4) {
      case 0:
        pi = py * 4 + px;
        break;

      case 1:
        pi = 12 + py - (px * 4);
        break;

      case 2:
        pi = 15 - (py * 4) - px;
        break;

      case 3:
        pi = 3 - py + (px * 4);
        break;
    }

    return pi;
}

int main()
{
    tetromino[0].append(L"..X...X...X...X."); // Tetronimos 4x4
	tetromino[1].append(L"..X..XX...X.....");
	tetromino[2].append(L".....XX..XX.....");
	tetromino[3].append(L"..X..XX..X......");
	tetromino[4].append(L".X...XX...X.....");
	tetromino[5].append(L".X...X...XX.....");
	tetromino[6].append(L"..X...X..XX.....");

    pField = new unsigned char[nFieldWidth*nFieldHeight]; // Create play field buffer
    for (int x = 0; x < nFieldWidth; x++) // Board Boundary
        for (int y = 0; y < nFieldHeight; y++)
            pField[y*nFieldWidth + x] = (x == 0 || x == nFieldWidth-1 || y == nFieldHeight - 1) ? 9 : 0;

    // Create Screen Buffer
	wchar_t *screen = new wchar_t[nScreenWidth*nScreenHeight];
	for (int i = 0; i < nScreenWidth*nScreenHeight; i++) screen[i] = L' ';
	HANDLE hConsole = CreateConsoleScreenBuffer(GENERIC_READ | GENERIC_WRITE, 0, NULL, CONSOLE_TEXTMODE_BUFFER, NULL);
	SetConsoleActiveScreenBuffer(hConsole);
	DWORD dwBytesWritten = 0;

	bool bGameOver = false;

	while (!bGameOver)
    {
        // Draw Field
		for (int x = 0; x < nFieldWidth; x++)
			for (int y = 0; y < nFieldHeight; y++)
				screen[(y + 2)*nScreenWidth + (x + 2)] = L" ABCDEFG=#"[pField[y*nFieldWidth + x]];

        // Display Frame
        WriteConsoleOutputCharacter(hConsole, screen, nScreenWidth * nScreenHeight, { 0,0 }, &dwBytesWritten);

    }

    return 0;
}
