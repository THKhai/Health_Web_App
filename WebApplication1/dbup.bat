@echo off
setlocal enabledelayedexpansion

echo [STEP]: Starting Docker containers...
docker-compose up -d
if !errorlevel! neq 0 (
    echo [ERR]: Failed to start Docker containers.
    exit /b %errorlevel%
)

echo [STATUS]: Waiting for services to be ready...
set MAX_ATTEMPTS=30
set INTERVAL=10

for /L %%i in (1,1,%MAX_ATTEMPTS%) do (
    set "all_ready=true"

    REM Check Postgres
    docker exec -i Postgres_container pg_isready >nul 2>&1
    if !errorlevel! neq 0 (
        echo [STATUS]: Waiting for PostgreSQL...
        set "all_ready=false"
    )

    REM Check Redis
    docker exec -i redis_container redis-cli ping >nul 2>&1
    if !errorlevel! neq 0 (
        echo [STATUS]: Waiting for Redis...
        set "all_ready=false"
    )

    REM Check MongoDB
    docker exec -i Mongodb_container /usr/bin/mongosh --eval "db.runCommand({ping:1})" >nul 2>&1
    if !errorlevel! neq 0 (
        echo [STATUS]: Waiting for MongoDB...
        set "all_ready=false"
    )
    REM Exit if all services are ready
    if "!all_ready!"=="true" (
        echo [STATUS]: All services are ready!
        goto all_ready
    )
    echo [STATUS]: Retrying in %INTERVAL% seconds...
    timeout /t %INTERVAL% >nul
)

echo [ERR]: Timeout waiting for services.
exit /b 1

:all_ready
echo [STEP]: Migrating PostgreSQL...
docker cp ".\Repository\Migration_scripts\postgres" Postgres_container:/migrations/
for %%f in (.\Repository\Migration_scripts\postgres\*.sql) do (
    echo Executing %%~nxf...
    docker exec -i Postgres_container psql -U postgres -f /migrations/%%~nxf
    if !errorlevel! neq 0 (
        echo [ERR]: Failed executing %%~nxf in PostgreSQL
    )
)
echo [STATUS]: PostgreSQL migration completed.


echo [STEP]: Migrating Redis...
docker cp ".\Repository\Migration_scripts\redis\dump.rdb" redis_container:/data/dump.rdb
if %errorlevel% neq 0 (
    echo [ERR]: Failed to copy Redis RDB file.
    exit /b %errorlevel%
)
echo [STATUS]: Redis data file copied successfully (requires Redis to auto-load on restart).


echo [STEP]: Migrating MongoDB...
docker cp ".\Repository\Migration_scripts\mongoDB" Mongo_container:/scripts/
for %%f in (.\Repository\Migration_scripts\mongoDB\*.js) do (
    echo Running %%~nxf...
    docker exec -i Mongo_container mongosh /scripts/%%~nxf
    if !errorlevel! neq 0 (
        echo [ERR]: Failed executing %%~nxf in MongoDB
    )
)
echo [STATUS]: MongoDB migration completed.

echo [SUCCESS]: All services initialized successfully!
