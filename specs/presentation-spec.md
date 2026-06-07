# 簡報製作規範

適用情境：任何由 AI 工具協作製作的專案簡報、週報、成果報告與技術說明文件。

---

## 快速使用說明

這份規範有兩種主要用法。直接複製下方提示詞給 AI，即可觸發對應工作流。

### 用法一：從程式碼目錄一鍵生成雙產出

適合：已有現成工具或程式，想快速產出「一頁傳單 + 說明簡報」給其他人看。

**提示詞範例：**

> 請遵照 `specs/presentation-spec.md`，讀取 `TWM/已歸檔/api-monitor/`，兩個都做。

**AI 會自動：**

1. 讀取目錄內的 README 與原始碼
2. 建立 `reports/presentation/YYYYMMDD/`，並複製來源到 `source/`
3. 依序產出三個檔案，完成後列出所有路徑：
   - `assets/[slug]-infographic.svg`：一頁視覺傳單（1200×800，明亮主題 + TWM 活力橘 Header，三欄功能卡片）
   - `[slug].md`：簡報內容稿（封面 / 背景 / 架構 / 功能頁 / 設定 / FAQ）
   - `[slug].html`：簡報排版稿（16:9，8–10 頁）

---

### 用法二：一般簡報製作

適合：已有現成素材（舊版 PPTX、PDF、文件），想整理成正式簡報。

**提示詞範例：**

> 請遵照 `specs/presentation-spec.md`，幫我把 `source/` 裡的資料做成 2026-05-28 的週報簡報，PDF-first。

**AI 會自動：**

1. 讀取 `source/` 裡的素材，確認用途
2. 整理 `[slug].md`，等你確認內容方向
3. 建立 `[slug].html` 排版稿
4. 等你說「輸出 PDF」後才產出至 `output/`，並回報路徑

---

## 核心原則

**PDF-first。Markdown / SVG 是簡報原始碼，PDF 是預設交付檔。**

預設不產出 PPTX。只有使用者明確要求「需要 PowerPoint」或「需要可編輯簡報」時，才另外產出 PPTX。

**先確認決策，再動手改檔。**

簡報工作通常包含內容方向、敘事角度、交付格式與版面取捨。若使用者正在討論方向，AI 不應急著輸出 PDF 或大幅改檔；應先收斂決策，再進入修改。

---

## 來源與輸出定位

- `source/`：使用者提供的輸入材料，例如簡報檔、PDF、截圖、舊版簡報、參考圖
- `[slug].md`：內容主稿，保存頁面順序、文字、敘事目的與圖稿引用（例如 `api-monitor.md`）
- `assets/`：圖稿與圖片來源，例如 SVG 架構圖、流程圖、截圖素材
- `[slug].html`：PDF 排版稿，只有在需要精準控制版面時建立（例如 `api-monitor.html`）
- `assets/*.svg`：可維護圖稿，例如架構圖、流程圖、對比圖
- `assets/[slug]-infographic.svg`：一頁式視覺傳單，橫版 1200×800，與簡報並列為雙產出之一（例如 `api-monitor-infographic.svg`）
- `output/*.pdf`：正式交付檔
- `output/*.pptx`：選配輸出，只有使用者要求時才產生
- `common_tools/`：跨簡報可重複使用的產出、預覽與清理工具

PPTX 不是唯一真實來源。若有既有 PPTX，應放在 `source/` 作為參考或素材來源。

核心分工：

- `source/` 是輸入，不修改
- `[slug].md` 是內容真實來源
- `assets/[slug]-infographic.svg` 是資訊圖表原稿，與 `[slug].md` 共同構成雙產出
- `assets/` 是圖稿來源
- `[slug].html` 是 PDF 排版實作
- `output/` 是交付結果
- `common_tools/` 是共用工具，不跟單一日期簡報綁死

長期留存原則：

- 必留：`source/`、`output/`
- 預設留存：`[slug].md`、`[slug].html`
- 視需要留存：`assets/`、單次任務專用 `scripts/`
- 可清理：`review/`、`assets/generated/`、`.cache/`、PDF 頁面預覽 PNG

