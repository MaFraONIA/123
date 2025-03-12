@echo off
echo === VERIFICATION DES PREREQUIS ===
echo.

REM Vérifier si Docker est installé
echo Docker: 
where docker >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    docker --version
) else (
    echo Non installe
    echo Veuillez installer Docker: https://docs.docker.com/get-docker/
)

REM Vérifier si Docker Compose est installé
echo Docker Compose: 
where docker-compose >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    docker-compose --version
) else (
    echo Non installe
    echo Veuillez installer Docker Compose: https://docs.docker.com/compose/install/
)

REM Vérifier si Docker est en cours d'exécution
echo Docker en cours d'execution: 
docker info >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Oui
) else (
    echo Non
    echo Veuillez demarrer Docker
)

echo.
echo === RECOMMANDATIONS ===
echo 1. Assurez-vous que Docker dispose d'au moins 4 Go de memoire
echo 2. Assurez-vous que Docker dispose d'au moins 2 CPUs
echo 3. Assurez-vous que Docker est en cours d'execution avant de demarrer le projet
echo.

echo Pour demarrer le projet, executez:
echo run_datalake_project.bat
