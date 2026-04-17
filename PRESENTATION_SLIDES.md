# KHUNG LÀM SLIDE THUYẾT TRÌNH (POWERPOINT / CANVA)
Gợi ý: Slide nên để hình ảnh/sơ đồ là chính, chữ rất ít để các bạn tự thuyết trình. Tổng cộng khoảng 10 slides.

## Slide 1: Trang bìa (Tiêu đề)
- Tên đồ án: Triển khai Hệ thống Quản lý Sân Cầu Lông (Courtify) mang tính khả dụng cao trên Microsoft Azure.
- Giảng viên hướng dẫn: ...
- Nhóm sinh viên thực hiện: ...

## Slide 2: Vấn đề & Giải pháp
- **Vấn đề:** Các hệ thống quản lý sân hiện nay thường chạy trên máy chủ nội bộ (on-prem), dễ sập nguồn, khó bảo trì, khả năng đối phó với lượng truy cập cao kém.
- **Giải pháp:** Đưa lên hệ sinh thái Điện toán đám mây Microsoft Azure, sử dụng kiến trúc PaaS (Web App for Containers) kết hợp Azure DB.

## Slide 3: Tổng quan công nghệ sử dụng
- **Code:** NodeJS (Backend), React/Vite (Frontend), PostgreSQL (Database).
- **Hạ tầng Cloud:** Microsoft Azure.
- **Công cụ Đám mây (Clound tools):** Docker (Containerization) + Github Actions (CI/CD pipeline).

## Slide 4: KIẾN TRÚC ĐÁM MÂY (Sơ đồ - QUAN TRỌNG NHẤT)
*Bạn lấy 1 sơ đồ minh họa vẽ bằng Drawio bỏ vào đây. Gọi tên rõ:*
- User Request -> Azure Container App (Xử lý request) -> Azure PostgreSQL (Lưu dữ liệu).

## Slide 5: Tại sao lại là Container thay vì Máy Ảo thông thường (VM)?
*(Vận dụng kiến thức Chương 4 vào slide)*
- Tiết kiệm tài nguyên: Không cần cài hệ điều hành cồng kềnh.
- Tính đồng nhất: Code chạy ở máy sinh viên thế nào thì ném lên Cloud Azure chạy đúng y như thế.
- Dễ dàng nâng cấp và co dãn (Scale).

## Slide 6: Triển khai CSDL trên Mây
- Sử dụng PaaS (Platform as a Service) của Azure cho Database (Azure Database for PostgreSQL).
- Lý do: Sinh viên/Kỹ sư không cần tự lo backup (sao lưu dữ liệu), không phải lo hệ điều hành cài DB bị virus. Mọi thứ Azure tự động cập nhật.

## Slide 7: TỰ ĐỘNG HÓA VẬN HÀNH (CI/CD) - ĐIỂM SÁNG DỰ ÁN
*Để chụp ảnh màn hình cái luồng chạy của file `.github/workflows/azure-deploy.yml` vào đây.*
- Chỉ cần sinh viên "Push code" lên Github -> Server Azure sẽ tự động lấy code mới nhất, build lại Docker và Refresh web mà không cần thao tác bằng tay nào.

## Slide 8: Bài toán kinh tế mây (Cloud Economics)
- Phân tích TCO (Total Cost of Ownership): Việc dùng PaaS và Container giúp team không tốn tiền nuôi 1 quản trị viên mạng (SysAdmin) 24/7.
- Tối ưu bằng việc dùng bản chia sẻ tài nguyên hợp lý.

## Slide 9: DEMO TRỰC TIẾP
*(Dành 2-3 phút)*
- Bật Web đã deploy bằng đường link của Azure thực tế lên, làm 1 luồng flow: Đăng nhập -> Đặt sân -> Hiện thông báo thành công cho thầy xem tốc độ phản hồi từ Cloud.

## Slide 10: Hỏi và đáp (Q&A)
- Lời cảm ơn và mời thầy cô đặt câu hỏi.