若使用者只需要單一交付檔，工作完成後至少需保留 `source/` 與 `output/`。本專案預設同時保留 `[slug].md` 與 `[slug].html`，方便後續快速修改。一次性中間檔與預覽圖應清理。

---

## 目錄結構

所有簡報檔案集中在 `reports/presentation/<報告日期>/`。

日期使用 `YYYYMMDD`，代表實際報告日或預計交付日。

```text
reports/presentation/
  common_tools/
    render_pdf_*.py
    render_preview_pages.py
    cleanup_temp.py
  YYYYMMDD/
    [slug].md
    [slug].html
    source/
      原始簡報、PDF、圖片或參考檔
    assets/
      [slug]-infographic.svg
      *.svg
      *.png
      generated/
    output/
      YYYYMMDD_[slug].pdf
      YYYYMMDD_[slug].pptx
    review/
      審稿截圖或回饋附件
    scripts/
      單次任務專用腳本
```

### 目錄用途

- `source/`：外部提供的原始材料，不直接覆蓋
- `assets/`：人工維護的 SVG、圖片、圖表資料
- `assets/generated/`：由工具產生、可重建的中間素材
- `output/`：正式交付檔與選配輸出
- `review/`：審稿截圖、使用者標註、PDF 頁面預覽
- `scripts/`：單次任務專用腳本，不放可跨簡報重複使用的工具
- `common_tools/`：產出 PDF、抽頁面預覽、清理暫存等跨簡報共用工具

### 清理後最小目錄

若簡報已交付且使用者要求清理暫存，可縮減為：

```text
reports/presentation/
  YYYYMMDD/
    [slug].md
    [slug].html
    source/
    output/
```

清理前應先確認使用者是否仍需要後續修改能力。一般情況保留 `[slug].md` 與 `[slug].html`；若頁面引用圖片或 SVG，保留必要 `assets/`。

---

## 檔案命名

### 報告目錄

```text
reports/presentation/20260527/
```

### Slug（專案識別名）

Slug 是每份簡報的短識別名，用於主稿、排版稿與資訊圖表的檔名。日期在資料夾名，slug 不含日期。

**衍生規則：**

| 來源 | 規則 | 範例 |
|------|------|------|
| 程式碼目錄名 | 直接使用，底線改連字號，全小寫 | `api-monitor/` → `api-monitor` |
| 含底線的目錄名 | 底線替換為連字號 | `cline_cli_azure/` → `cline-cli-azure` |
| 中文報告主題 | 翻譯為英文 kebab-case | 週報 → `weekly-report` |
| 中文報告主題 | 翻譯為英文 kebab-case | 成果報告 → `progress-report` |

長度建議不超過 30 字元。Slug 一旦決定，整份簡報所有檔案一致使用。

**Slug 套用到各檔名：**

```text
[slug].md                      → api-monitor.md
[slug].html                    → api-monitor.html
assets/[slug]-infographic.svg  → assets/api-monitor-infographic.svg
output/YYYYMMDD_[slug].pdf     → output/20260528_api-monitor.pdf
```

### 輸出檔

```text
output/20260527_需求單視覺化看板.pdf
output/20260527_需求單視覺化看板.pptx
```

### 圖稿檔

```text
assets/slide2_architecture.svg
assets/slide3_process.svg
```

圖稿命名以頁碼與用途為主，不使用 `final`、`new`、`copy` 這類無法追蹤版本意義的名稱。

---

## 製作流程

### 1. Source Intake

1. 將外部提供的 PPTX、PDF、截圖放入 `source/`
2. 將討論用截圖或標註放入 `review/`
3. 將使用者提供的素材視為參考來源，不直接覆蓋或在原檔上編輯
4. 從專案 Markdown 文件整理簡報文字，不直接複製過長段落

### 2. Content Draft

1. 建立或更新 `[slug].md`
2. 每頁先確認敘事目的，再決定圖表形式
3. 文字以簡報可讀為準，不把規格書整段搬進投影片
4. 這一步只處理內容與敘事，不急著排版

### 3. Diagram Draft

