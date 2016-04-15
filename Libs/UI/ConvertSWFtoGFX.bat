@echo off
REM ---------------------------------------------------
REM - Batch file to find the Scaleform GFXexporter,   -
REM - Then use it to convert any SWF files found      -
REM - in the current directory or any sub directories -
REM - GFX files will be created in the same place as  -
REM - the SWF is found.                               -
REM ---------------------------------------------------
REM 
REM Put this in your UI directory and run from there
REM whenever you want to update your scaleform files
REM
REM Simon Bursey, Crytek 2014
REM Matthijs, Crytek 2015: Update for compatibility with external textures (like main menu)

echo ============================
echo = Convert SWF files to GFX =
echo ============================
echo.

REM --- Store the root of the current drive
pushd \
set driveRoot=%cd%
popd

REM --- Find the location of the SWF converter and store it ---
set testPath=..
:START_OF_LOOP
IF EXIST %cd%\%testPath%\Tools\GFxExport\gfxexport.exe GOTO FOUND_GFXEXPORT
set testPath=%testPath%\..
pushd %testpath%
if %cd%==%driveRoot% GOTO CANT_FIND_GFXEXPORT
popd
GOTO START_OF_LOOP

:CANT_FIND_GFXEXPORT
popd
echo === Couldn't find the GFX exporter ===
echo Make sure you have this in one of your parent directories:
echo \Tools\GFxExport\gfxexport.exe
echo.
pause
GOTO:EOF

:FOUND_GFXEXPORT
echo --- GfxExport.exe found ---
echo.

REM --- Search through Sub Directories to find SWF files ---
REM --- Then try and convert them with the GFX Exporter ---

REM Note: -share_images doesn't work properly if the target texture file already exists, because the path reference saved in the GFX does not contain the /textures/ sub-folder, this is a bug somewhere in GFxExporter
REM Even though the export succeeds with this flag, at run-time the game will not be able to find the external textures because it will look in the wrong folder
REM Once GFxExporter is fixed to handle this case, we can consider re-adding this flag
set baseflags=-c -x -rescale hi

setlocal ENABLEDELAYEDEXPANSION
set logFile="%cd%\exportlog.txt"
>%logFile% echo Export log for %cd%
if not exist Textures mkdir Textures
FOR /R %%f IN (*.swf) do (
	set myfile=%%f
	set justpath=%%~dpf
	set justfilename=%%~nxf
	
	REM This is pretty much a hack, we only add the -strip_font_shapes flag if the filename doesn't contain "font" substring
	set fontfile=!justfilename:font=!
	set exportflags=!baseflags!
	if "!fontfile!"=="!justfilename!" set exportflags=!exportflags! -strip_font_shapes
	
	REM Check if the GFX file is newer than the SWF
	set targetfile=!justfilename:swf=gfx!
	set lastchanged=!justfilename!
	if exist "!targetfile!" for /f %%g in ('dir /b /o:d "!justfilename!" "!targetfile!"') do set lastchanged=%%~nxg
	if not "!lastchanged!"=="!targetfile!" (
		pushd !justpath!
		set toolpath=%cd%\%testPath%\Tools\GFxExport\gfxexport.exe
		
		REM Pass 1: make TIFF, which can later be compiled to DDS in some platform specific way
		echo Exporting !cd!\!justfilename! ...
		>>%logFile% echo *** !cd!\!justfilename! Command: !toolpath! !exportflags!
		>>%logFile% echo *** !cd!\!justfilename! TIFF pass:
		>>%logFile% 2>&1 !toolpath! -i tiff !exportflags! !justfilename!
		>>%logFile% echo Exit code !errorlevel!
		
		REM Pass 2: make DDS for PC
		>>%logFile% echo *** !cd!\!justfilename! DDS pass:
		>>%logFile% 2>&1 !toolpath! -i dds !exportflags! !justfilename!
		>>%logFile% echo Exit code !errorlevel!
		
		popd
	) else (
		REM This file is up to date, so skip it
		echo Skipping !justpath!!justfilename!, up-to-date
		>>%logFile% echo *** !justpath!!justfilename! skipped: up-to-date
	)
)
>>%logFile% echo Finished conversion

echo.
echo.
echo === Finished ===
type %logFile% | findstr /I /C:"error"
echo See full log at %logFile%
echo.

endlocal
pause