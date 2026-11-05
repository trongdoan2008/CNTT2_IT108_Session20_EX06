# Pre-push Checklist: quét sạch API Key trước khi push lên GitHub Public

Secret đã lên Public thì coi như **đã lộ vĩnh viễn**. Hoàn thành checklist này trước mỗi lần `git push`.

## Cài đặt một lần
- [ ] Có `.gitignore` chặn `.env*`, khóa riêng, file DB/backup, log
- [ ] Bật hook tự quét trước khi push:
  ```bash
  printf '#!/usr/bin/env bash\n./scripts/scan-secrets.sh\n' > .git/hooks/pre-push && chmod +x .git/hooks/pre-push scripts/scan-secrets.sh
  ```
- [ ] Chỉ commit các file `*.example`, không commit `.env` thật

## Trước mỗi lần push
1. [ ] `./scripts/scan-secrets.sh` ra `✓ Không phát hiện secret hardcode`
2. [ ] Rà diff: `git diff origin/main...HEAD` tìm `password`, `secret`, `token`, `key`, `BEGIN PRIVATE KEY`
3. [ ] `git ls-files | grep -Ei '\.env|\.pem|\.key|\.sql|\.sqlite'` chỉ ra file `*.example`
4. [ ] Không có dữ liệu khách hàng thật trong seed/fixture/test
5. [ ] Dockerfile, CI, Postman collection, notebook không chứa secret
6. [ ] Quét lịch sử Git: `git log -p --all | grep -Ei 'api[_-]?key|secret|password|BEGIN PRIVATE KEY'` (hoặc dùng `gitleaks`/`trufflehog`)

## Nếu đã lỡ commit secret
1. **Thu hồi/đổi khóa NGAY** ở nhà cung cấp (quan trọng nhất)
2. Xóa khỏi lịch sử bằng `git filter-repo` hoặc BFG, rồi force-push
3. Kiểm tra log nhà cung cấp xem khóa có bị lạm dụng không

## Bật bảo vệ trên GitHub
- [ ] Settings → Code security: bật **Secret scanning** và **Push protection**
- [ ] Branch protection cho `main`: bắt buộc review PR và CI `secret-scan` pass
