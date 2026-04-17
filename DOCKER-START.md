# Docker & Azure Deployment Quick Start

## 🏃 Khởi động nhanh

### 1. Chạy với Docker Compose (có database)
```bash
docker-compose up -d
# Truy cập: http://localhost:3000
```

### 2. Deploy lên Azure
```bash
# Xem chi tiết: xem file DEPLOY.md
```

## 📝 Các file quan trọng
- **Dockerfile** - Đóng gói ứng dụng
- **docker-compose.yml** - Chạy với PostgreSQL
- **.env.docker** - Cấu hình Docker
- **.env.production** - Cấu hình Production
- **DEPLOY.md** - Hướng dẫn deploy Chi tiết
- **azure-pipelines.yml** - CI/CD pipeline

## 🔑 Biến môi trường
- **DATABASE_URL** - Kết nối database
- **JWT_SECRET** - Secret key cho JWT
- **PORT** - Cổng server (mặc định: 3000)
