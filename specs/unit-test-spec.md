# Unit Test 規範

適用情境：任何由 AI 工具協作的軟體專案，不限語言或平台。

---

## 核心原則

**新增或修改可測試的邏輯單元時，AI 必須同步補寫對應的 unit test。**

Unit test 不是事後補的工作，而是開發流程的一部分。AI 不得在沒有對應測試的情況下聲稱功能完成。

---

## 觸發條件

以下任一情況發生時，AI 必須補寫或更新 unit test：

| 類別 | 觸發情境 |
|------|----------|
| **新增函式** | 任何新的 function、method、class 被加入 |
| **修改邏輯** | 既有函式的輸入、輸出或行為被改變 |
| **新增 API endpoint** | 新的路由或控制器被加入 |
| **資料轉換** | 任何 parser、formatter、transformer 被新增或修改 |
| **邊界條件** | 新增對 null、空值、異常輸入的處理邏輯 |
| **Bug 修正** | 修正任何 bug 時，必須補上能重現該 bug 的測試案例 |

**「這個函式很簡單」不是跳過測試的理由。**

---

## 測試結構規範

### 檔案位置與命名

測試檔案放置位置依語言慣例：

| 語言 | 位置 | 命名格式 |
|------|------|----------|
| Python | `tests/` 或與原始檔同目錄 | `test_<模組名>.py` |
| JavaScript / TypeScript | `__tests__/` 或與原始檔同目錄 | `<模組名>.test.ts` |
| Go | 與原始檔同目錄 | `<模組名>_test.go` |
| Shell | `tests/` | `test_<腳本名>.sh` |

### 測試案例命名格式

測試名稱必須清楚描述「情境」與「預期結果」，禁止使用 `test_1`、`test_case` 等無意義名稱。

**Python 範例：**

```python
def test_parse_amount_returns_float_for_valid_string():
    ...

def test_parse_amount_raises_error_for_empty_string():
    ...

def test_parse_amount_handles_negative_values():
    ...
```

**TypeScript 範例：**

```typescript
describe('parseAmount', () => {
  it('should return float for valid string', () => { ... })
  it('should throw error for empty string', () => { ... })
  it('should handle negative values', () => { ... })
})
```

### Arrange / Act / Assert 結構

每個測試案例應遵照 AAA 結構，三個區塊之間空一行：

```python
def test_calculate_total_applies_discount():
    # Arrange
    items = [{"price": 100}, {"price": 200}]
    discount_rate = 0.1

    # Act
    result = calculate_total(items, discount_rate)

    # Assert
    assert result == 270
```

### Mock 使用原則

| 情況 | 做法 |
|------|------|
| 外部 API 呼叫 | 允許 mock |
| 資料庫讀寫 | 允許 mock，但整合測試要用真實 DB |
| 純邏輯函式 | **禁止 mock**，直接測真實輸出 |
| 時間、亂數 | 允許 mock 以確保測試穩定性 |

禁止為了讓測試通過而 mock 掉被測試的邏輯本身。

### 測試案例覆蓋要求

每個函式至少覆蓋以下情境，不得只寫 happy path：

1. **正常輸入** — 典型使用情境，驗證輸出正確
2. **邊界值** — 空字串、零、空陣列、最大值等
3. **錯誤情境** — 無效輸入、缺少必要欄位、類型錯誤

---

## AI 行為協定

### 執行流程

完成任何觸發條件內的變動後，AI 必須依序：

1. **識別**：列出本次變動涉及哪些函式或模組
2. **對應**：找出現有測試檔中是否已有對應測試
3. **補寫**：新增或更新測試案例，覆蓋正常、邊界、錯誤三種情境
4. **執行**：跑測試套件，確認全部通過
5. **判斷**：
   - 全部通過 → 可以回報完成
   - 有失敗 → 修正問題，回到步驟 4，直到通過

### 回報格式

AI 回報任務完成時，應附上測試執行結果：

```
變動：新增 parse_amount() 函式
測試：tests/test_parser.py → 新增 3 個案例 → ✅ 全部通過
```

若測試失敗過再修正，應說明修正了什麼：

```
測試首次失敗：未處理負數輸入導致 ValueError
修正：加入負數判斷邏輯
測試重跑：✅ 全部通過
```

---

## 禁止的行為

```
# AI 在沒有補測試的情況下說「已完成」              ← 禁止
# 測試只驗證「有跑完」而不斷言輸出值               ← 禁止
# 測試名稱使用 test_1、test_case、test_func        ← 禁止
# 為了讓測試通過而 mock 掉被測試的邏輯本身         ← 禁止
# 只寫 happy path，不覆蓋邊界與錯誤情境            ← 禁止
# AI 聲稱「邏輯簡單不需要測試」                    ← 禁止
# 修正 bug 後沒有補上能重現該 bug 的測試案例        ← 禁止
```

---

## 套用流程

**在新專案導入：**

1. 將此檔案複製至專案 `specs/` 目錄
2. 依語言建立對應的測試目錄（`tests/`、`__tests__/` 等）
3. 在 `CLAUDE.md`（或對應 AI 工具的設定檔）加入：

```
請遵照 unit-test-spec.md 的規範撰寫與執行 unit test。
```

**與 AI 工具協作時告知：**

> 「請遵照 `unit-test-spec.md` 的規範，每次新增或修改函式後，同步補寫對應的 unit test 並執行通過，才回報完成。」

---

## 使用方式

| 工具 | 整合方式 |
|------|----------|
| Claude Code | 在 `CLAUDE.md` 加入 `參考 unit-test-spec.md 的測試規範` |
| Cursor | 在 `.cursorrules` 加入相同指示 |
| 其他工具 | 對話開頭直接引用本檔案內容 |
