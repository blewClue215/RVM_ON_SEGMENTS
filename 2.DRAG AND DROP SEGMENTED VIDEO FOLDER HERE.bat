@echo off
call conda activate rvm

REM Check if input folder is provided as command line argument
if "%~1" neq "" (
    set "input_folder=%~1"
) else (
    set /p input_folder="Enter the path to the input video: "
)

set /p shutdown_choice="Do you want to shutdown the computer? (y/n): "


set output_folder=%input_folder%_matted

mkdir "%output_folder%"


python inferenceCustom.py --input_folder "%input_folder%" --output_folder "%output_folder%"

if /i "%shutdown_choice%"=="y" (
    shutdown /s /t 0
) else (
    echo Shutdown aborted.
    pause
)