1. 架構圖、流程圖、對比圖優先使用 SVG
2. 需要截圖或系統畫面時，放入 `assets/` 或 `assets/generated/`
3. 避免把大量中文交給影像生成模型直接產生
4. SVG 圖稿先供使用者審閱，確認後才進入 PDF 排版

### 4. Layout Draft

1. 若 `[slug].md` 足夠轉檔，直接由 Markdown 產 PDF
2. 若需要精準版面，建立 `[slug].html`
3. `[slug].html` 是排版層，不取代 `[slug].md` 的內容主稿角色
4. `[slug].html` 可引用 `assets/` 中的 SVG、PNG 或其他素材
5. 討論與排版調整階段，預設只更新 `[slug].html` 或 SVG，不每次輸出 PDF

### 5. Output

1. 只有在使用者要求、階段定稿、或交付前才執行共用 PDF 產出工具
2. PDF 輸出至 `output/`
3. 輸出後應抽查 PDF 頁面預覽，優先抽查剛修改過的頁面
4. 回覆使用者時提供 `output/` 中的 PDF 路徑
5. 若抽查發現文字超框、重疊、裁切或方框字，應先修正再回覆交付完成

### 6. 選配輸出 PPTX

只有使用者明確要求時才產出 PPTX。

PPTX 可採兩種策略：

- 以 PDF 定稿為基礎產出不可編輯投影片
- 以 shape / text 重建可編輯投影片

產出前需告知使用者該 PPTX 是否可編輯。

---

## 中文字型與轉檔環境

產 PDF 前必須確認中文字型可用。不得交付中文字變方框的 PDF。

建議字型順序：

1. `Noto Sans TC`
2. `Noto Sans CJK TC`
3. `Microsoft JhengHei`
4. 其他明確支援繁體中文的字型

WSL 環境可優先引用 Windows 字型：

```text
/mnt/c/Windows/Fonts/NotoSansTC-VF.ttf
/mnt/c/Windows/Fonts/msjh.ttc
```

若使用 WeasyPrint，可在 `[slug].html` 中指定：

```css
@font-face {
  font-family: "Deck TC";
  src: url("file:///mnt/c/Windows/Fonts/NotoSansTC-VF.ttf") format("truetype");
}
```

若 fontconfig 無可寫 cache 目錄，腳本應設定本地 cache，例如：

```python
os.environ.setdefault("XDG_CACHE_HOME", str(presentation_dir / ".cache"))
```

`.cache/` 是可重建資料，不應視為簡報來源。

---

## 環境與套件管理

執行產出工具（如 Playwright 或 WeasyPrint）時，**嚴禁污染系統全域 Python 環境**。

AI 應：

1. **檢查虛擬環境**：在執行 `pip install` 或執行任何需要第三方套件的腳本前，先檢查專案根目錄是否已有 `.venv` 或 `venv` 目錄。
2. **建立與啟動**：若無虛擬環境，應主動建立（`python -m venv .venv`），並在執行工具前啟動它（`source .venv/bin/activate`）。
3. **依賴管理**：若有新增套件需求，應將相依套件記錄在專案對應的 `requirements.txt` 中。
4. **安全呼叫**：在呼叫 `common_tools/` 底下的腳本時，必須確保是在虛擬環境下執行，或明確使用 `.venv/bin/python` 呼叫。

---

## PDF 產出工具鏈

優先順序：

1. Playwright / Chromium
2. WeasyPrint
3. 只更新 `[slug].html`，暫不輸出 PDF，並回報環境缺口

### Playwright / Chromium

若套件大小與環境條件可接受，建議採用 Playwright / Chromium 作為主要 PDF pipeline。

適用理由：

- `[slug].html` 由瀏覽器預覽，Chromium 輸出最接近實際畫面
- 可同時產 PDF 與頁面截圖
- 可用於抽查頁數、截圖與版面
- 對現代 HTML / CSS 支援通常優於純 Python PDF renderer

限制：

- 需要安裝 Playwright package 與 browser binary
- CI / WSL / 公司網路環境需確認下載與執行條件
- 若安裝成本過高，先使用 WeasyPrint fallback

### WeasyPrint

WeasyPrint 可作為 Python-only fallback。

注意：

