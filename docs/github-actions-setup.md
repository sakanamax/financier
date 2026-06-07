# GitHub Actions 自動打包設定

## 背景與目的
目前 `financier` 的開發者需要在本地使用 Android Studio 或 Gradle 進行 APK 打包。為了避免本地開發環境設定的麻煩，我們將導入 GitHub Actions，實現雲端自動編譯。這讓每次推送到 GitHub 時都能自動產出最新的 APK，方便隨時安裝與測試。

## 限制與前提
- 專案為 Android 應用程式，使用 Gradle 進行編譯。
- 需要確保 GitHub 提供的 Runner（虛擬機）能順利執行 `gradlew`。
- 目前目標為輸出 Debug 版本（`assembleDebug`），若未來需要輸出 Release 版，需另外考慮 Keystore 的憑證安全管理。

## 任務清單
- [ ] 建立 `.github/workflows/android-build.yml` 檔案與觸發條件（Trigger）
- [ ] 設定 Ubuntu 執行環境與 Java JDK 版本
- [ ] 設定 Gradle 快取（加速編譯）並給予 `gradlew` 執行權限
- [ ] 執行 `assembleDebug` 指令進行打包
- [ ] 使用 `upload-artifact` 將 APK 產出物上傳到 GitHub 提供下載

## 實作細節紀錄
（等待實作時填寫各步驟的詳細設定或遭遇的問題）

## 結案狀態
- 狀態：開發中
- 完成日期：尚未完成
- 結案說明：尚未結案
