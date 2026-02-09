#!/bin/bash
# android/ と ios/ を生成。既存の lib/ は上書きされるため、実行後に lib/main.dart を復元すること。
set -e
cd "$(dirname "$0")/.."
flutter create . --project-name want_to --org com.wantto
echo "完了: android/ と ios/ が生成されました。"
echo "lib/main.dart が上書きされている場合は、ActClipApp を起動する内容に戻してください。"