- CSS Grid 等版面支援可能不如瀏覽器
- 需確認中文字型與 fontconfig cache
- 若遇到排版差異，應優先改用較穩定的 HTML/CSS 寫法，或改用 Playwright / Chromium

---

## PDF 與 PPTX 使用原則

### PDF

PDF 是正式分享與留存的主要格式。

適用情境：

- 主管報告
- 會議附件
- 跨環境傳閱
- 不希望字型或版型跑掉
- 使用者只要求「給我簡報檔」且未指定 PowerPoint

### PPTX

PPTX 是選配格式。

適用情境：

- 使用者明確要求 PPTX
- 需要沿用公司 PowerPoint 範本
- 需要提供給其他人繼續編輯

不得在未確認需求時預設產出 PPTX。

---

## SVG 圖稿規則

- SVG 中的文字要保留為文字，不轉外框
- 圖稿要能獨立打開審閱
- 重要中文不得只存在於 PNG 截圖
- 字級需考慮投影片實際顯示大小
- 箭頭方向要符合資料流或責任發起方，不只追求視覺順序
- 寫入 PDF 前需抽查頁面預覽，確認沒有裁字、重疊、方框字

---

## 資訊圖表規格

資訊圖表是獨立的單頁視覺傳單，不是簡報的縮圖。定位是讓讀者 30 秒內掌握工具或專案的核心價值。

### 畫布

- 格式：SVG，橫版 1200×800
- 主題：明亮（頁面底色 `#f8fafc`，Header 使用 TWM 活力橘漸層 `#b84500`→`#e06000`）
- 字型：`Noto Sans TC` + monospace（程式碼區塊）

### 結構（由上到下）

| 區塊 | 高度 | 背景 | 說明 |
|------|------|------|------|
| Header | ~120px | TWM 活力橘 `#b84500`→`#e06000` | 標題、副標題、技術標籤（Python / GCP 等）|
| 架構流 | ~80px | `#f1f5f9` | 資料流向或系統元件（可選）|
| 功能卡片 | ~360px | 各色淡版 | 最多三欄，各含：功能列表、應用場景、指令範例、輸出預覽 |
| 快速開始 | ~170px | `#f1f5f9` | 三步驟指令區塊 + 共用參數說明 |
| Footer | ~70px | `#e2e8f0` | 資料來源、所需權限、依賴套件 |

### 色彩規則

- 頁面底色：`#f8fafc`；架構流與快速開始：`#f1f5f9`；Footer：`#e2e8f0`
- 功能卡片以強調色區分：綠 `#10b981` / 橙 `#f59e0b` / 藍 `#3b82f6` / 紅 `#ef4444`（破壞性操作）
- 各卡片：淡色背景（如 `#f0fdf4`）+ 強調色邊框 + 更深的強調色文字（如 `#059669`）
- 程式碼指令框：白色背景 `#ffffff` + 強調色邊框；輸出預覽區使用淡色背景
- 正文：`#1e293b`；次要說明：`#64748b`；卡片標題：`#0f172a`

### 與簡報的分工

- 資訊圖表（傳單）：給不熟悉工具的人，30 秒看懂，可獨立傳閱
- 簡報（說明書）：給需要深入了解的人，逐頁說明，適合會議報告

---

## HTML 排版規則

- HTML 是 PDF 排版實作，不是內容決策的唯一來源
- 版面討論階段優先看 `[slug].html`，不每次轉 PDF
- 卡片文字需預留行高與內距，避免 PDF 轉檔後超框
- 角色情境、成果與下一步等文字密集頁，優先使用較少卡片與較大框
- 圖片與文字並排時，先確保文字框不超框，再調整圖片大小
- 每次修改某頁版面後，若使用者要求輸出 PDF，需抽查該頁預覽

### 品牌配色系統

HTML 排版採 TWM（台灣大哥大）活力橘品牌色，所有新建或更新的簡報 HTML 應依此套用。

