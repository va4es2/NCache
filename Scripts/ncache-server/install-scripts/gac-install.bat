@ECHO OFF

::_________________________________________::
::_____SETTING SOME VARIABLES FOR HELP_____::
::_________________________________________::

@SET SRCINTEGRATION="..\..\Integration\build"
@SET iuPath=%WINDIR%\Microsoft.NET\Framework\v4.0.30319\
@SET InstallDir=%~1
@SET WebPath=%InstallDir%\bin\assembly\4.0\Alachisoft.NCache.Web.dll
@SET CachePath=%InstallDir%\bin\assembly\4.0\Alachisoft.NCache.Cache.dll

::_________________________________________::
::________CARRYING OUT SCRIPT WORK_________::
::_________________________________________::

REG QUERY "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" /v InstallPath >nul 2>&1

IF %ERRORLEVEL%==0 (
	ECHO VERIFYING IF SERVICE ALREADY EXISTS
	ECHO ===================================
	SC QUERY NCACHESVC > NUL
	IF ERRORLEVEL 1060 (
		ECHO SERVICE DOES NOT EXIST
		ECHO ======================
	)
	IF NOT ERRORLEVEL 1060 (
		ECHO SERVICE EXISTS, REMOVING PREVIOUS SERVICE
		ECHO =========================================
		NET STOP NCACHESVC
		SC DELETE NCACHESVC
		SC QUERY NCACHESVC > NUL
		IF NOT ERRORLEVEL 1060 (
			ECHO SERVICE REMOVED SUCCESSFULLY
			ECHO ============================
		)
	)

	REM SETLOCAL ENABLEEXTENSIONS 
	REM SETLOCAL enabledelayedexpansion

	ECHO INSTALLING ASSEMBLIES TO GAC 
	ECHO ============================
	FOR /f "delims=" %%f IN ('DIR /B /S "%InstallDir%\bin\assembly\4.0\*NCache*.dll"') DO (
		"%SETUPUTILITIESPATH%\GacInstall4.0.exe" /i "%%f"
	)
	ECHO.

	IF EXIST %SRCINTEGRATION%\ContentOptimization ( "%SETUPUTILITIESPATH%\GacInstall4.0.exe" /i "%%f" %SRCINTEGRATION%\ContentOptimization\Alachisoft.NCache.Adapters.dll)
	IF EXIST %SRCINTEGRATION%\ContentOptimization ( "%SETUPUTILITIESPATH%\GacInstall4.0.exe" /i "%%f" %SRCINTEGRATION%\ContentOptimization\Alachisoft.Common.dll)
	IF EXIST %SRCINTEGRATION%\ContentOptimization ( "%SETUPUTILITIESPATH%\GacInstall4.0.exe" /i "%%f" %SRCINTEGRATION%\ContentOptimization\Alachisoft.ContentOptimization.dll)

	REM INSTALLING PROTOBUF-NET and Log4net TO GAC
	IF EXIST "%InstallDir%\bin\assembly\4.0" ( "%SETUPUTILITIESPATH%\GacInstall4.0.exe" /i "%InstallDir%\bin\assembly\4.0\protobuf-net.dll" )
	IF EXIST "%InstallDir%\bin\assembly\4.0" ( "%SETUPUTILITIESPATH%\GacInstall4.0.exe" /i "%InstallDir%\bin\assembly\4.0\log4net.dll" )

	ECHO REGISTERING PERFMON COUNTERS
	ECHO ============================

	IF EXIST "%CachePath%" ( "%iuPath%INSTALLUTIL.EXE" /i "%CachePath%" )
	IF EXIST "%WebPath%" ( "%iuPath%INSTALLUTIL.EXE" /i "%WebPath%" )
	ECHO.
)
