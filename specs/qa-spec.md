# QA 規範

適用情境：任何由 AI 工具協作的軟體專案，不限語言或平台。

---

## 核心原則

**AI 工具必須在聲稱任務完成之前，自行驗證所做的變動符合預期。**

QA 不是使用者的責任。AI 做出變動後，應主動識別對應的 QA 腳本並執行。
若沒有對應的 QA 腳本，AI 必須先補寫一支，再執行驗證。

---

## 觸發條件

以下任一類別發生變動時，AI 必須執行對應的 QA：

| 類別 | 觸發情境 |
|------|----------|
| **設定異動** | 任何 `.env`、config 檔、CORS、secrets 被新增或修改 |
| **部署異動** | deploy 腳本、CI/CD pipeline、infrastructure 設定有變動 |
| **新增可執行單元** | 新增腳本、函式、API endpoint、排程任務 |
| **外部整合** | 第三方 API 位址、auth token、webhook URL 有變 |
| **安全敏感** | 權限設定、角色、加解密邏輯有任何異動 |

**沒有對應 QA 腳本不是跳過的理由，而是補寫的信號。**

---

## QA 腳本結構規範

適用語言：Python、Shell、Node.js、任何可執行腳本。

### Python 環境規範

Python QA 腳本必須使用專案內的 venv 虛擬環境執行，禁止直接使用系統 Python 或全域 `pip install`。

**建立方式：**

```bash
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
```

**執行方式：**

```bash
.venv/bin/python scripts/qa/qa_xxx.py
```

依賴套件必須記錄在 `requirements.txt`，新增套件後同步更新：

```bash
.venv/bin/pip freeze > requirements.txt
```

`.venv/` 必須加入 `.gitignore`，不得進入版本控制。

### 必要元素

**1. 檔案開頭標頭（第一行注解）**

遵照 `chinese-comment-style.md` 的風格：說明目的、原因與敏感資料風險，不逐行翻譯指令。說明這支腳本驗證什麼、需要什麼前置條件：

```python
# 驗證 CORS 白名單設定是否存在且未使用萬用字元。
# 需要：deploy/.env 存在且已設定 ALLOWED_ORIGINS。
```

```sh
#!/bin/sh
# 驗證 Cloud Scheduler 的三個排程 job 是否存在且可觸發。
# 需要：gcloud CLI 已登入、具備 Scheduler 讀取權限。
```

**2. 前置條件檢查（最優先執行）**

腳本開頭必須驗證執行環境，缺少必要條件時立即中止並說明原因，不得繼續往下執行：

```python
def require_env(name: str) -> str:
    value = os.getenv(name)
    if not value:
        raise SystemExit(f"❌ 缺少必要環境變數：{name}")
    return value
```

```sh
if ! command -v gcloud > /dev/null 2>&1; then
  echo "❌ 前置條件不滿足：gcloud CLI 未安裝"
  exit 1
fi
```

**3. 斷言函式**

每個驗證步驟應使用統一格式輸出結果，通過與失敗都要明確：

```python
def assert_true(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(f"❌ {message}")
    print(f"✅ {message}")
```

```sh
assert_true() {
  if [ "$1" != "true" ]; then
    echo "❌ $2"
    exit 1
  fi
  echo "✅ $2"
}
```

**4. Exit code 契約**

| Exit code | 意義 |
|-----------|------|
| `0` | QA 全部通過 |
| `1` | 至少一項驗證失敗 |
| 其他非零值 | 前置條件不滿足或腳本本身執行錯誤 |

禁止在 QA 失敗時以 exit 0 結束。

**5. 輸出格式**

- `✅` 前綴：單項驗證通過
- `❌` 前綴：驗證失敗，附上失敗原因
- 腳本開頭印出 `🚀 QA <描述>` 表示開始
- 全部通過時印出 `🎉 QA passed`

```
🚀 QA CORS config
✅ deploy/.env 已設定 ALLOWED_ORIGINS
✅ 未使用萬用字元 CORS
🎉 QA passed
```

```
🚀 QA CORS config
✅ deploy/.env 已設定 ALLOWED_ORIGINS
❌ 發現萬用字元：ALLOWED_ORIGINS 包含 *，拒絕通過
```

### 命名規範

QA 腳本統一放在 `scripts/qa/` 目錄，命名格式：

```
qa_<驗證對象>_<驗證面向>.<副檔名>
```

範例：
- `qa_cors_production_config.py`
- `qa_scheduler_jobs.sh`
- `qa_api_auth_endpoints.js`

共用工具函式（load_env、assert_true 等）抽出為獨立模組，禁止在每支腳本內重複定義：

```
scripts/qa/
├── common.py          ← 共用工具（Python）
├── common.sh          ← 共用工具（Shell）
├── qa_cors_...py
└── qa_scheduler_...py
```

---

## AI 行為協定

### 執行流程

每次完成屬於觸發條件的變動後，AI 必須依序：

1. **識別**：列出本次變動屬於哪個觸發類別
2. **對應**：找出 `scripts/qa/` 下對應的 QA 腳本
3. **補寫**：若沒有對應腳本，先寫再執行
4. **執行**：跑 QA 腳本，取得 exit code 與輸出
5. **判斷**：
   - exit 0 → 可以回報完成
   - 非零 → 修正問題，回到步驟 4，直到通過

### 回報格式

AI 回報任務完成時，應附上 QA 執行結果：

```
變動：修改 deploy/.env 的 ALLOWED_ORIGINS
QA：qa_cors_production_config.py → ✅ passed
```

若 QA 失敗過再修正，應說明修正了什麼：

```
QA 首次失敗：ALLOWED_ORIGINS 包含 *
修正：改為明確的 origin 清單
QA 重跑：✅ passed
```

---

## 禁止的行為

```
# AI 在沒有跑 QA 的情況下說「已完成」           ← 禁止
# AI 因為「這個改動很小」而跳過 QA              ← 禁止
# QA 腳本在失敗時以 exit 0 結束                ← 禁止
# 共用工具函式在每支腳本內重複定義              ← 禁止
# 前置條件不滿足時繼續往下執行                  ← 禁止
# AI 聲稱「應該沒問題」代替實際執行 QA          ← 禁止
```

---

## 套用流程

**在新專案導入：**

1. 將此檔案複製至專案根目錄
2. 建立 `scripts/qa/` 目錄
3. 依專案語言建立對應的 `common.py` 或 `common.sh`
4. 在 `CLAUDE.md`（或對應 AI 工具的設定檔）加入：

```
請遵照 qa-spec.md 的規範執行 QA 與撰寫 QA 腳本。
```

**與 AI 工具協作時告知：**

> 「請遵照 `qa-spec.md` 的規範，每次完成觸發條件內的變動後，自行執行對應的 QA 腳本，通過後才回報完成。」

---

## 使用方式

| 工具 | 整合方式 |
|------|----------|
| Claude Code | 在 `CLAUDE.md` 加入 `參考 qa-spec.md 的 QA 規範` |
| Cursor | 在 `.cursorrules` 加入相同指示 |
| 其他工具 | 對話開頭直接引用本檔案內容 |