| 元素 | 屬性 | 值 |
|------|------|-----|
| 封面頁背景 | `background` | `linear-gradient(135deg, #b84500 0%, #e06000 100%)` |
| 封面頁標題 | `color` | `#ffffff` |
| 封面頁副標題 | `color` | `#ffdab0` |
| 封面徽章邊框 | `border-color` | `rgba(255,255,255,0.45)` |
| 頁眉分隔線 | `border-bottom` | `3px solid rgba(224,96,0,0.2)` |
| 表格標題列背景 | `background` | `#fff3e8` |
| 程式碼區塊背景 | `background` | `#1e293b` |
| 程式碼區塊左邊框 | `border-left` | `3px solid rgba(224,96,0,0.4)` |
| 程式碼基礎文字色 | `color` | `#cbd5e1` |
| 程式碼淡色（dim）下限 | `color` | `#94a3b8`（WCAG AA 5.0:1，對應 `#1e293b` 底色） |
| 行內程式碼背景 | `background` | `rgba(184,69,0,0.09)` |
| 行內程式碼文字 | `color` | `#b84500` |

程式碼語法高亮（暗色底）：

| 類型 | class | 顏色 |
|------|-------|------|
| 成功 / 字串 | `.hl-green` | `#34d399` |
| 警告 / 數值 | `.hl-amber` | `#fbbf24` |
| 關鍵字 / 參數 | `.hl-blue` | `#93c5fd` |
| 錯誤 / 刪除 | `.hl-red` | `#f87171` |
| 注解 / 淡化 | `.hl-dim` | `#94a3b8` |

---

## 共用工具與暫存檔清理規則

### 共用工具

跨簡報可重用工具放在：

```text
reports/presentation/common_tools/
```

日期目錄下的 `scripts/` 只放一次性、特定簡報專用腳本。若腳本可重複用於其他日期簡報，應搬到 `common_tools/`，並以日期目錄作為參數。

建議呼叫方式：

```bash
python reports/presentation/common_tools/render_pdf_weasyprint.py reports/presentation/20260527
python reports/presentation/common_tools/render_preview_pages.py reports/presentation/20260527
python reports/presentation/common_tools/cleanup_temp.py reports/presentation/20260527
```

### 可清理項目

以下內容通常可重建，可在交付後清理：

- `review/pdf_pages/`
- `review/` 中只用於臨時檢查的截圖
- `assets/generated/` 中由腳本抽出的中間圖片；若 HTML 仍引用，應先移到 `assets/` 並更新引用
- `.cache/`
- 臨時 PNG、PDF 測試檔
- 日期目錄下不可重用的一次性 `scripts/`

### 不應清理項目

除非使用者明確要求，以下內容不應清理：

- `source/`
- `output/`
- `[slug].md`
- `[slug].html`
- HTML 仍引用的 `assets/*`
- `common_tools/`

### 清理流程

1. 先列出預計刪除的暫存路徑
2. 確認 `output/` 已有最新交付檔
3. 確認 `source/` 仍保留原始輸入
4. 若使用者仍要後續修改，保留 `[slug].md`、`[slug].html` 與必要 `assets/`
5. 執行清理
6. 回覆清理後保留的目錄結構

不得在未確認用途時刪除 `source/` 或 `output/`。

---

## AI 行為協定

### 新增簡報時

AI 應：

1. 先確認報告日期、正式交付格式與是否需要 PPTX
2. 若使用者未指定格式，採用 PDF-first
3. 先討論簡報目的、受眾、時間長度與固定頁面
4. 建立 `reports/presentation/<YYYYMMDD>/`
5. 建立必要子目錄
6. 將使用者提供的簡報檔、PDF、截圖或參考圖放入 `source/`
7. 讀取 `source/` 後，先整理 `[slug].md`
8. 等內容方向確認後，再建立圖稿或排版稿
9. 將輸出檔放入 `output/`

### 使用者提供 source 檔時

AI 應：

1. 先確認檔案用途：參考、改寫、抽圖、或作為舊版簡報來源
2. 將檔案視為輸入材料，不直接覆蓋
3. 萃取可用內容到 `[slug].md`
4. 將可重用圖片或截圖放入 `assets/` 或 `assets/generated/`
5. 若需要討論架構圖或流程圖，先產出 SVG 預覽

### 修改既有簡報時

AI 應：

