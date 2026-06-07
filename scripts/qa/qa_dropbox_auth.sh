#!/bin/sh

# 驗證 Dropbox 認證機制是否正確採用 PKCE 流程，且未遺失 APP_KEY
# 原因：升級 Dropbox SDK 後必須使用 PKCE 確保安全性，舊版 Auth 將無法使用。

source "$(dirname "$0")/common.sh"

echo "🚀 QA Dropbox PKCE Auth Config"

# 1. 檢查 Dropbox.java 檔案是否存在
FILE="app/src/main/java/com/handydev/financier/export/dropbox/Dropbox.java"
if [ ! -f "$FILE" ]; then
  echo "❌ 找不到 $FILE"
  exit 1
fi

# 2. 驗證是否使用 PKCE
HAS_PKCE=$(grep -c "startOAuth2PKCE" "$FILE")
assert_true "$([ "$HAS_PKCE" -gt 0 ] && echo 'true' || echo 'false')" "Dropbox 已正確配置 startOAuth2PKCE"

# 3. 驗證 APP_KEY 是否存在且未留空
HAS_APP_KEY=$(grep -c 'APP_KEY = "[^"]' "$FILE")
assert_true "$([ "$HAS_APP_KEY" -gt 0 ] && echo 'true' || echo 'false')" "Dropbox APP_KEY 已設定且未留白"

echo "🎉 QA passed"
exit 0
