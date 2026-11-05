# E-commerce Secure Repo (mẫu)

Cấu trúc an toàn để đẩy mã nguồn dự án thương mại điện tử lên GitHub Public.

```
.gitignore                         chặn .env, khóa, DB, log
.env.example                       mẫu Dev
.env.test.example                  mẫu Test / CI
.env.production.example            mẫu Production (nạp từ Secret Manager)
scripts/scan-secrets.sh            quét API key hardcode
.github/workflows/secret-scan.yml  CI quét secret
docs/PRE_PUSH_CHECKLIST.md         checklist trước khi push
docs/2FA_GUIDE.md                  bật 2FA bắt buộc
docs/RISK_REPORT_MISSING_GITIGNORE.md  báo cáo rủi ro
```

## Bắt đầu nhanh
```bash
cp .env.example .env        # điền giá trị riêng, KHÔNG commit
./scripts/scan-secrets.sh   # quét trước khi push
```

Quy tắc: không commit `.env` thật hoặc khóa riêng · quét trước mỗi lần push · bật 2FA · lỡ lộ secret thì **thu hồi khóa trước**.
