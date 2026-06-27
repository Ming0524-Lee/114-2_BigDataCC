# Week14 Docker 作業

本資料夾包含：

- `q1_images.txt`：Docker 映像檔操作作答
- `q2_containers.txt`：Docker 容器操作作答
- `app.py`：Flask 船舶 API
- `requirements.txt`：Flask 套件清單
- `Dockerfile`：第 3 題自行撰寫 Dockerfile
- `q3_dockerfile.txt`：Build、API 測試與觀念題
- `q4_ai_dockerfile.txt`：AI 輔助 Dockerfile 分析

## 注意

q1、q2、q3 中的 Docker 版本號、IMAGE ID、容器 ID、build log 會依照每台電腦不同而改變。  
請在自己的 Docker Desktop 或 AWS EC2 上執行指令後，把「請替換」的地方換成自己的實際輸出。

## 第 3 題測試指令

```bash
cd week14
docker build -t ship-api:v1 .
docker run -d --name ship-api -p 8080:5000 ship-api:v1
curl http://localhost:8080/
curl http://localhost:8080/ships
curl http://localhost:8080/ships/2
docker stop ship-api
docker rm ship-api
```
