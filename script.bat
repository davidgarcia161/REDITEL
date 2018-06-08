::SCRIPTS PROGRAMADOS ::

robocopy "C:\scripts\Downloaded Program Files" "C:\Windows\Downloaded Program Files"

REM ***********************************************
REM *   Script para el predeploy de los ActiveX   *
REM *   necesarios para los entornos de CIMA      *
REM *                                             *
REM *   Parámetros de entrada: No hay             *
REM *   Autor: Accenture                          *
REM *   Fecha: 3/12/2013                          *
REM *                                             *
REM ***********************************************


FOR /F "delims=" %%i IN ('cd') DO SET CurrDir=%%i

SET Prog_File_Dir="C:\Windows\Downloaded Program Files"

@echo Expanding *.cab files
rem expand %1*.cab %Prog_File_Dir%

cd %Prog_File_Dir%
@echo Registering *23021*.ddl
for  %%f  in  (*23021*.dll) do (
@echo %%f
regsvr32 %%f)

@echo Register finished

cd %CurrDir%
