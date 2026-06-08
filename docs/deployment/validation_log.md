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

## 2026-06-08：GitHub Actions APK 打包首次驗證失敗

環境：GitHub Actions `ubuntu-latest` runner；本地使用 GitHub REST API 與瀏覽器觀察
目的：推送 `feature/github-actions`，確認 GitHub Actions 是否能成功執行 debug APK 打包並產出 APK artifact。
操作：
- 將本地 `feature/github-actions` rebase 到遠端同名分支後推送到 `origin`。
- 觸發 workflow：`Android CI (Auto Build APK)`。
- 透過 GitHub REST API 查詢 run `27143667309` 狀態。
- 透過瀏覽器打開 job 頁面觀察 job 與 annotations。
結果：
- push 成功，遠端分支更新到 commit `41a97df`。
- workflow run 已觸發，網址：`https://github.com/sakanamax/financier/actions/runs/27143667309`。
- job `Build APK` 失敗；成功的 steps 包含 checkout、JDK 17 setup、`chmod +x gradlew`。
- 失敗 step 為 `Build Debug APK`，`Upload Debug APK Artifact` 被 skipped，因此本次沒有 APK artifact。
問題：
- 未登入 GitHub 的瀏覽器與未授權的 GitHub REST API 只能看到 annotation，無法讀取完整 Gradle log。
- 本機 `gh auth status` 顯示 token invalid，暫時無法用 `gh run view --log` 取得詳細錯誤。
- GitHub annotation 顯示 `Build Debug APK` 以 exit code 1 結束；另有 Node.js 20 deprecation warning，但該 warning 不是目前失敗原因。
- 重新登入 `gh` 後取得完整 log，確認失敗原因是 `assembleDebug` 嘗試建置 `fdroidDebug`，但 `:app:fdroidDebugCompileClasspath` 找不到 `com.mtramin:rxfingerprint:2.2.1` 與 `com.mlsdev.rximagepicker:library:2.1.5`。
處置：
- 暫不標記 GitHub Actions 打包任務完成。
- 將 workflow 的 Gradle 指令從 `./gradlew assembleDebug` 改為 `./gradlew assembleUntiedDebug`，先產出符合自用 cloud sync 驗證目標的 APK，避免被非目標 `fdroid` flavor 阻塞。
後續：由使用者決定提交時機；提交並推送後重新觀察下一次 GitHub Actions run 是否成功產出 artifact。

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
