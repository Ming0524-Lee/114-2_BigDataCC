#!/usr/bin/env bash
set -e

mkdir -p week14_outputs

echo "=== q1 Docker version ===" | tee week14_outputs/q1_runtime_output.txt
docker version | grep -E "Version:" | tee -a week14_outputs/q1_runtime_output.txt

echo "=== docker pull ubuntu:22.04 ===" | tee -a week14_outputs/q1_runtime_output.txt
docker pull ubuntu:22.04 | tail -n 1 | tee -a week14_outputs/q1_runtime_output.txt

echo "=== docker pull python:3.11-slim ===" | tee -a week14_outputs/q1_runtime_output.txt
docker pull python:3.11-slim | tail -n 1 | tee -a week14_outputs/q1_runtime_output.txt

echo "=== docker pull nginx:alpine ===" | tee -a week14_outputs/q1_runtime_output.txt
docker pull nginx:alpine | tail -n 1 | tee -a week14_outputs/q1_runtime_output.txt

echo "=== docker images before rmi ===" | tee -a week14_outputs/q1_runtime_output.txt
docker images | tee -a week14_outputs/q1_runtime_output.txt

echo "=== docker rmi ubuntu:22.04 ===" | tee -a week14_outputs/q1_runtime_output.txt
docker rmi ubuntu:22.04 | tee -a week14_outputs/q1_runtime_output.txt || true

echo "=== docker images after rmi ===" | tee -a week14_outputs/q1_runtime_output.txt
docker images | tee -a week14_outputs/q1_runtime_output.txt

# q2 nginx container

docker rm -f my-nginx >/dev/null 2>&1 || true

echo "=== q2 run nginx ===" | tee week14_outputs/q2_runtime_output.txt
docker run -d --name my-nginx -p 8080:80 nginx:alpine | tee -a week14_outputs/q2_runtime_output.txt
sleep 2

echo "=== docker ps ===" | tee -a week14_outputs/q2_runtime_output.txt
docker ps | tee -a week14_outputs/q2_runtime_output.txt

echo "=== curl nginx ===" | tee -a week14_outputs/q2_runtime_output.txt
curl http://localhost:8080 | tee -a week14_outputs/q2_runtime_output.txt

echo "=== hostname ===" | tee -a week14_outputs/q2_runtime_output.txt
docker exec my-nginx hostname | tee -a week14_outputs/q2_runtime_output.txt

echo "=== ls /etc/nginx ===" | tee -a week14_outputs/q2_runtime_output.txt
docker exec my-nginx ls /etc/nginx | tee -a week14_outputs/q2_runtime_output.txt

echo "=== nginx.conf head ===" | tee -a week14_outputs/q2_runtime_output.txt
docker exec my-nginx sh -c "head -n 10 /etc/nginx/nginx.conf" | tee -a week14_outputs/q2_runtime_output.txt

echo "=== last 5 logs ===" | tee -a week14_outputs/q2_runtime_output.txt
docker logs my-nginx 2>&1 | tail -n 5 | tee -a week14_outputs/q2_runtime_output.txt

docker stop my-nginx | tee -a week14_outputs/q2_runtime_output.txt
docker rm my-nginx | tee -a week14_outputs/q2_runtime_output.txt

echo "=== docker ps -a ===" | tee -a week14_outputs/q2_runtime_output.txt
docker ps -a | tee -a week14_outputs/q2_runtime_output.txt

# q3 ship api

docker rm -f ship-api >/dev/null 2>&1 || true

echo "=== q3 build ship-api ===" | tee week14_outputs/q3_runtime_output.txt
docker build -t ship-api:v1 . 2>&1 | tee /tmp/ship_api_build.log
tail -n 5 /tmp/ship_api_build.log | tee -a week14_outputs/q3_runtime_output.txt

echo "=== docker images | grep ship-api ===" | tee -a week14_outputs/q3_runtime_output.txt
docker images | grep ship-api | tee -a week14_outputs/q3_runtime_output.txt

echo "=== run ship-api ===" | tee -a week14_outputs/q3_runtime_output.txt
docker run -d --name ship-api -p 8080:5000 ship-api:v1 | tee -a week14_outputs/q3_runtime_output.txt
sleep 2

echo "=== curl / ===" | tee -a week14_outputs/q3_runtime_output.txt
curl http://localhost:8080/ | tee -a week14_outputs/q3_runtime_output.txt

echo "
=== curl /ships ===" | tee -a week14_outputs/q3_runtime_output.txt
curl http://localhost:8080/ships | tee -a week14_outputs/q3_runtime_output.txt

echo "
=== curl /ships/2 ===" | tee -a week14_outputs/q3_runtime_output.txt
curl http://localhost:8080/ships/2 | tee -a week14_outputs/q3_runtime_output.txt

docker stop ship-api | tee -a week14_outputs/q3_runtime_output.txt
docker rm ship-api | tee -a week14_outputs/q3_runtime_output.txt

echo "=== docker ps -a | grep ship-api ===" | tee -a week14_outputs/q3_runtime_output.txt
docker ps -a | grep ship-api | tee -a week14_outputs/q3_runtime_output.txt || true
