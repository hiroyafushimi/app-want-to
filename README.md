# ActClip

スクショ画像を共有シート経由で受け取り、指で範囲指定 → OCR → テキスト化。内容を分類し、次のアクションを提案・実行するモバイルアプリです。AI はユーザー自身の API Key で外部処理（コストゼロ・セキュリティ最優先）。

## 概要

- **フロー**: スクショ → 共有シート → 本アプリ起動 → 指で囲む → OCR → テキスト化
- **分類**: 商品 / 文章 / その他 → アクション提案
  - 商品 → 通販サイト比較検索 URL（Amazon / Rakuten / Yahoo）
  - 文章 → ユーザー設定の AI Agent に送信（要約・質問・翻訳など）
  - その他 → コピー / OS 共有（Line / Slack / メール）
- **技術**: Flutter / オフライン OCR（Apple Vision / ML Kit）/ ユーザー API Key のみで AI 連携

## 技術スタック

| 項目     | iOS           | Android     |
|----------|---------------|-------------|
| フレームワーク | Flutter       | Flutter     |
| OCR      | Apple Vision  | Google ML Kit |
| 共有受信 | Share Extension | Intent Filter |
| Key 保存 | flutter_secure_storage | flutter_secure_storage |

詳細仕様は [SPEC_WANT_TO.md](./SPEC_WANT_TO.md) を参照してください。

## セットアップ

```bash
# 依存関係
flutter pub get

# 実行（iOS / Android は接続デバイスまたはシミュレータが必要）
flutter run
```

## 開発

- 仕様書: `SPEC_WANT_TO.md`
- Cursor ルール: `.cursor/rules/` を参照（プロジェクト規約・Dart 規約）

## GitHub セットアップ

1. GitHub で新しいリポジトリを作成（例: `act-clip`）。Initialize with README は不要。
2. リモートを追加してプッシュ:

```bash
git remote add origin https://github.com/<ユーザー名>/<リポジトリ名>.git
git branch -M main
git push -u origin main
```

SSH を使う場合:

```bash
git remote add origin git@github.com:<ユーザー名>/<リポジトリ名>.git
git push -u origin main
```

## ライセンス

（必要に応じて追記）