1. 先確認日期目錄
2. 不直接覆蓋 `source/` 原始檔
3. 預設只更新 PDF 工作流
4. 討論與排版調整階段只更新 `[slug].md`、`[slug].html` 或 `assets/`
5. 不因每次小修改自動產 PDF
6. 使用者要求輸出、階段定稿、或交付前，才產出新檔到 `output/`
7. 產出 PDF 後，抽查剛修改過的頁面
8. 有產出檔時，回覆需列出輸出檔路徑

### 討論圖稿時

AI 應：

1. 先產出 SVG 或 HTML 預覽
2. 等使用者確認方向
3. 確認後將圖稿引用到 `[slug].md`
4. 需要精準版面時再更新 `[slug].html`
5. 不因每次圖稿微調自動輸出 PDF
6. 使用者要求或圖稿階段定稿後，再輸出 PDF
7. 不在未確認時產出 PPTX

### 從程式碼目錄生成雙產出時

**觸發條件**：使用者提供一個程式碼目錄，且要求同時產出資訊圖表與簡報，或使用「兩個都做」「一鍵觸發」「做簡報跟傳單」等表達。

AI 應：

1. 先讀 README（或同功能的說明文件），取得名稱、用途與整體架構
2. 讀關鍵原始碼（建議 3–5 個，優先讀入口腳本與核心邏輯）
3. 從讀取內容萃取：名稱、一句話目的、核心功能（≤3 項）、使用方式、安裝需求
4. 建立目錄 `reports/presentation/YYYYMMDD/`（日期為實際報告日或今日）與必要子目錄
5. 將來源目錄複製到 `source/`
6. 依序寫出以下三個檔案：
   - `[slug].md`：完整內容稿（封面、背景、架構、功能頁、設定、FAQ）
   - `assets/[slug]-infographic.svg`：橫版 1200×800，明亮主題 + TWM 活力橘 Header，三欄功能卡片
   - `[slug].html`：簡報排版稿（16:9，8–10 頁）
7. 回覆時列出所有三個檔案的完整路徑
8. 不在這個階段自動輸出 PDF，等使用者確認後再輸出

### 遇到字型或轉檔問題時

AI 應：

1. 說明是哪個格式或工具造成問題
2. 優先補中文字型或改用可控排版
3. 避免產出中文字變方框的交付檔
4. 保留可重建腳本

### 清理暫存檔時

AI 應：

1. 先確認使用者是要「保留可修改工作稿」還是「只保留 source/output」
2. 列出會刪除的暫存目錄
3. 不刪除 `source/` 與 `output/`
4. 若刪除 `[slug].md`、`[slug].html`、`assets/` 或 `scripts/`，需先明確提醒會降低後續修改能力
5. 清理後列出保留結果

---

## 禁止的行為

```text
# 未啟動虛擬環境直接在全域執行 pip install                ← 禁止
# 使用者未要求 PPTX 時自動產 PPTX                      ← 禁止
# 只留下 PDF/PPTX，沒有 [slug].md 或可維護來源             ← 禁止
# 直接覆蓋 source/ 的原始簡報                            ← 禁止
# 將正式交付檔散落在專案根目錄                           ← 禁止
# 使用 final_final_new 這類檔名                           ← 禁止
# 明知中文字轉圖失敗仍交付 PDF/PPTX                       ← 禁止
# 修改簡報後沒有告知 output 檔案位置                      ← 禁止
# 未確認用途就刪除 source/ 或 output/                     ← 禁止
# 在討論階段每次小改都自動輸出 PDF                        ← 禁止
# 使用者要求雙產出時，只產出簡報而省略資訊圖表             ← 禁止
# 從程式碼目錄生成時，略過讀取 README 直接輸出             ← 禁止
```

---

## 套用流程

**在新專案導入：**

1. 將此檔案放在專案根目錄，命名為 `presentation-spec.md`
2. 建立 `reports/presentation/`
3. 在 AI 工具設定檔加入：

```text
製作簡報時請遵照 presentation-spec.md，採用 PDF-first 工作流。
```

**與 AI 工具協作時告知：**

> 「請遵照 `presentation-spec.md`，用 `reports/presentation/<YYYYMMDD>/` 管理簡報來源、圖稿、輸出與腳本，預設只產 PDF。」
