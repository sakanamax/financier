# Runbook

本文件記錄專案中可重複執行的操作步驟與部署流程，確保任何人（或未來的自己）都能重現相同環境。

## 1. 環境準備
注意：本專案採雲端打包策略，本機不要求安裝 Android Studio 或 Android SDK。GitHub Actions 會在 Ubuntu runner 上準備 JDK 17 並執行 Gradle。

前置條件：
- GitHub fork 已設定為 `origin`。
- 目前工作分支為 `feature/github-actions` 或其他符合 workflow trigger 的 `feature/**` 分支。
- `.github/workflows/android-build.yml` 已存在。

確認分支與遠端：

```bash
git branch --show-current
git remote -v
```

預期結果：
- 分支顯示 `feature/github-actions`。
- `origin` 指向個人 fork，例如 `git@github.com:sakanamax/financier.git`。

## 2. 服務部署 / 打包 (APK)
推送分支以觸發 GitHub Actions：

```bash
git push origin feature/github-actions
```

預期結果：
- GitHub Actions 產生一筆新的 workflow run。
- Workflow 名稱為 `Android CI (Auto Build APK)`。
- `Build Debug APK` step 會執行 `./gradlew assembleDebug`。

使用 GitHub CLI 查看最近的 workflow run：

```bash
gh run list --branch feature/github-actions --limit 5
```

預期結果：
- 可以看到最新 run 的狀態。
- 成功時狀態應為 `completed` 且 conclusion 為 `success`。

下載 Actions artifact：

```bash
gh run download
```

預期結果：
- 下載到包含 debug APK 的 artifact 目錄。
- APK 來源應對應 `app/build/outputs/apk/**/*.apk`。

注意：Actions artifact 主要供自己測試。若要提供給 upstream Issue #25 的其他使用者，應建立個人 fork 的 GitHub Release，並標示為 unofficial test build。

## 3. 驗證步驟
檢查 APK 檔案是否存在：

```bash
find . -name '*.apk' -type f
```

預期結果：
- 至少列出一個 APK 檔案。
- 若 `assembleDebug` 同時打出多個 flavor，可能會看到 `untied`、`googleplay`、`fdroid` 等 debug APK。

安裝前注意事項：
- 個人 fork 產出的 APK 不是官方版本。
- 安裝前必須先從 Financier 匯出或備份資料。
- Debug APK 或個人簽章 APK 可能無法直接覆蓋官方版本。
- 若需要先卸載官方 App，必須先確認資料已備份，避免本機資料遺失。

驗證重點：
- App 可啟動。
- Google Drive / Dropbox 同步修復路徑可被測試。
- 若測試結果可用，再評估建立 GitHub Release 供 Issue #25 使用者自行下載。
