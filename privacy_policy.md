# ActClip プライバシーポリシー

最終更新日: 2026年2月9日

## はじめに

ActClip（以下「本アプリ」）は、ユーザーのプライバシーを最優先に設計されています。本プライバシーポリシーは、本アプリがどのようにユーザーの情報を取り扱うかについて説明します。

## 収集する情報

### 本アプリが収集しない情報

- 個人を特定する情報（氏名、メールアドレス、電話番号など）
- 位置情報
- 連絡先データ
- 閲覧履歴

### デバイス上で処理される情報

以下の情報はデバイス上でのみ処理され、外部サーバーに送信されることはありません。

- **画像データ**: 共有シートまたはフォトライブラリから選択された画像は、テキスト認識（OCR）処理のためにデバイス上でのみ使用されます。画像は外部に送信されず、アプリ終了時に破棄されます。
- **OCR 結果**: テキスト認識の結果はデバイス上でのみ表示・処理されます。

### ユーザーが任意で設定する情報

- **OpenAI API Key**: ユーザーが AI 機能を利用するために任意で設定できます。API Key はデバイス内に暗号化して保存され、OpenAI へのリクエスト送信時のみ使用されます。API Key は本アプリの開発者を含む第三者に共有されることはありません。

## 外部サービスとの通信

### OpenAI API（任意）

ユーザーが API Key を設定し、AI 機能を利用する場合に限り、OCR で認識されたテキストが OpenAI のサーバーに送信されます。この通信はユーザーの明示的な操作（「AI に聞く」ボタンのタップ）によってのみ発生します。OpenAI のプライバシーポリシーについては [OpenAI Privacy Policy](https://openai.com/privacy/) をご参照ください。

### RevenueCat（課金処理）

アプリ内課金の処理に RevenueCat を使用しています。RevenueCat は購入の検証と管理のために、匿名化されたデバイス識別子と購入情報を処理します。RevenueCat のプライバシーポリシーについては [RevenueCat Privacy Policy](https://www.revenuecat.com/privacy/) をご参照ください。

### テキスト認識（OCR）

- **iOS**: Apple Vision フレームワークを使用。すべての処理はデバイス上で完結し、Apple のサーバーにデータは送信されません。
- **Android**: Google ML Kit を使用。すべての処理はデバイス上で完結し、Google のサーバーにデータは送信されません。

## データの保存

| データ | 保存場所 | 暗号化 | 削除方法 |
|--------|---------|--------|---------|
| OpenAI API Key | デバイス内（Keychain / Keystore） | あり | 設定画面から削除、またはアプリの削除 |
| 利用回数（無料プラン） | デバイス内メモリ | なし | アプリ再起動で自動リセット |
| 課金状態 | RevenueCat（匿名） | - | Apple / Google のサブスクリプション管理 |

## 写真・カメラへのアクセス

本アプリはフォトライブラリへの読み取りアクセスを要求します。これは共有シートから受け取った画像、またはアルバムから選択された画像を OCR 処理するためにのみ使用されます。画像はアプリ外に送信されません。

## 子どものプライバシー

本アプリは 13 歳未満の子どもを対象としておらず、意図的に子どもから個人情報を収集することはありません。

## プライバシーポリシーの変更

本プライバシーポリシーは予告なく変更される場合があります。変更があった場合は、本ページを更新し、最終更新日を改定します。

## お問い合わせ

本プライバシーポリシーに関するご質問がある場合は、以下までお問い合わせください。

- GitHub Issues: https://github.com/hiroyafushimi/app-want-to/issues

---

# ActClip Privacy Policy

Last updated: February 9, 2026

## Introduction

ActClip ("the App") is designed with user privacy as a top priority. This Privacy Policy explains how the App handles user information.

## Information We Do NOT Collect

- Personally identifiable information (name, email, phone number, etc.)
- Location data
- Contact data
- Browsing history

## Information Processed On-Device

The following information is processed only on your device and is never transmitted to external servers:

- **Image Data**: Images received via the share sheet or selected from the photo library are used solely for on-device text recognition (OCR). Images are not transmitted externally and are discarded when the app closes.
- **OCR Results**: Text recognition results are displayed and processed only on your device.

## Optionally Provided Information

- **OpenAI API Key**: Users may optionally set an API Key to use AI features. The API Key is stored encrypted on the device and is used only when sending requests to OpenAI. The API Key is never shared with the App developer or any third party.

## Communication with External Services

### OpenAI API (Optional)

Only when the user has set an API Key and explicitly initiates an AI action (by tapping the "Ask AI" button), recognized text is sent to OpenAI's servers. See [OpenAI Privacy Policy](https://openai.com/privacy/) for details.

### RevenueCat (In-App Purchases)

The App uses RevenueCat for in-app purchase processing. RevenueCat processes anonymized device identifiers and purchase information for purchase verification and management. See [RevenueCat Privacy Policy](https://www.revenuecat.com/privacy/) for details.

### Text Recognition (OCR)

- **iOS**: Uses Apple Vision framework. All processing is performed on-device; no data is sent to Apple's servers.
- **Android**: Uses Google ML Kit. All processing is performed on-device; no data is sent to Google's servers.

## Data Storage

| Data | Storage | Encrypted | Deletion |
|------|---------|-----------|----------|
| OpenAI API Key | Device (Keychain / Keystore) | Yes | Delete from Settings, or uninstall the app |
| Usage count (Free plan) | Device memory | No | Auto-reset on app restart |
| Purchase status | RevenueCat (anonymous) | - | Managed via Apple / Google subscription settings |

## Photo Library Access

The App requests read access to your photo library. This is used solely to process images received via the share sheet or selected from the album for OCR. Images are never transmitted outside the app.

## Children's Privacy

The App is not directed at children under 13 and does not knowingly collect personal information from children.

## Changes to This Policy

This Privacy Policy may be updated from time to time. Changes will be reflected on this page with an updated revision date.

## Contact

If you have questions about this Privacy Policy, please contact:

- GitHub Issues: https://github.com/hiroyafushimi/app-want-to/issues
