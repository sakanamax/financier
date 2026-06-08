# GitHub Actions 自動打包設定

## 背景與目的
目前 `financier` 的開發者需要在本地使用 Android Studio 或 Gradle 進行 APK 打包。為了避免本地開發環境設定的麻煩，我們將導入 GitHub Actions，實現雲端自動編譯。這讓每次推送到 GitHub 時都能自動產出最新的 APK，方便隨時安裝與測試。

本任務的實際目的，是支援 Financier 使用者視角的 cloud sync 修復驗證。專案負責人目前實際使用 Financier，且 Google Drive / Dropbox 同步問題會影響日常使用；因此需要先能產出可安裝 APK，在自己的裝置上驗證修復結果。若修復對 upstream Issue #25 的其他使用者也有幫助，可在個人 fork 提供明確標示的 unofficial test build，讓願意承擔風險的使用者協助測試。

### 核心架構決策：全雲端化 Android 開發 (Zero-Local-Environment)
因 Android 開發在專案負責人的整體工作比例中極低，為避免安裝龐大的 Android Studio 佔用本機硬碟與記憶體，本專案確立「**全雲端化 Android 開發**」的核心策略：
1. **程式碼編輯**：以輕量級本機編輯器（如 VS Code）或雲端 IDE 取代 Android Studio。
2. **編譯與打包**：完全依賴 GitHub Actions 的 Ubuntu 虛擬機進行 Gradle `assembleUntiedDebug` 編譯，本機不需安裝 Android SDK。
3. **測試與驗證**：搭配 GCP Credits，自動將打包完成的 APK 介接至 **Firebase Test Lab**，利用雲端實體機/虛擬機進行自動化 Robo 測試與除錯。

## 限制與前提
- 專案為 Android 應用程式，使用 Gradle 進行編譯。
- 需要確保 GitHub 提供的 Runner（虛擬機）能順利執行 `gradlew`。
- 目前目標為輸出 `untiedDebug` 版本（`assembleUntiedDebug`），若未來需要輸出 Release 版，需另外考慮 Keystore 的憑證安全管理。
- 由個人 fork 產出的 APK 不是官方版本，不得在 issue 或文件中暗示為官方 release。
- Debug APK 或個人簽章 APK 可能無法直接覆蓋官方安裝版本；測試者可能需要先卸載官方 App，這可能影響本機資料，因此必須先備份。

## 發布與驗證決策

### Actions Artifact
GitHub Actions artifact 是第一階段產物，主要用途是專案負責人自行下載並驗證同步修復。它適合開發者測試，但不適合作為長期提供給一般使用者的下載入口，因為 artifact 入口不直覺且可能有保存期限。

### GitHub Release
若 APK 經過基本驗證後需要提供給 upstream Issue #25 的其他使用者，應改放在個人 fork 的 GitHub Release。Release 說明必須包含：

- 這是 unofficial test build，不是官方 Financier release。
- 安裝前必須先從 Financier 匯出或備份資料。
- 由於 APK 簽章可能與官方版本不同，可能無法直接覆蓋安裝。
- 若需要先卸載官方版本，使用者必須自行確認資料已備份。
- 測試目標是 Google Drive / Dropbox 同步修復，不代表其他功能已完整驗證。

### Upstream PR
對外提供測試 APK 不取代 upstream PR。測試結果穩定後，仍需從乾淨 upstream 切出最小修復分支，避免混入個人 GitHub Actions、中文文件或其他個人化基礎建設。

## 任務清單
- [x] 建立 `.github/workflows/android-build.yml` 檔案與觸發條件（Trigger）
- [x] 設定 Ubuntu 執行環境與 Java JDK 17
- [x] 設定 Gradle 快取並給予 `gradlew` 執行權限
- [x] 執行 `assembleUntiedDebug` 指令進行打包
- [x] 使用 `upload-artifact` 將 APK 產出物上傳到 GitHub 提供下載
- [ ] 將變更推送至 GitHub，並在 Actions 頁面驗證編譯成功、產出 APK 檔
- [ ] 驗證 APK 後，評估是否建立個人 fork 的 unofficial GitHub Release

## 實作細節紀錄
- 2026-06-08：確認本任務不是單純 Android CI 練習，而是為了支援 cloud sync 修復的實機驗證與 unofficial test build 發布流程。
- Actions artifact 用於自己下載測試；若要提供給 Issue #25 使用者，應建立個人 fork 的 GitHub Release，並清楚標示風險。
- 2026-06-08：首次使用 `assembleDebug` 會先建置 `fdroidDebug`，但該 flavor 解析不到 `com.mtramin:rxfingerprint:2.2.1` 與 `com.mlsdev.rximagepicker:library:2.1.5`。因目前目標是產出可自用測試 cloud sync 的 APK，先改為只建置 `untiedDebug`，避免被非目標 flavor 阻塞。
- 2026-06-08：`assembleUntiedDebug` 仍解析不到上述兩個舊依賴。確認 Verve JFrog Maven repository 仍提供 `com.mtramin:rxfingerprint:2.2.1` 與 `com.mlsdev.rximagepicker:library:2.1.5`，因此新增 `https://verve.jfrog.io/artifactory/verve-gradle-release/` 作為 legacy dependency repository。

## 結案狀態
- 狀態：開發中
- 完成日期：尚未完成
- 結案說明：尚未結案
