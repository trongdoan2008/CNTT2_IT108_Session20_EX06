#!/usr/bin/env bash
# scan-secrets.sh — quét API key / mật khẩu bị hardcode trước khi push.
# Dùng:  ./scripts/scan-secrets.sh [thư-mục]   (mặc định: thư mục gốc repo)
# Thoát với mã 1 nếu phát hiện nghi vấn -> chặn push.
set -u

ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
cd "$ROOT" || exit 2

# Mẫu nhận diện (ERE). Thêm mẫu riêng của dự án vào đây.
PATTERNS=(
  'AKIA[0-9A-Z]{16}'                                   # AWS Access Key ID
  'ghp_[A-Za-z0-9]{36}'                                # GitHub personal token
  'github_pat_[A-Za-z0-9_]{50,}'                       # GitHub fine-grained token
  'AIza[0-9A-Za-z_-]{35}'                              # Google API key
  'sk_live_[0-9A-Za-z]{16,}'                           # Stripe live secret key
  'xox[baprs]-[0-9A-Za-z-]{10,}'                       # Slack token
  '-----BEGIN (RSA |EC |OPENSSH |DSA |PGP )?PRIVATE KEY'  # Private key
  'eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}'  # JWT
  '[a-z]+://[^/[:space:]:@]+:[^/[:space:]@]+@'         # URL kèm user:pass
  "(password|passwd|pwd|secret|api[_-]?key|apikey|token|access[_-]?key)[\"']?[[:space:]]*[:=][[:space:]]*[\"'][^\"'<\$\{][^\"']{7,}[\"']"
)

# Danh sách file cần quét: file đang được Git theo dõi + file mới chưa ignore
if git rev-parse --git-dir >/dev/null 2>&1; then
  FILES=$(git ls-files --cached --others --exclude-standard)
else
  FILES=$(find . -type f -not -path './.git/*' | sed 's|^\./||')
fi

# Bỏ qua file mẫu, chính script này, tài liệu và file nhị phân
FILES=$(printf '%s\n' "$FILES" | grep -vE '(\.example$|^scripts/scan-secrets\.sh$|^docs/|\.(png|jpg|jpeg|gif|pdf|zip|ico|woff2?)$)' || true)

FOUND=0
while IFS= read -r f; do
  [ -f "$f" ] || continue
  for p in "${PATTERNS[@]}"; do
    HITS=$(grep -nIE -- "$p" "$f" 2>/dev/null || true)
    if [ -n "$HITS" ]; then
      while IFS= read -r line; do
        echo "[!] $f:${line%%:*}  khớp mẫu: ${p:0:40}"
      done <<< "$HITS"
      FOUND=1
    fi
  done
done <<< "$FILES"

# File nhạy cảm không được nằm trong repo
if git rev-parse --git-dir >/dev/null 2>&1; then
  BAD=$(git ls-files | grep -E '(^|/)\.env($|\.[^/]*$)|\.(pem|key|p12|pfx|sqlite3?|dump)$' | grep -vE '\.example$' || true)
  if [ -n "$BAD" ]; then
    echo "[!] File nhạy cảm đang được Git theo dõi:"
    printf '    %s\n' $BAD
    FOUND=1
  fi
fi

if [ "$FOUND" -eq 1 ]; then
  echo ""
  echo "✗ PHÁT HIỆN NGHI VẤN. KHÔNG PUSH. Xóa secret, chuyển sang .env, và thu hồi (rotate) khóa nếu đã commit."
  exit 1
fi
echo "✓ Không phát hiện secret hardcode."
exit 0
