:: vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
@echo OFF
COLOR 07
SETLOCAL EnableExtensions EnableDelayedExpansion

SET TITLE=Context menu for gvim
SET REGISTRY_FILENAME=ctx_for_gvim.reg
TITLE %TITLE%

IF "%1"=="install_cd"	GOTO USE_CD
IF "%1"=="install_dp0"	GOTO USE_DP0
IF "%1"=="uninstall"	GOTO UNINSTALL
IF "%1"==""	GOTO MENU

SET VIM_ROOT_DIR=%1
GOTO INSTALL


::::::::::::::::::::::::::::::::::::::::
:MENU
::::::::::::::::::::::::::::::::::::::::
CLS
ECHO.
ECHO %TITLE%
ECHO.

<NUL SET /p= 1 - Install (use dir %CD%)
CALL:TRY_FIND_GVIM %CD%
IF %RETURN%==1 ( CALL:ECHOG FOUND ) ELSE CALL:ECHOR "NOT FOUND"

<NUL SET /p= 2 - Install (use dir %~dp0)
CALL:TRY_FIND_GVIM %~dp0
IF %RETURN%==1 ( CALL:ECHOG FOUND ) ELSE CALL:ECHOR "NOT FOUND"

ECHO 3 - Install (ask VIM dir)
ECHO 8 - Uninstall
ECHO 9 - Exit
ECHO.
IF "%ERR_MSG%"=="" ( ECHO. ) ELSE (
	CALL:ECHOR "%ERR_MSG%"
	SET ERR_MSG=""
)
ECHO.
SET /P batTask=Choose a task:
ECHO.

IF %batTask% == 1 GOTO USE_CD
IF %batTask% == 2 GOTO USE_DP0
IF %batTask% == 3 GOTO ASK_FOR_DIR
IF %batTask% == 8 GOTO UNINSTALL
IF %batTask% == 9 GOTO EXIT
GOTO MENU

:: Procedure
:: {
::::::::::::::::::::::::::::::::::::::::
:USE_CD
::::::::::::::::::::::::::::::::::::::::
SET VIM_ROOT_DIR=%CD%
GOTO INSTALL
::::::::::::::::::::::::::::::::::::::::
:USE_DP0
::::::::::::::::::::::::::::::::::::::::
SET VIM_ROOT_DIR=%~dp0
GOTO INSTALL
::::::::::::::::::::::::::::::::::::::::
:ASK_FOR_DIR
::::::::::::::::::::::::::::::::::::::::
SET /P VIM_ROOT_DIR=Input the vim dir:
GOTO INSTALL

::::::::::::::::::::::::::::::::::::::::
:INSTALL
::::::::::::::::::::::::::::::::::::::::
SETLOCAL EnableExtensions EnableDelayedExpansion

CALL:TRY_FIND_GVIM %VIM_ROOT_DIR%

IF "%RETURN%"=="0" (	
	ENDLOCAL & SET ERR_MSG=gvim.exe NOT FOUND IN %VIM_ROOT_DIR%
	GOTO MENU
)

CALL:REALPATH %VIM_ROOT_DIR%
SET USE_DIR=%RETURN%\

CALL:PREPARE

SET VIM_ROOT_DIR_ESCAPED=%USE_DIR:\=\\%
SET GVIM_BIN=%VIM_ROOT_DIR_ESCAPED%gvim.exe

:: gvim
ECHO [HKEY_CLASSES_ROOT\*\shell\gvim]>> %REGISTRY_FILENAME%
ECHO "Icon"="%GVIM_BIN%">> %REGISTRY_FILENAME%

ECHO [HKEY_CLASSES_ROOT\*\shell\gvim\command]>> %REGISTRY_FILENAME%
ECHO @="%GVIM_BIN% \"%%1\"">> %REGISTRY_FILENAME%

:: gvim --remote-tab
ECHO [HKEY_CLASSES_ROOT\*\shell\gvim --remote-tab]>> %REGISTRY_FILENAME%
ECHO "Icon"="%GVIM_BIN%">> %REGISTRY_FILENAME%

ECHO [HKEY_CLASSES_ROOT\*\shell\gvim --remote-tab\command]>> %REGISTRY_FILENAME%
ECHO @="%GVIM_BIN% --remote-tab \"%%1\"">> %REGISTRY_FILENAME%

ENDLOCAL
GOTO DONE

::::::::::::::::::::::::::::::::::::::::
:UNINSTALL
::::::::::::::::::::::::::::::::::::::::
CALL:PREPARE

ECHO [-HKEY_CLASSES_ROOT\*\shell\gvim]>> %REGISTRY_FILENAME%
ECHO [-HKEY_CLASSES_ROOT\*\shell\gvim --remote-tab]>> %REGISTRY_FILENAME%

GOTO DONE

:: }

::::::::::::::::::::::::::::::::::::::::
:PREPARE
::::::::::::::::::::::::::::::::::::::::

ECHO Windows Registry Editor Version 5.00> %REGISTRY_FILENAME%
ECHO.>>%REGISTRY_FILENAME%
GOTO :EOF
::::::::::::::::::::::::::::::::::::::::
:TRY_FIND_GVIM
::::::::::::::::::::::::::::::::::::::::
SET RETURN=0
IF EXIST "%1\gvim.exe" SET RETURN=1
GOTO :EOF

:: Helper Functions
:: {
::::::::::::::::::::::::::::::::::::::::
:ECHOR
::::::::::::::::::::::::::::::::::::::::
CALL:ECHO_C Red %1
GOTO :EOF

::::::::::::::::::::::::::::::::::::::::
:ECHOG
::::::::::::::::::::::::::::::::::::::::
CALL:ECHO_C Green %1
GOTO :EOF

::::::::::::::::::::::::::::::::::::::::
:ECHO_C
:: 参数: 颜色 输出内容
::::::::::::::::::::::::::::::::::::::::
IF EXIST "%Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe" (
%Windir%\System32\WindowsPowerShell\v1.0\Powershell.exe write-host -foregroundcolor %1 %2
) ELSE ECHO %2
GOTO :EOF
::::::::::::::::::::::::::::::::::::::::
:REALPATH
:: 参数: 路径
::::::::::::::::::::::::::::::::::::::::
PUSHD %CD%
:: 真实路径
SET RETURN=%CD%
POPD
GOTO :EOF

:: }

::::::::::::::::::::::::::::::::::::::::
:DONE
::::::::::::::::::::::::::::::::::::::::
reg import %REGISTRY_FILENAME%
DEL %REGISTRY_FILENAME%

:EXIT
COLOR
ENDLOCAL
@ECHO on
