# Hướng dẫn bật 2FA bắt buộc cho mọi tài khoản tham gia repository

## 1. Bắt buộc ở cấp Organization (dành cho Owner)

1. Vào **Organization → Settings → Authentication security**
2. Tích **Require two-factor authentication for everyone in your organization**
3. Nhấn **Save**
4. Thành viên chưa bật 2FA sẽ **bị tự động loại khỏi tổ chức** (và mất quyền truy cập repo) cho đến khi bật. GitHub sẽ gửi email báo trước; Owner nên thông báo cho team trước khi bật.

> Lưu ý: repo cá nhân (không thuộc Organization) không có công tắc bắt buộc 2FA cho cộng tác viên. Với dự án cho đối tác xem, hãy chuyển repo sang một Organization để ép được 2FA.

## 2. Mỗi thành viên tự bật 2FA

1. Vào **Settings → Password and authentication → Two-factor authentication → Enable**
2. Chọn phương thức (xếp theo độ an toàn):
   - **Passkey / Security key (YubiKey)** — an toàn nhất, chống phishing
   - **Ứng dụng xác thực (TOTP)** — Google Authenticator, Authy, 1Password…
   - SMS — chỉ dùng dự phòng, dễ bị SIM-swap
3. **Lưu mã khôi phục (recovery codes)** ở nơi an toàn (trình quản lý mật khẩu), không lưu trong repo hay chat
4. Nên đăng ký **ít nhất 2 phương thức** để không bị khóa tài khoản khi mất thiết bị

## 3. Khi dùng Git qua dòng lệnh

Mật khẩu tài khoản không còn dùng được khi push. Dùng một trong hai:

- **SSH key** (khuyến nghị): `ssh-keygen -t ed25519 -C "email@congty.com"`, rồi thêm khóa công khai `.pub` vào GitHub (Settings → SSH and GPG keys). Đặt passphrase cho khóa.
- **Fine-grained Personal Access Token**: giới hạn đúng repo, đúng quyền, đặt hạn sử dụng ngắn. Không dán token vào mã nguồn.

## 4. Quy trình kiểm tra định kỳ (Owner)

- [ ] Organization → People → lọc **2FA: Disabled** → phải trống
- [ ] Rà soát danh sách thành viên và cộng tác viên bên ngoài hằng quý, gỡ người không còn tham gia
- [ ] Kiểm tra Audit log để phát hiện đăng nhập/thao tác bất thường
- [ ] Thu hồi PAT và SSH key không còn dùng

## 5. Checklist xác nhận của từng thành viên

- [ ] Đã bật 2FA bằng Passkey hoặc TOTP
- [ ] Đã lưu recovery codes
- [ ] Đã đăng ký phương thức dự phòng thứ hai
- [ ] Đã dùng SSH key có passphrase hoặc PAT giới hạn quyền
