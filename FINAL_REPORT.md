# BÁO CÁO ĐỒ ÁN MÔN HỌC: ĐIỆN TOÁN ĐÁM MÂY
**Tên dự án:** Triển khai Hệ thống Quản lý Sân Cầu Lông (Courtify) trên nền tảng Microsoft Azure
**Nhóm sinh viên thực hiện:** [Điền tên nhóm]
**Giảng viên hướng dẫn:** Lê Anh Uyên Vũ / Trần Văn Thọ

---

## LỜI NÓI ĐẦU
Trong bối cảnh chuyển đổi số, việc đưa các ứng dụng lên môi trường điện toán đám mây là xu hướng tất yếu giúp doanh nghiệp giảm chi phí vận hành hạ tầng mạng cục bộ (On-premise) và tăng khả năng mở rộng. Đồ án này tập trung nghiên cứu việc đưa ứng dụng "Quản lý sân cầu lông" đóng gói bằng Container Docker và triển khai lên hạ tầng đám mây công cộng (Public Cloud) của Microsoft Azure.

---

## CHƯƠNG 1: TỔNG QUAN DỰ ÁN 

### 1.1 Mục tiêu dự án
Dự án được xây dựng nhằm hai mục tiêu cốt lõi:
- **Về mặt nghiệp vụ:** Cung cấp trải nghiệm đặt lịch sân cầu lông trực tuyến một cách dễ dàng, giúp chủ sân quản lý lịch trống, khung giờ bận mà không cần ghi chép thủ công.
- **Về mặt kiến trúc Đám mây (Cloud Computing):** Đưa toàn bộ mã nguồn của hệ thống Backend (NodeJS) và Frontend (Vite/React) lên môi trường Microsoft Azure thay vì chạy trên Localhost. Áp dụng các kiến thức cốt lõi về **Công nghệ Container (Chương 4)**, **Dịch vụ Tính toán (Chương 5)**, và **Dịch vụ Lưu trữ Cơ sở dữ liệu (Chương 6)**.

### 1.2 Các thành phần của ứng dụng
- **Frontend:** Xây dựng bằng React/Vite.
- **Backend:** Xây dựng bằng Node.js / Express.
- **Database:** PostgreSQL và Redis (Cache).

---

## CHƯƠNG 2: KIẾN TRÚC VÀ ĐÓNG GÓI ỨNG DỤNG (CONTAINERIZATION)

### 2.1 So sánh Máy ảo (VM) và Container
Thay vì cài đặt môi trường trực tiếp trên Máy ảo thông thường (IaaS), nhóm quyết định sử dụng **Container (Docker)**.
Theo giáo trình chương 4, Container giúp ứng dụng chạy ổn định, nhanh chóng mà không cần tốn tài nguyên chạy nguyên một hệ điều hành (Hypervisor) như VMs. Điều này đảm bảo rằng code chạy ở Localhost như thế nào thì khi lên Cloud sẽ chạy y nguyên như vậy.

### 2.2 Quy trình đóng gói mã nguồn (Dockerfile)
Toàn bộ mã nguồn được chia làm 2 hình ảnh (Images):
1. **Frontend Image:** Biên dịch ra file tĩnh (Static files) và dùng NGINX để làm Web Server phục vụ.
2. **Backend Image:** Cài đặt Node.js môi trường, chạy các API của Courtify.

> **[Hành động cho sinh viên:]** Bạn hãy chụp ảnh nội dung file `docker/Dockerfile.frontend` và `docker/Dockerfile.backend` chèn vào đây.

### 2.3 Sơ đồ kiến trúc Cloud
Luồng hoạt động của hệ thống khi đưa lên Azure sẽ như sau:
`Người dùng -> Mạng Internet -> [Azure App Service / Azure Container Instances] (Chạy Frontend & Backend) -> Azure PostgreSQL`

---

## CHƯƠNG 3: TRIỂN KHAI THỰC TẾ TRÊN MICROSOFT AZURE

