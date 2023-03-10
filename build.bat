@echo off

setlocal enabledelayedexpansion

call cls


if "%1" == "debug" (
    echo ===========BUILDING DEBUG===========
    echo.

    call odin build src\ -out:bin\Bomberman.exe -debug
) else (
    echo ===========BUILDING===========
    echo.

    call odin build src\ -out:bin\Bomberman.exe -o:speed

    if %ERRORLEVEL% EQU 0 (
        echo.

        echo ===========RUNNING===========
        echo.

        call .\bin\Bomberman.exe

        echo.
    ) else (
        echo.
        echo ===========BUILD FAILED===========
    )
)