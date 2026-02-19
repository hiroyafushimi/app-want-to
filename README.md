# ActClip

スクリーンショットを共有シートから受け取り、指で範囲指定 → OCR → テキスト化。内容を自動分類し、次のアクションを提案するモバイルアプリです。

## 機能

- **範囲指定 OCR**: スクリーンショットの読み取りたい部分を指でドラッグして選択
- **自動分類**: 商品 / 文章 / その他を自動判定し、最適なアクションを提案
  - 商品 → 通販サイトで検索（Amazon / 楽天 / Yahoo）
  - 文章 → AI で要約・翻訳・質問回答
  - その他 → コピー / 共有
- **AI 連携**: ユーザー自身の OpenAI API Key で動作（アプリ側にコストなし）
- **プライバシー重視**: OCR は完全オンデバイス処理。API Key は端末内に暗号化保存

## 技術スタック

| 項目 | iOS | Android |
|------|-----|---------|
| フレームワーク | Flutter | Flutter |
| OCR | Apple Vision | Google ML Kit |
| 共有受信 | Share Extension | Intent Filter |
| Key 保存 | Keychain (flutter_secure_storage) | Keystore (flutter_secure_storage) |
| 課金 | RevenueCat | RevenueCat |

## セットアップ

```bash
flutter pub get
flutter run
```

## プライバシーポリシー

[プライバシーポリシー](./privacy_policy.md)

## サポート

[サポートページ](https://hiroyafushimi.github.io/app-want-to/support.html)

## ライセンス

All rights reserved.
