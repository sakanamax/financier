# Validation Log

記錄每次部署、建置與驗證的操作結果與問題處置。

## 2026-06-08：確認 unofficial APK 驗證與發布決策

環境：本地文件整理（macOS）
目的：釐清 GitHub Actions 打包 APK 的實際用途，避免誤解為單純 Android CI 練習。
操作：
- 讀取 `TODO.md`、`financier.md` 與 `docs/github-actions-setup.md`。
- 確認專案負責人實際使用 Financier，且 Google Drive / Dropbox 同步問題需要先打包 APK 自行驗證。
- 將 Actions artifact、個人 fork GitHub Release、upstream PR 的分工寫入文件。
結果：
- `financier.md` 新增 unofficial test build 驗證流程。
- `docs/github-actions-setup.md` 補上 cloud sync 修復驗證、Issue #25 測試 APK 與風險標示決策。
- `TODO.md` 的 GitHub Actions 待辦改寫為「建立可下載 APK 的測試發布流程」。
問題：尚未實際推送 workflow，也尚未在 GitHub Actions 驗證 APK 產出。
處置：先完成決策文件化；待 workflow 推送並成功後，再補實際驗證紀錄。
後續：推送 `feature/github-actions`，確認 Actions artifact，必要時建立個人 fork 的 unofficial GitHub Release。

## 2026-06-07：專案初始化與 Git 流程重整

環境：本地開發環境 (macOS)
目的：將本地修復的程式碼 (Cloud sync bugs) 合併回主線，並建立 AI 協作規範檔案結構。
操作：
- 將原專案的 origin 更改為 upstream，並綁定使用者的 GitHub Fork 作為新的 origin。
- 完成 `fix-cloud-sync-bugs` 分支合併至 `master`。
- 根據 `todo-spec.md` 建立 `TODO.md`，並加入 GitHub Actions 待辦。
- 根據 `dev-spec.md` 建立 `validation_log.md` 與 `runbook.md`，完成規範導入。
結果：
- Git 狀態乾淨，`master` 已同步至遠端 `origin`。
- 所有規範文件目錄結構皆已就緒。
問題：無
處置：無
後續：準備開新分支進行 GitHub Actions 的 CI/CD 建置任務。
