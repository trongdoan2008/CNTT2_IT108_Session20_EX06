# Pre-push Checklist — Quét sạch API Key trước khi lên GitHub Public

> Mọi thành viên PHẢI hoàn thành checklist này trước khi `git push` lên repo công khai.
> Một khi secret đã lên Public, hãy coi như **đã lộ vĩnh viễn** (bot quét GitHub trong vài giây).

## A. Chuẩn bị (làm một lần)

- [ ] Đã có `.gitignore` chặn `.env*`, khóa riêng (`*.pem`, `*.key`), file DB/backup, log
- [ ] Đã chạy `./scripts/install-hooks.sh` để bật pre-push hook tự động
- [ ] Mọi cấu hình nhạy cảm đọc từ biến môi trường (xem `src/config.js`)
- [ ] Chỉ commit các file `*.example`, không commit `.env` thật

## B. Trước mỗi lần push

1. [ ] Chạy quét tự động: `./scripts/scan-secrets.sh` → kết quả phải là `✓ Không phát hiện secret hardcode`
2. [ ] Rà soát diff thủ công: `git diff origin/main...HEAD` — tìm: `password`, `secret`, `token`, `key`, `Bearer`, `BEGIN PRIVATE KEY`
3. [ ] Kiểm tra file đang được theo dõi: `git ls-files | grep -Ei '\.env|\.pem|\.key|\.sql|\.sqlite|backup'` → chỉ được ra file `*.example`
4. [ ] Kiểm tra dữ liệu thật: không có thông tin khách hàng, email thật, số điện thoại, đơn hàng thật trong seed/fixture/test
5. [ ] Kiểm tra cấu hình hạ tầng: Dockerfile, `docker-compose.yml`, CI, Terraform, Postman collection, notebook không chứa secret
6. [ ] Kiểm tra comment/TODO: không có “mật khẩu tạm”, URL nội bộ, IP server, tài khoản test còn hiệu lực

## C. Quét lịch sử Git (quan trọng)

Secret đã từng commit rồi xóa đi **vẫn còn trong lịch sử**.

- [ ] Quét toàn bộ lịch sử: `git log -p --all | grep -Ei 'api[_-]?key|secret|password|BEGIN PRIVATE KEY'`
- [ ] (Khuyến nghị) Dùng thêm công cụ chuyên dụng như `gitleaks detect` hoặc `trufflehog git file://.` nếu team có cài
- [ ] Nếu phát hiện secret trong lịch sử → xem mục D

## D. Nếu đã lỡ commit secret

1. **Thu hồi/đổi (rotate) khóa NGAY** ở nhà cung cấp — đây là bước quan trọng nhất, quan trọng hơn việc xóa khỏi Git
2. Xóa khỏi lịch sử bằng `git filter-repo` hoặc BFG Repo-Cleaner, rồi force-push
3. Báo cho trưởng nhóm bảo mật, ghi nhận sự cố (thời điểm, loại khóa, phạm vi ảnh hưởng)
4. Kiểm tra log nhà cung cấp xem khóa có bị lạm dụng không

## E. Bật lớp bảo vệ của GitHub

- [ ] Settings → Code security → bật **Secret scanning** và **Push protection**
- [ ] Bật **Dependabot alerts**
- [ ] Bật **Branch protection** cho `main` (bắt buộc review PR, bắt buộc CI `secret-scan` pass)

## F. Xác nhận cuối

- [ ] Người push: ………………… Ngày: …………
- [ ] Người review thứ hai: ………………… Ngày: …………
