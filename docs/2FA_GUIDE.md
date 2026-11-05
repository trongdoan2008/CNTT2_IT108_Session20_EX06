# Hướng dẫn bật 2FA bắt buộc

## Dành cho Owner (cấp Organization)
1. **Organization → Settings → Authentication security**
2. Tích **Require two-factor authentication for everyone in your organization** → **Save**
3. Thành viên chưa bật 2FA sẽ bị loại khỏi tổ chức cho đến khi bật. Hãy báo team trước.

> Repo cá nhân không có công tắc bắt buộc 2FA. Muốn ép 2FA, hãy chuyển repo sang một Organization.

## Dành cho mỗi thành viên
1. **Settings → Password and authentication → Two-factor authentication → Enable**
2. Chọn phương thức: Passkey/Security key (an toàn nhất) > ứng dụng TOTP > SMS (chỉ dự phòng)
3. Lưu **recovery codes** vào trình quản lý mật khẩu, không để trong repo hay chat
4. Đăng ký ít nhất 2 phương thức để không bị khóa tài khoản
5. Push qua **SSH key có passphrase** hoặc **fine-grained token** giới hạn quyền, hạn ngắn

## Kiểm tra định kỳ (Owner)
- [ ] Organization → People → lọc **2FA: Disabled** → phải trống
- [ ] Rà soát thành viên và cộng tác viên bên ngoài hằng quý
- [ ] Thu hồi token và SSH key không còn dùng
