#!/bin/sh

# QA 共用工具函式庫
# 包含基本的斷言與環境檢查工具

# 斷言條件是否成立
assert_true() {
  if [ "$1" != "true" ]; then
    echo "❌ $2"
    exit 1
  fi
  echo "✅ $2"
}

# 檢查指令是否存在
require_command() {
  if ! command -v "$1" > /dev/null 2>&1; then
    echo "❌ 前置條件不滿足：未安裝 $1"
    exit 1
  fi
}
