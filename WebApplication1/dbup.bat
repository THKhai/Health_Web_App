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
    
     REM Check Redis
     docker exec -i redis_container redis-cli ping >nul 2>&1
     if !errorlevel! neq 0 (
        echo [STATUS]: Waiting for Redis...
        set "all_ready=false"
     )
        
    REM Check Postgres
    docker exec -i Postgres_container pg_isready >nul 2>&1
    if !errorlevel! neq 0 (
        echo [STATUS]: Waiting for PostgreSQL...
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

echo [STEP]: Migrating Redis...
docker cp ".\Repository\migration_scripts\redis" redis_container:/data/
if %errorlevel% neq 0 (
    echo "[ERR]: Failed to copy migration scripts to Redis container."
    exit /b %errorlevel%
)
for %%f in (.\Repository\migration_scripts\redis\*.rdb) do (
    echo Restoring %%~nxf...
    docker exec -i redis_container sh -c "cat /data/redis/%%~nxf | redis-cli --pipe"
    if %errorlevel% neq 0 (
        echo "[ERR]: Failed to restore %%~nxf into Redis. Continuing with the next file..."
    )
)
echo "[STATUS]: Redis has been initialized successfully with data!"


echo [STEP]: Migrating MongoDB...
docker cp ".\Repository\Migration_scripts\mongoDB" Mongodb_container:/scripts/
if %errorlevel% neq 0 (
    echo "[ERR]: Failed to copy migration scripts to Redis container."
    exit /b %errorlevel%
)
for %%f in (.\Repository\Migration_scripts\mongoDB\*.js) do (
    echo Running %%~nxf...
    docker exec -i Mongodb_container /usr/bin/mongosh /scripts/%%~nxf
    if !errorlevel! neq 0 (
        echo [ERR]: Failed executing %%~nxf in MongoDB
    )
)
echo [STATUS]: MongoDB migration completed.

sleep 20
echo [STEP]: Migrating PostgreSQL...
docker cp ".\Repository\Migration_scripts\postgres" Postgres_container:/migrations/
if %errorlevel% neq 0 (
    echo "[ERR]: Failed to copy migration scripts to Redis container."
    exit /b %errorlevel%
)
for %%f in (.\Repository\Migration_scripts\postgres\*.sql) do (
    echo Executing %%~nxf...
    @echo off
    docker exec -i Postgres_container psql -U postgres -f /migrations/%%~nxf
    if !errorlevel! neq 0 (
        echo [ERR]: Failed executing %%~nxf in PostgreSQL
    )
)
echo [STATUS]: PostgreSQL migration completed.

echo [SUCCESS]: All services initialized successfully!
