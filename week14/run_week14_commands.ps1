# 在 week14 資料夾內執行：
# powershell -ExecutionPolicy Bypass -File .un_week14_commands.ps1

New-Item -ItemType Directory -Force -Path week14_outputs | Out-Null

"=== q1 Docker version ===" | Tee-Object -FilePath week14_outputs/q1_runtime_output.txt
docker version | Select-String "Version:" | Tee-Object -FilePath week14_outputs/q1_runtime_output.txt -Append

"=== docker pull ubuntu:22.04 ===" | Tee-Object -FilePath week14_outputs/q1_runtime_output.txt -Append
docker pull ubuntu:22.04 | Select-Object -Last 1 | Tee-Object -FilePath week14_outputs/q1_runtime_output.txt -Append

"=== docker pull python:3.11-slim ===" | Tee-Object -FilePath week14_outputs/q1_runtime_output.txt -Append
docker pull python:3.11-slim | Select-Object -Last 1 | Tee-Object -FilePath week14_outputs/q1_runtime_output.txt -Append

"=== docker pull nginx:alpine ===" | Tee-Object -FilePath week14_outputs/q1_runtime_output.txt -Append
docker pull nginx:alpine | Select-Object -Last 1 | Tee-Object -FilePath week14_outputs/q1_runtime_output.txt -Append

"=== docker images before rmi ===" | Tee-Object -FilePath week14_outputs/q1_runtime_output.txt -Append
docker images | Tee-Object -FilePath week14_outputs/q1_runtime_output.txt -Append

"=== docker rmi ubuntu:22.04 ===" | Tee-Object -FilePath week14_outputs/q1_runtime_output.txt -Append
docker rmi ubuntu:22.04 | Tee-Object -FilePath week14_outputs/q1_runtime_output.txt -Append

"=== docker images after rmi ===" | Tee-Object -FilePath week14_outputs/q1_runtime_output.txt -Append
docker images | Tee-Object -FilePath week14_outputs/q1_runtime_output.txt -Append

# q2 nginx container
docker rm -f my-nginx 2>$null | Out-Null

"=== q2 run nginx ===" | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt
docker run -d --name my-nginx -p 8080:80 nginx:alpine | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append
Start-Sleep -Seconds 2

"=== docker ps ===" | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append
docker ps | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append

"=== curl nginx ===" | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append
curl.exe http://localhost:8080 | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append

"=== hostname ===" | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append
docker exec my-nginx hostname | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append

"=== ls /etc/nginx ===" | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append
docker exec my-nginx ls /etc/nginx | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append

"=== nginx.conf head ===" | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append
docker exec my-nginx sh -c "head -n 10 /etc/nginx/nginx.conf" | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append

"=== last 5 logs ===" | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append
docker logs my-nginx 2>&1 | Select-Object -Last 5 | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append

docker stop my-nginx | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append
docker rm my-nginx | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append

"=== docker ps -a ===" | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append
docker ps -a | Tee-Object -FilePath week14_outputs/q2_runtime_output.txt -Append

# q3 ship api
docker rm -f ship-api 2>$null | Out-Null

"=== q3 build ship-api ===" | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt
docker build -t ship-api:v1 . 2>&1 | Tee-Object -FilePath week14_outputs/ship_api_build_full.log
Get-Content week14_outputs/ship_api_build_full.log | Select-Object -Last 5 | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append

"=== docker images | findstr ship-api ===" | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append
docker images | findstr ship-api | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append

"=== run ship-api ===" | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append
docker run -d --name ship-api -p 8080:5000 ship-api:v1 | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append
Start-Sleep -Seconds 2

"=== curl / ===" | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append
curl.exe http://localhost:8080/ | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append

"`n=== curl /ships ===" | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append
curl.exe http://localhost:8080/ships | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append

"`n=== curl /ships/2 ===" | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append
curl.exe http://localhost:8080/ships/2 | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append

docker stop ship-api | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append
docker rm ship-api | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append

"=== docker ps -a | findstr ship-api ===" | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append
docker ps -a | findstr ship-api | Tee-Object -FilePath week14_outputs/q3_runtime_output.txt -Append