### 3.1 Cấu hình Dịch vụ Cơ sở dữ liệu (Database as a Service - PaaS)
Nhóm không tự cài đặt Server Database mà sử dụng dịch vụ **Azure Database for PostgreSQL**.
- **Lý do lựa chọn:** Việc dùng PaaS giúp nhóm không phải lo lắng về việc backup, cấu hình ổ cứng hay bị lỗi hệ điều hành. Azure quản lý toàn bộ.
- **Cách cấu hình:** Mở cổng (Port) 5432, điền thông tin tài khoản, mật khẩu, và chuỗi kết nối (Connection String) vào file biến môi trường của Backend.

> **[Hành động:]** Chụp màn hình trang quản lý Azure Database for PostgreSQL của nhóm chèn vào đây. 

### 3.2 Cấu hình Dịch vụ Tính toán (Azure App Service cho Container)
Nhóm sử dụng tính năng **Web App for Containers** của Azure (thuộc Dịch vụ Tính toán / PaaS).
- Tải cấu hình `docker-compose.prod.yml` từ dưới local lên Azure.
- Azure App Service sẽ tự pull các Images được khai báo, gắn kết với nhau và cấp phát một URL public cho dự án.

> **[Hành động:]** Chụp màn hình trang Azure App Service chạy dự án thành công (Trang hiển thị URL xanh lá cây của Azure).

---

## CHƯƠNG 4: TỰ ĐỘNG HÓA VÀ TINH CHỈNH CHI PHÍ (CI/CD & COST)

### 4.1. Đường ống tự động hóa triển khai (CI/CD Pipeline)
Để tiết kiệm thời gian vận hành và triển khai, nhóm đã thiết lập một luồng CI/CD thông qua **GitHub Actions** (`.github/workflows/azure-deploy.yml`).
Mỗi khi lập trình viên có tính năng mới và `push` mã nguồn lên nhánh `main`, hệ thống sẽ tự động:
1. Build lại Image Frontend & Backend.
2. Đẩy (Push) lên Docker Hub (Hoặc Azure Container Registry).
3. Ra lệnh cho Azure tự động cập nhật và khởi động lại dịch vụ với bản vá mới nhất.

> **[Hành động:]** Chụp ảnh quy trình Github Actions báo tick xanh chèn vào đây.

### 4.2 Đánh giá và Tối ưu chi phí
Dựa vào kiến thức **Chương 10: Kinh tế đám mây**, thay vì chọn các gói hiệu năng cao, nhóm đã áp dụng chiến lược giảm **Tổng chi phí sở hữu (TCO)** cho ứng dụng đang trong giai đoạn phát triển bằng cách:
- Sử dụng gói B1 (Basic) của Azure App Service với chi phí thấp (đủ để chạy Nodejs + React).
- Thay thế Redis trên bản Cloud bằng Caching trong bộ nhớ (In-memory) tam thời trên App Service để giảm triệt để chi phí thuê Redis riêng lẻ.

---

## CHƯƠNG 5: KẾT LUẬN VÀ PHÂN CÔNG CÔNG VIỆC

### 5.1 Khó khăn và Bài học rút ra
Quá trình đưa hệ thống từ máy tính lên mạng Cloud (Azure) gặp nhiều lỗi về biến môi trường và kết nối mạng (Network ACLs). Tuy nhiên, nhờ áp dụng sự phân tách bằng Container, quy trình gỡ lỗi trở nên dễ dàng và nhanh chóng. Nhóm đã thực sự hiểu được sức mạnh của **IaaS** và **PaaS** trong thực tiễn.

### 5.2 Phân công công việc (Dựa theo chuẩn đầu ra CLO3, Rubric A1.5)
- **Thành viên A:** Chịu trách nhiệm tạo tài khoản Azure, cài đặt Database, giám sát chi phí (Đánh giá hoàn thành: 100%).
- **Thành viên B:** Viết Dockerfile, cấu hình cấu trúc CI/CD tự động (Đánh giá hoàn thành: 100%).
- **Thành viên C:** Xây dựng ứng dụng Courtify, fix bug tương thích (Đánh giá hoàn thành: 100%).
- **Thành viên D, E:** Viết báo cáo đồ án, thiết kế slide thuyết trình, vẽ sơ đồ Cloud Architecture (Đánh giá: 100%).

*(Chi tiết đánh giá được thống nhất qua các buổi họp nhóm hàng tuần)*
