# Báo cáo đánh giá rủi ro: thiếu tệp `.gitignore` khi đẩy mã nguồn lên GitHub Public

**Dự án:** Thương mại điện tử — chia sẻ mã nguồn cho đối tác kiểm tra
**Phạm vi:** Repository công khai (GitHub Public)
**Ngày lập:** 06/11/2026

## 1. Tóm tắt

`.gitignore` là lớp phòng thủ đầu tiên giúp Git **không theo dõi** các tệp không được phép công khai. Nếu thiếu, một lệnh `git add .` thông thường sẽ đưa toàn bộ tệp nhạy cảm vào commit. Trên repo Public, dữ liệu đó có thể bị bất kỳ ai xem, sao chép (fork/clone) và bị các công cụ tự động quét thu thập. Mức rủi ro tổng thể: **RẤT CAO** (khả năng xảy ra cao × hậu quả nghiêm trọng, không thể hoàn tác hoàn toàn).

## 2. Cơ chế gây rủi ro

1. Lập trình viên tạo `.env`, khóa riêng, file backup DB trong thư mục dự án.
2. Không có `.gitignore` → `git add .` đưa tất cả vào staging.
3. `git commit` + `git push` → tệp nằm trong **lịch sử** repo Public.
4. Dù xóa tệp ở commit sau, nội dung **vẫn truy cập được qua lịch sử Git** và qua các bản fork/clone đã có.

## 3. Ma trận rủi ro

| # | Tệp/dữ liệu có thể lộ | Hậu quả | Khả năng | Mức độ | Xếp hạng |
|---|---|---|---|---|---|
| R1 | `.env` (DB password, JWT secret, API key thanh toán, SMTP) | Chiếm quyền DB, giả mạo phiên đăng nhập, lạm dụng cổng thanh toán, gửi mail giả danh | Cao | Nghiêm trọng | **Rất cao** |
| R2 | Khóa riêng `*.pem`, `*.key`, SSH key, service-account JSON | Truy cập máy chủ/cloud, kiểm soát hạ tầng | Trung bình–Cao | Nghiêm trọng | **Rất cao** |
| R3 | Dump/backup CSDL (`*.sql`, `*.sqlite`, `*.dump`) | Lộ dữ liệu khách hàng (tên, địa chỉ, SĐT, email, lịch sử đơn) → vi phạm quy định bảo vệ dữ liệu cá nhân, mất uy tín | Trung bình | Nghiêm trọng | **Cao** |
| R4 | Thư mục `node_modules/`, `vendor/`, `dist/` | Repo phình to, lộ cấu trúc phụ thuộc/phiên bản để kẻ tấn công dò lỗ hổng, phá vỡ quy trình review | Cao | Thấp–Trung bình | Trung bình |
| R5 | Log (`*.log`) | Lộ token, email, đường dẫn nội bộ, stack trace chứa thông tin hệ thống | Trung bình | Trung bình | Trung bình |
| R6 | Cấu hình IDE/OS (`.idea/`, `.vscode/`, `.DS_Store`) | Lộ đường dẫn máy cá nhân, tên người dùng, cấu hình cục bộ; gây xung đột giữa các thành viên | Cao | Thấp | Thấp |
| R7 | Thư mục `uploads/` (ảnh/tài liệu người dùng) | Lộ nội dung do khách hàng tải lên | Thấp–Trung bình | Cao | Trung bình |

## 4. Hậu quả kinh doanh & pháp lý

- **Tài chính:** lạm dụng khóa cổng thanh toán, chi phí hạ tầng cloud bị đối tượng xấu sử dụng, chi phí khắc phục sự cố.
- **Pháp lý/tuân thủ:** lộ dữ liệu cá nhân khách hàng có thể phát sinh nghĩa vụ thông báo và trách nhiệm theo quy định bảo vệ dữ liệu cá nhân hiện hành.
- **Uy tín:** đối tác nhìn thấy repo lộ bí mật → giảm niềm tin vào năng lực bảo mật của team.
- **Vận hành:** buộc phải xoay (rotate) toàn bộ khóa, ngừng hệ thống tạm thời, viết lại lịch sử Git.

## 5. Vì sao không thể “xóa là xong”

- Lịch sử Git giữ mọi phiên bản của tệp đã commit.
- Fork, clone, cache và dịch vụ lưu trữ bên thứ ba có thể giữ bản sao trước khi bạn kịp xóa.
- Cách xử lý duy nhất đáng tin cậy là **thu hồi/đổi khóa**; viết lại lịch sử chỉ là bước bổ trợ.

## 6. Biện pháp giảm thiểu (đã triển khai trong repo mẫu)

| Rủi ro | Biện pháp | Vị trí |
|---|---|---|
| R1–R3 | `.gitignore` chặn `.env*`, khóa, DB/backup; chỉ cho phép `*.example` | `.gitignore` |
| R1–R2 | Tệp mẫu `.env.example` cho Dev/Test/Prod, không chứa giá trị thật | `.env*.example` |
| R1–R3 | Quét secret trước push + hook tự động + CI | `scripts/`, `.github/workflows/` |
| R1 | Cấu hình đọc từ biến môi trường, thiếu biến thì báo lỗi | `src/config.js` |
| Tất cả | Checklist pre-push, bật Push Protection của GitHub | `docs/PRE_PUSH_CHECKLIST.md` |
| Truy cập | 2FA bắt buộc cho mọi thành viên | `docs/2FA_GUIDE.md` |

## 7. Lưu ý quan trọng

`.gitignore` **chỉ có tác dụng với tệp chưa được Git theo dõi**. Nếu tệp đã được commit trước khi thêm `.gitignore`, phải gỡ khỏi chỉ mục: `git rm --cached <tệp>`. Ngoài ra `.gitignore` không bảo vệ secret **hardcode trong chính mã nguồn** — đó là lý do cần thêm bước quét secret.

## 8. Kết luận & khuyến nghị

Thiếu `.gitignore` là lỗi cấu hình nhỏ nhưng có hậu quả lớn và khó đảo ngược trên repo Public. Khuyến nghị: (1) thêm `.gitignore` ngay từ commit đầu tiên, (2) bật pre-push hook và CI quét secret, (3) bật Secret scanning + Push protection trên GitHub, (4) bắt buộc 2FA, (5) nếu nghi ngờ đã lộ, thu hồi khóa trước rồi mới dọn lịch sử.
