# E-commerce Secure Repo (mẫu)

Repository mẫu cho việc chia sẻ mã nguồn dự án thương mại điện tử lên GitHub Public một cách an toàn.

## Cấu trúc

```
.
├── .gitignore                       # Chặn .env, khóa, DB, log...
├── .env.example                     # Mẫu chung
├── .env.development.example         # Dev
├── .env.test.example                 # Test / CI
├── .env.production.example           # Production (nạp từ Secret Manager)
├── .github/workflows/secret-scan.yml # CI quét secret
├── scripts/
│   ├── scan-secrets.sh              # Quét API key hardcode
│   ├── pre-push                     # Git hook
│   └── install-hooks.sh             # Cài hook
├── src/config.js                    # Nạp cấu hình từ biến môi trường
└── docs/
    ├── PRE_PUSH_CHECKLIST.md        # Checklist trước khi push
    ├── 2FA_GUIDE.md                 # Hướng dẫn bật 2FA bắt buộc
    └── RISK_REPORT_MISSING_GITIGNORE.md  # Báo cáo rủi ro
```

## Bắt đầu nhanh

```bash
git clone <repo-url> && cd <repo>
./scripts/install-hooks.sh        # bật pre-push hook
cp .env.example .env              # điền giá trị riêng, KHÔNG commit
./scripts/scan-secrets.sh         # quét thử
```

## Quy tắc vàng

1. Không bao giờ commit `.env` thật hoặc khóa riêng.
2. Chạy `scripts/scan-secrets.sh` trước mỗi lần push (hook làm tự động).
3. Bật 2FA cho mọi tài khoản (xem `docs/2FA_GUIDE.md`).
4. Lỡ lộ secret → **thu hồi khóa trước**, dọn lịch sử sau.
