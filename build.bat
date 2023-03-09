@echo off

call cls

echo ===========BUILDING===========
echo.

call odin build src\ -out:bin\Bombermen.exe -o:speed

if %ERRORLEVEL% EQU 0 (
    echo.

    echo ===========RUNNING===========
    echo.

    call .\bin\Bombermen.exe

    echo.
) else (
    echo.
    echo ===========BUILD FAILED===========
)