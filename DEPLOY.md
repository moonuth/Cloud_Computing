# 🚀 Hướng dẫn Deploy Courtify lên Azure

## 📋 Yêu cầu
- Azure Subscription
- Azure CLI
- Docker Desktop
- Node.js 18+

## 🔧 Cách 1: Deploy với Docker Compose (Local/Dev)

```bash
# Tạo .env.docker file
cp .env.docker docker.env

# Chạy với docker-compose
docker-compose --env-file docker.env up -d

# Truy cập
# Frontend: http://localhost:3000
# API: http://localhost:3000/api

# Xem logs
docker-compose logs -f app

# Dừng
docker-compose down
```

---

## ☁️ Cách 2: Deploy lên Azure Container Instances (ACI)

### Bước 1: Tạo Azure Container Registry

```bash
# Đăng nhập Azure
az login

# Tạo resource group
az group create --name courtify-rg --location eastasia

# Tạo container registry
az acr create --resource-group courtify-rg \
  --name courtifyregistry --sku Basic
```

### Bước 2: Build và Push Image

```bash
# Login vào registry
az acr login --name courtifyregistry

# Build image
docker build -t courtifyregistry.azurecr.io/courtify:latest .

# Push lên Azure
docker push courtifyregistry.azurecr.io/courtify:latest
```

### Bước 3: Deploy lên ACI

```bash
az container create \
  --resource-group courtify-rg \
  --name courtify-app \
  --image courtifyregistry.azurecr.io/courtify:latest \
  --cpu 1 --memory 1.5 \
  --registry-login-server courtifyregistry.azurecr.io \
  --registry-username <username> \
  --registry-password <password> \
  --environment-variables \
    NODE_ENV=production \
    DATABASE_URL="postgresql://..." \
    JWT_SECRET="your-secret" \
  --ports 3000 \
  --dns-name-label courtify
```

---

## 🌐 Cách 3: Deploy lên Azure App Service (Recommended)

### Bước 1: Tạo App Service Plan và Web App

```bash
# Tạo App Service Plan
az appservice plan create \
  --name courtify-plan \
  --resource-group courtify-rg \
  --sku B1 --is-linux

# Tạo Web App cho Container
az webapp create \
  --resource-group courtify-rg \
  --plan courtify-plan \
  --name courtify-app \
  --deployment-container-image-name courtifyregistry.azurecr.io/courtify:latest
```

### Bước 2: Cấu hình Container Settings

```bash
az webapp config container set \
  --name courtify-app \
  --resource-group courtify-rg \
  --docker-custom-image-name courtifyregistry.azurecr.io/courtify:latest \
  --docker-registry-server-url https://courtifyregistry.azurecr.io \
  --docker-registry-server-user <username> \
  --docker-registry-server-password <password>
```

### Bước 3: Cấu hình Environment Variables

```bash
az webapp config appsettings set \
  --resource-group courtify-rg \
  --name courtify-app \
  --settings \
    NODE_ENV=production \
    DATABASE_URL="postgresql://..." \
    JWT_SECRET="your-secret" \
    WEBSITES_PORT=3000
```

### Bước 4: Kết nối database

```bash
# Nếu dùng Azure Database for PostgreSQL
az postgres server create \
  --resource-group courtify-rg \
  --name courtify-db \
  --location eastasia \
  --admin-user dbadmin \
  --admin-password SecurePassword123!
```

---

## 📊 Cách 4: Continuous Deployment (GitHub Actions)

Tạo file `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Azure

on:
  push:
    branches: [main, master]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build Docker image
        run: docker build -t courtify:${{ github.sha }} .
      
      - name: Push to Azure Container Registry
        run: |
          docker login -u ${{ secrets.ACR_USERNAME }} -p ${{ secrets.ACR_PASSWORD }} courtifyregistry.azurecr.io
          docker push courtifyregistry.azurecr.io/courtify:${{ github.sha }}
      
      - name: Deploy to App Service
        uses: azure/webapps-deploy@v2
        with:
          app-name: courtify-app
          publish-profile: ${{ secrets.AZURE_PUBLISH_PROFILE }}
          images: courtifyregistry.azurecr.io/courtify:${{ github.sha }}
```

---

## ✅ Kiểm tra Deployment

```bash
# Xem trạng thái App Service
az webapp show --resource-group courtify-rg --name courtify-app

# Xem logs
az webapp log tail --resource-group courtify-rg --name courtify-app

# Test API
curl https://courtify-app.azurewebsites.net/health
```

---

## 🔐 Bảo mật

1. **Thay đổi JWT_SECRET** - Dùng secret key phức tạp
2. **Sử dụng Azure Key Vault** - Lưu sensitive data
3. **Bật HTTPS** - Azure tự động hỗ trợ SSL
4. **Firewall rules** - Hạn chế IP truy cập

---

## 🆘 Troubleshooting

**Container không start:**
```bash
# Xem chi tiết logs
docker logs <container-id>
```

**Database connection failed:**
```bash
# Kiểm tra DATABASE_URL format
# Pattern: postgresql://user:password@host:5432/database
```

**Timeout:**
- Tăng CPU/Memory trong App Service Plan
- Kiểm tra Network rules

---

## 📞 Hỗ trợ

- Azure Portal: https://portal.azure.com
- Azure CLI Docs: https://learn.microsoft.com/cli/azure/
- Dockerfile Docs: https://docs.docker.com/engine/reference/builder/
