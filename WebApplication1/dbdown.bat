@echo off
cd..

echo "[STEP]: Stopping Docker containers..."
docker-compose down -v
if EXIST "Repository\data_base_log" (
    echo "[STATUS]: Removing data_base_logs directory..."
    rmdir /s /q "Repository\data_base_log"
)

if EXIST "Repository\data_log" (
    echo "[STATUS]: Removing data_log directory..."
    rmdir /s /q "Repository\data_log"
)

echo "[STATUS]: Successfully removed containers and data."