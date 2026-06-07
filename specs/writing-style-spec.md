# 寫作風格規範

適用情境：任何由 AI 工具協作撰寫部落格文章，需模仿作者（Max）個人筆記風格的情境。

---

## 快速使用說明

直接複製下方提示詞給 AI，即可觸發對應工作流。

### 用法一：從主題直接產出文章

適合：已完成某個工具的安裝或設定，想快速產出一篇筆記。

**提示詞範例：**

> 請遵照 `specs/writing-style-spec.md`，幫我寫一篇關於「OpenSpec 安裝小記」的部落格文章。環境：macOS 26.3 / Node.js 26.0.0。步驟包含：npm 全域安裝、openspec init、基本指令 /opsx:propose 與 /opsx:apply。輸出 HTML。

**AI 會自動：**

1. 套用標題格式（`X 小記`）
2. 加上環境資訊
3. 用繁中撰寫，指令保留英文
4. code block 套用 IDX light 色彩與 HTML 格式
5. 結尾加上鼓勵短語
6. 輸出可直接貼進 Blogger HTML 分頁的內容

---

### 用法二：從筆記或指令整理成文章

適合：有一堆散亂的指令或筆記，想整理成正式文章。

**提示詞範例：**

> 請遵照 `specs/writing-style-spec.md`，把以下筆記整理成部落格文章，輸出 HTML：
>
> ```
> - 裝了 uv（python 套件管理）
> - brew install uv
> - uv python list 看版本
> - uv init 建專案
> - uv add rich 加套件
> - 比 pip + venv 方便很多
> ```

**AI 會自動：**

1. 補上標題與背景說明
2. 整理步驟順序與說明文字
3. 套用程式碼色彩
4. 輸出 HTML

---

## 標題格式

- 固定格式：`[主題] 小記` 或 `[行動] 小記`
- 範例：`Gemini CLI 安裝小記`、`Cloud Run Job 執行小記`
- 技術工具名稱保持英文原文，不翻譯

---

## 文章結構

1. **標題**：第一行，格式為 `X 小記`，後面空一行再接下一段
2. **環境資訊**：OS 版本、工具版本
3. **背景／問題**：一兩句說明為什麼要做這件事，不寫長篇。若是安裝類文章，在此段自然帶出官網或 GitHub 連結，格式：`官網 https://...`
4. **步驟**：條列或分節，每步附上可直接執行的指令
5. **結語**：短，帶一句鼓勵自己的話（見「結尾慣用語」）
6. **Reference**（選填）：若有引用外部資料，結語後加此段，純 URL 條列，無額外說明文字

---

## 語言混用規則

- 文章主體用**繁體中文**
- 工具名稱、指令、檔案路徑、環境變數全部保留**英文原文**，不翻譯
- 說明文字用中文，技術細節用英文
- 範例：「使用 `brew install hashicorp/tap/terraform` 安裝」

---

## 語氣

- 個人學習筆記口吻，不是教學文，不說「讀者請...」
- 輕鬆、不學術
- 偶爾帶一點自嘲或幽默（例：「is not really useful :)」反諷表示很好用）
- 不使用敬語或正式用語

---

## 結尾慣用語

固定以鼓勵性短語收尾，常見變體：

- 「又前進一步」
- 「又前進一步 ~ enjoy it」
- 「感覺又向前一步」
- 「enjoy it」

---

## 版本與環境資訊

每篇必須標註，以項目符號條列，每項一行：

```html
<p style="font-size:18px;line-height:1.85">環境：<br></p>
<ul style="margin-top:4px;margin-bottom:0;padding-inline-start:24px;">
<li style="font-size:18px;line-height:1.85">macOS 26.5</li>
<li style="font-size:18px;line-height:1.85">Node.js v26.0.0</li>
<li style="font-size:18px;line-height:1.85">OpenSpec 1.3.1</li>
</ul>
```

必要項目：
- OS（例：macOS 14.3）
- 主要工具版本（例：Gemini CLI 0.36.0）

---

## 安裝類文章補充規則

如果文章主題是安裝或初始化某個工具，需包含：

- **官網／GitHub**：在背景說明段落自然帶出，格式為 `官網 https://...` 或 `GitHub https://...`
- **設定檔**：列出工具產生的設定檔路徑（例如 `.claude/settings.local.json`）
- **目錄結構**：用 `ls` 或 `tree` 指令展示建立的目錄，貼出實際輸出

範例：

```
安裝完後確認一下結構：

.claude/
├── commands/opsx/
│   ├── apply.md
│   ├── archive.md
│   ├── explore.md
│   └── propose.md
└── skills/
    ├── openspec-apply-change
    ├── openspec-archive-change
    ├── openspec-explore
    └── openspec-propose
```

目的是讓讀者知道裝完「長什麼樣子」，方便對照自己的環境是否正常。

---

## 段落文字樣式

Blogger 主題預設 font-size 為 13px，偏小。所有段落文字必須加 inline style 覆蓋，預設使用 18px：

```html
<p style="font-size:18px;line-height:1.85">文字內容</p>
```

適用元素：`<p>`、`<li>`、純文字 `<div>`。

標題也要加 inline style，避免 Blogger 主題造成標題和內文字級不協調：

```html
<h2 style="font-size:24px;line-height:1.5">文章標題</h2>
<h3 style="font-size:20px;line-height:1.6">段落標題</h3>
```

---

## 程式碼區塊

- 指令用 code block，不用引號帶過
- 不需要每行都加說明，重要的才加
- 輸出格式為 HTML，貼到 Blogger 的「HTML」分頁
- HTML 輸出存成獨立檔案 `output.html`，方便複製貼上
- 程式碼區塊內要實際套用 `<span style="color:...">`，不要只把整段包成黑色
- shell script、JSON、TOML 也要盡量依語意上色，讓預覽不會變成整片同色文字

### 色彩規則（IDX light 配色）

| 類型 | 顏色 | Hex |
|------|------|-----|
| 指令名稱（npm、node、cd） | 藍色 | `#0033b3` |
| Flags（-g、-v） | 紅色 | `#c41a16` |
| 參數／套件名稱 | 紫色 | `#7c4dff` |
| 字串、JSON path、TOML 字串值 | 紫色 | `#7c4dff` |
| 註解（# ...） | 深綠色 | `#007400` |
| 一般文字 | 黑色 | `#000000` |

### pre 區塊樣式

```
background: #f5f7ff
padding: 12px 16px
font-family: 'Courier New', monospace
font-size: 16px
line-height: 1.75
letter-spacing: 0
border-radius: 4px
```

### 範例 HTML

```html
<pre style="background:#f5f7ff;padding:12px 16px;font-family:'Courier New',monospace;font-size:16px;line-height:1.75;letter-spacing:0;border-radius:4px"><span style="color:#007400"># 註解</span>
<span style="color:#0033b3">npm</span> install <span style="color:#c41a16">-g</span> <span style="color:#7c4dff">@package/name</span></pre>
```

---

## 使用方式

| 工具 | 整合方式 |
|------|----------|
| Claude Code | 在 `CLAUDE.md` 加入 `參考 writing-style-spec.md 的寫作風格規範` |
| Cursor | 在 `.cursorrules` 加入相同指示 |
| 其他工具 | 對話開頭直接引用本檔案內容 |
