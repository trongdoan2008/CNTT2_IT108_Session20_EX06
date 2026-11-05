# Báo cáo rủi ro: thiếu tệp `.gitignore` khi đẩy mã nguồn lên GitHub Public

**Phạm vi:** dự án thương mại điện tử, repo công khai cho đối tác kiểm tra · **Ngày lập:** 06/11/2026

## 1. Tóm tắt
`.gitignore` ngăn Git theo dõi các tệp không được công khai. Nếu thiếu, `git add .` sẽ đưa cả tệp nhạy cảm vào commit; trên repo Public, bất kỳ ai cũng xem và sao chép được, kể cả công cụ quét tự động. Mức rủi ro tổng thể: **RẤT CAO** (dễ xảy ra, hậu quả nặng, khó hoàn tác).

## 2. Cơ chế
1. Lập trình viên có `.env`, khóa riêng, file backup DB trong thư mục dự án.
2. Không có `.gitignore` → `git add .` đưa tất cả vào commit.
3. `git push` → tệp nằm trong **lịch sử** repo Public.
4. Xóa ở commit sau cũng vô ích: nội dung vẫn xem được qua lịch sử Git và các bản fork/clone.

## 3. Ma trận rủi ro

| Tệp có thể lộ | Hậu quả | Khả năng | Mức độ |
|---|---|---|---|
| `.env` (mật khẩu DB, JWT secret, khóa thanh toán, SMTP) | Chiếm DB, giả mạo phiên đăng nhập, lạm dụng cổng thanh toán | Cao | **Rất cao** |
| Khóa riêng `*.pem`, `*.key`, service-account | Truy cập máy chủ/cloud | Trung bình–Cao | **Rất cao** |
| Dump/backup CSDL (`*.sql`, `*.sqlite`) | Lộ dữ liệu cá nhân khách hàng, vi phạm quy định bảo vệ dữ liệu | Trung bình | **Cao** |
| `uploads/` | Lộ nội dung khách hàng tải lên | Thấp–Trung bình | Trung bình |
| Log (`*.log`) | Lộ token, email, đường dẫn nội bộ | Trung bình | Trung bình |
| `node_modules/`, `dist/` | Repo phình to, lộ phiên bản phụ thuộc để dò lỗ hổng | Cao | Thấp–Trung bình |
| `.idea/`, `.vscode/`, `.DS_Store` | Lộ đường dẫn và tên máy cá nhân | Cao | Thấp |

## 4. Hậu quả
- **Tài chính:** khóa thanh toán/cloud bị lạm dụng, chi phí khắc phục sự cố.
- **Pháp lý:** lộ dữ liệu cá nhân có thể kéo theo nghĩa vụ thông báo và trách nhiệm theo quy định hiện hành.
- **Uy tín:** đối tác thấy repo lộ bí mật sẽ giảm niềm tin vào năng lực bảo mật.
- **Vận hành:** phải đổi toàn bộ khóa, có thể ngừng hệ thống, viết lại lịch sử Git.

## 5. Biện pháp giảm thiểu trong repo này
| Biện pháp | Vị trí |
|---|---|
| `.gitignore` chặn `.env*`, khóa, DB, log; chỉ cho phép `*.example` | `.gitignore` |
| Tệp mẫu cho Dev, Test, Production không chứa giá trị thật | `.env.example`, `.env.test.example`, `.env.production.example` |
| Quét secret trước push (hook) và trên CI | `scripts/scan-secrets.sh`, `.github/workflows/secret-scan.yml` |
| Checklist pre-push, bật Push Protection của GitHub | `docs/PRE_PUSH_CHECKLIST.md` |
| 2FA bắt buộc | `docs/2FA_GUIDE.md` |

## 6. Lưu ý
- `.gitignore` chỉ có tác dụng với tệp **chưa** được Git theo dõi. Tệp đã commit phải gỡ bằng `git rm --cached <tệp>`.
- `.gitignore` không bảo vệ secret **hardcode trong mã nguồn**, nên cần thêm bước quét secret.
- Nếu nghi ngờ đã lộ: **thu hồi khóa trước**, dọn lịch sử sau.
