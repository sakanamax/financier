# Financier — 待辦事項

> 僅列未完成項目。結案時從此處刪除該行，並在對應文件標記 `[x]`。
> 最後更新：2026-06-08

---

## CI/CD 與自動化

- [ ] **設定 GitHub Actions 自動打包 APK** `[Branch: feature/github-actions]`：建立可下載 APK 的測試發布流程，用來驗證 Google Drive / Dropbox 同步修復，並在需要時提供給 Issue #25 使用者測試。→ [`docs/github-actions-setup.md`](./docs/github-actions-setup.md)
  - [x] 將變更推送至 GitHub，並在 Actions 頁面驗證編譯成功、產出 APK 檔
  - [ ] 評估是否將驗證過的 APK 發布到個人 fork 的 GitHub Release，並清楚標示為 unofficial test build
  - [ ] （進階）評估串接 Firebase Test Lab，自動執行 Robo 測試以驗證 APK 穩定性

## 技術債 (Tech Debt)

- [ ] **補齊雲端同步功能的 Unit Test**：針對 `GoogleDriveClient.kt` 與 `Dropbox.java` 的修復，補寫能重現 0 byte 上傳及 PKCE 驗證的測試案例（依據 unit-test-spec.md 規範）
