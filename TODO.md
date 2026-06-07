# Financier — 待辦事項

> 僅列未完成項目。結案時從此處刪除該行，並在對應文件標記 `[x]`。
> 最後更新：2026-06-07

---

## CI/CD 與自動化

- [ ] **設定 GitHub Actions 自動打包 APK**：設定 Android 的雲端自動編譯流程（完全不佔用本機資源）。→ [`docs/github-actions-setup.md`](./docs/github-actions-setup.md)
  - [ ] **步驟 1**：在本機撰寫 `.github/workflows/android-build.yml` 設定檔，並指定觸發條件（例如每次 Push 時啟動雲端任務）
  - [ ] **步驟 2**：在設定檔中，指定 GitHub 雲端伺服器採用 Ubuntu 虛擬機，並請它預先安裝好 Java JDK 環境
  - [ ] **步驟 3**：在設定檔中，加入 Gradle 快取機制，並賦予雲端伺服器執行指令的權限
  - [ ] **步驟 4**：在設定檔中，寫入 `assembleDebug` 指令，讓雲端虛擬機自動為我們編譯 APK
  - [ ] **步驟 5**：在設定檔中，加入 `upload-artifact` 動作，要求雲端伺服器打包完畢後，把 APK 上傳回 GitHub 網頁供我們下載

## 技術債 (Tech Debt)

- [ ] **補齊雲端同步功能的 Unit Test**：針對 `GoogleDriveClient.kt` 與 `Dropbox.java` 的修復，補寫能重現 0 byte 上傳及 PKCE 驗證的測試案例（依據 unit-test-spec.md 規範）
