@echo off

echo HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHH     .HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHH.     ,HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHH.##  HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHHHH#.HHHHH/*,*,*,*,*,*,*,*,***,*,**#HHHHHHHHHHHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHHHHHH.*,,***,***,***,***,***,***,*******HHHHHHHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHHHH*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*,,,,,HHHHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHH.,,,***,***,***,***,***,***,***,***,***,***/HHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHH*,,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*HHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHH#,***,***,***,***,***,***,***,***,***,***,***,**HHHHHHHHHHHHHHHHH
echo HHHHHHHHHH..HHH,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*#HHHHHHHHHHHHHHHH
echo HHHHHHH,,,**,/H*,***,***,***,,,*,***,***,***,**,,,**,***,***,***H,,*,***HHHHHHHH
echo HHHHHH.*,,,*,,,,,*,*,*,***#HHHHH.,,*,*,*,*,**/HHHHH.,*,*,*,*,*,*,*,*****HHHHHHHH
echo HHHHHH.*,***,*,*,***,***,.HHHHHHH/**,***,****HHHHHHH.***,***,***,*******HHHHHHHH
echo HHHHHH.,,,,,,,,,,,,,,,,,,,.HHHHH.,,,,,,,,,,,,.HHHHHH,,,,,,,,,,,,,,,,,***HHHHHHHH
echo HHHHHH.,,,,,,/H,,,**,***,***,,,*,***,***,***,**,,,,*,***,***,***H***,***HHHHHHHH
echo HHHHHHH.,,,,*.H,,,,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,***H*,,,,/HHHHHHHHH
echo HHHHHHHHHHHHHHH*,***,***,**,,***,***,***,***,***,***,***,***,**.HHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHH,,,,,,,,*,,#H#,,,,,*,,,*,,,,,,,,*#H*,,,,,,,,,**HHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHH,,*,***,***,**/.HHHHHHHHHHHHH#*,,,*,***,***,*HHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHHH,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*,*HHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHHH**,***,***,***,***,***,***,***,***,***,***,*.HHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHHH*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*HHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHHH**,***,***,*******/..HHHHHHHHH.#/*,*,,,***,***HHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHH*,*,*,******#HHHHHHHHHHHHHHHHHHHHHHHHHHHH./**,,,.HHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHH.,,*,***.HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH.*#HHHHHHHHHHHH
echo HHHHHHHHHHHHHHH/,,,*.HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHH,,#HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHH.HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH
echo HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH

if not exist "./tmp" mkdir "./tmp"

REM Check if Git is installed
echo "Checking for git..."
where git >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    goto GIT_CHECKED
) else (
    goto GIT_INSTALL
)
:GIT_FINISH

REM Check if Git is installed
:GIT_CHECKED
echo "Git is installed."
goto GIT_SKIP

:GIT_INSTALL
echo.
choice /C YN /M "Do you want to download and install Git?"
if errorlevel 2 goto GIT_CANCEL
if errorlevel 1 goto GIT_INSTALL_2

:GIT_INSTALL_2
echo "Git is not installed. Installing Git..."
powershell.exe -Command "Start-Process https://git-scm.com/download/win -Wait"
goto GIT_SKIP

:GIT_CANCEL
echo.
echo Git download cancelled.
echo Please install Git and try again.
pause
exit /b 1

:GIT_SKIP

REM Check if Python is installed
set /p="Checking for python..." <nul
where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    goto PYTHON_CHECKED
) else (
    goto PYTHON_INSTALL
)
:PYTHON_CHECKED
echo "Python is installed."
goto PYTHON_SKIP

:PYTHON_INSTALL
echo.
choice /C YN /M "Do you want to download and install python?"
if errorlevel 2 goto PYTHON_CANCEL
if errorlevel 1 goto PYTHON_INSTALL_2

:PYTHON_INSTALL_2
REM Download Python installer
echo Downloading Python installer...
powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe' -OutFile 'tmp/python.exe'"
REM Install Python
echo Installing Python...
tmp/python.exe /quiet /norestart

:PYTHON_CANCEL
echo Please install python and try again.
pause
exit /b 1

:PYTHON_SKIP


REM Check if pip is installed
set /p="Checking for pip..." <nul
python -m pip >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    goto PIP_CHECKED
) else (
    goto PIP_INSTALL
)
:PIP_CHECKED
echo "Pip is installed."
goto PIP_SKIP

:PIP_INSTALL
echo.
choice /C YN /M "Do you want to download and install pip?"
if errorlevel 2 goto PIP_CANCEL
if errorlevel 1 goto PIP_INSTALL_2

:PIP_INSTALL_2
REM Download get-pip.py
echo Downloading get-pip.py...
powershell -Command "Invoke-WebRequest -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile 'tmp/get-pip.py'"
REM Install pip
echo Installing pip...
python tmp/get-pip.py

:PIP_CANCEL
echo Please install pip and try again.
pause
exit /b 1

:PIP_SKIP

REM Upgrading pip setuptools and wheel
echo Updating pip setuptools and wheel
python -m pip install --upgrade pip setuptools wheel


REM Check if pip is installed
set /p="Checking for virtual environment..." <nul
python -c "import venv" >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    goto VENV_CHECKED
) else (
    goto VENV_INSTALL
)
:VENV_CHECKED
echo "Virtual environment is installed."
goto VENV_SKIP

:VENV_INSTALL
echo.
choice /C YN /M "Do you want to download and install venv?"
if errorlevel 2 goto VENV_CANCEL
if errorlevel 1 goto VENV_INSTALL_2

:VENV_INSTALL_2
REM Installinv venv
echo installing venv...
pip install virtualenv

:VENV_CANCEL
echo Please install venv and try again.
pause
exit /b 1

:VENV_SKIP


REM Create a new virtual environment
set /p="Creating virtual environment ..." <nul
python -m venv venv >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    goto VENV_CREATED
) else (
    echo Failed to create virtual environment. Please check your Python installation and try again.
    pause
    exit /b 1
)

:VENV_CREATED

REM Activate the virtual environment
set /p="Activating virtual environment ..." <nul
call venv\Scripts\activate.bat
echo OK
REM Install the required packages
echo Installing requirements ...
python -m pip install --no-cache-dir pip --upgrade
python -m pip install --no-cache-dir -r requirements.txt
python -m pip install --no-cache-dir 'git+https://github.com/facebookresearch/detectron2.git'

if %ERRORLEVEL% neq 0 (
    echo Failed to install required packages. Please check your internet connection and try again.
    pause
    exit /b 1
)