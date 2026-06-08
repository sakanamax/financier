# Financier 開發與學習導覽 (Project Portal)

歡迎來到 Financier 個人開發宇宙！這份文件是專案的入口點，記錄了我們的開發規範、重要決策、以及整體的目錄與架構概觀。

## 🎯 核心決策：雙軌開發策略 (Dual-Track Development)

為了解決「深入學習改造」與「向上游開源專案貢獻」之間的衝突，我們確立了以下的分支管理與開發策略：

### 1. 個人學習主線（`master` 分支）
這是您的專屬遊樂場。為了讓專案更容易閱讀與測試，您可以不受官方規範約束，在此分支進行以下操作：
*   **程式碼中文化**：自由地將艱澀的邏輯註解翻譯成繁體中文，方便未來複習與開發。
*   **現代化基礎建設**：自由引入自動化測試 (Unit Test)、QA 測試框架、以及 GitHub Actions 等 CI/CD 流程。
*   **技術文件與 Runbook**：建立維護腳本與營運文件。
> ⚠️ **注意**：`master` 分支的內容絕對**不會**發送 Pull Request (PR) 給官方。

### 2. 開源貢獻分支（Feature Branches）
當您發現可以貢獻給官方倉庫的 Bug 或是通用功能時，請遵循以下步驟：
1. 先抓取官方 (`upstream`) 最乾淨最新的狀態。
2. 從官方乾淨的節點切出一條專門修復該問題的新分支（例如 `fix-issue-7`）。
3. 在該分支內，**嚴格遵守官方的開發規範**（維持全英文註解、不混入個人的 QA 架構）。
4. 完成後，僅將此分支發送 PR 給官方 `handydevcom/financier`。

### 3. 實際使用者驗證流程（Unofficial Test Builds）
本專案不是單純為了學習 Android 開發而改造。專案負責人目前實際使用 Financier，且 Google Drive / Dropbox 同步功能確實影響日常使用。因此個人 fork 的 GitHub Actions 打包流程，主要目的不是取代官方發布，而是支援以下驗證路徑：

1. 在個人分支修復 cloud sync 問題後，先由 GitHub Actions 產出 APK。
2. 專案負責人下載 APK 並在自己的裝置上驗證同步功能。
3. 若修復效果穩定，可在個人 fork 建立 GitHub Release，提供 unofficial test build 給相關 issue（例如 upstream Issue #25）中的使用者自行評估下載。
4. 對外提供 APK 時，必須明確標示該 APK 不是官方版本，並提醒使用者先備份資料；因簽章不同，可能無法直接覆蓋官方 App。
5. 驗證結果穩定後，再整理最小修復分支，送 PR 回 upstream 供官方與其他使用者受益。

---

## 🛠 常見開發指令與工作流 (Workflow)

**同步官方最新進度到本地的學習主線：**
為保持歷史乾淨，請一律使用 Rebase 來拉取更新：
```bash
git checkout master
git pull --rebase upstream master
```
*(如果發生分歧，拉取後請使用 `git push -f origin master` 強制同步到您自己的 Fork)*

---

## 📂 目錄架構概觀 (Architecture & Directory Structure)

*(未來可隨著您的開發進度，在此持續更新專案的核心目錄與設計模式)*

*   `financier.md` - 本文件，專案的知識大門。
*   *(待補)* `src/` - 原始碼主目錄。
*   *(待補)* `tests/` 或 `QA/` - 您未來建立的自動化測試與品管資料夾。

---

## 📝 待辦事項清單 (Roadmap)

> 本專案所有的待辦事項與進度追蹤，已統一交由 [`TODO.md`](./TODO.md) 控制。
