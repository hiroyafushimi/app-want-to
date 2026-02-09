# ActClip 公開前セットアップガイド

App Store に提出する前に完了させる 4 つの設定項目をまとめたドキュメントです。

---

## 目次

1. [RevenueCat ダッシュボード設定](#1-revenuecat-ダッシュボード設定)
2. [ビルドと API Key の渡し方](#2-ビルドと-api-key-の渡し方)
3. [App Store Connect の設定](#3-app-store-connect-の設定)
4. [アプリアイコン](#4-アプリアイコン)
5. [セットアップ完了後のチェックリスト](#5-セットアップ完了後のチェックリスト)

---

## 現在のアプリ情報（参照用）

| 項目 | 値 |
|------|-----|
| アプリ名 | ActClip |
| Bundle ID | `com.wantto.wantTo` |
| Dart パッケージ名 | `want_to` |
| RevenueCat Entitlement ID | `premium` |
| RevenueCat Product ID | `lifetime_2200` |
| 課金プラン | 買い切り ¥2,200（Non-Consumable / Lifetime）のみ |
| 環境変数（iOS） | `RC_IOS_KEY` |
| 環境変数（Android） | `RC_ANDROID_KEY` |

---

## 1. RevenueCat ダッシュボード設定

### 1-1. アカウント作成 & プロジェクト登録

1. https://app.revenuecat.com にアクセスし、アカウントを作成（Google / GitHub ログイン可）
2. ダッシュボード左上の **「+ New Project」** をクリック
3. プロジェクト名: **ActClip** と入力して作成

### 1-2. App（iOS）を登録

1. 左メニュー **「Apps」** → **「+ New」**
2. **Apple App Store** を選択し、以下を入力:
   - **App name**: `ActClip`
   - **App Bundle ID**: `com.wantto.wantTo`
   - **App Store Connect App-Specific Shared Secret**: [手順 3-3](#3-3-shared-secret-を取得revenuecat-連携用) で取得後に貼り付け
3. 保存すると **Public API Key**（`appl_xxxxxxxx` 形式）が表示される
4. この API Key を控えておく（後述のビルドで使用）

> **Android を追加する場合**: 同じ手順で **Google Play Store** を選択し、`goog_xxxxxxxx` の API Key を取得する。

### 1-3. Product を作成

1. 左メニュー **「Products」** → **「+ New」**
2. 以下を入力:
   - **Identifier**: `lifetime_2200`
   - **Store**: Apple App Store
   - **Product ID**: `lifetime_2200`
3. 保存

> この Product ID は App Store Connect 側で作成する製品 ID と **完全一致** させる必要がある。

### 1-4. Entitlement を作成

1. 左メニュー **「Entitlements」** → **「+ New」**
2. **Identifier**: `premium`
   - コード内 `IAPService.entitlementId` と完全一致させる
3. 保存後、作成された **premium** をクリック
4. **「Attach」** ボタン → 先ほど作成した `lifetime_2200` を選択して紐付け

### 1-5. Offering を作成

1. 左メニュー **「Offerings」** → デフォルトの `default` Offering をクリック（なければ「+ New」）
2. **「+ New Package」** をクリック
3. **Identifier** のドロップダウンから **「Lifetime」** を選択
4. 作成された Package をクリック → **「Attach Product」** → `lifetime_2200` を選択
5. 保存

### 確認ポイント

```
Offerings → default → Lifetime パッケージ → lifetime_2200
Entitlements → premium → lifetime_2200 が紐付いている
```

---

## 2. ビルドと API Key の渡し方

### 2-1. 開発時（シミュレータ / 実機テスト）

```bash
# iOS
flutter run --dart-define=RC_IOS_KEY=appl_xxxxxxxxxxxxxxxx

# Android（将来対応時）
flutter run --dart-define=RC_ANDROID_KEY=goog_xxxxxxxxxxxxxxxx
```

### 2-2. VS Code / Cursor の launch.json に設定（毎回入力を省略）

`.vscode/launch.json` を作成または編集:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "ActClip (dev)",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=RC_IOS_KEY=appl_xxxxxxxxxxxxxxxx"
      ]
    }
  ]
}
```

> `appl_xxxxxxxxxxxxxxxx` は [手順 1-2](#1-2-appiosを登録) で取得した実際の Public API Key に置き換える。

### 2-3. リリースビルド

```bash
# iOS リリースビルド
flutter build ios --release \
  --dart-define=RC_IOS_KEY=appl_xxxxxxxxxxxxxxxx

# IPA 作成（App Store 提出用）
flutter build ipa --release \
  --dart-define=RC_IOS_KEY=appl_xxxxxxxxxxxxxxxx
```

### 2-4. CI/CD の場合

GitHub Actions などの CI/CD では、API Key を **シークレット変数** に保存して参照する:

```yaml
# GitHub Actions の例
- run: flutter build ipa --release --dart-define=RC_IOS_KEY=${{ secrets.RC_IOS_KEY }}
```

### 補足: API Key の安全性

- `appl_xxxxx` は RevenueCat の **Public API Key** であり、秘密鍵ではない
- ソースコードにハードコードしても技術的には問題ないが、環境変数や CI のシークレットで管理するのがベター
- 現在のコード（`lib/services/iap_service.dart`）は `String.fromEnvironment()` で受け取る設計

---

## 3. App Store Connect の設定

### 3-1. アプリを作成

1. https://appstoreconnect.apple.com にログイン
2. **「マイ App」** → **「+」** → **「新規 App」**
3. 以下を入力:
   - **プラットフォーム**: iOS
   - **名前**: ActClip
   - **プライマリ言語**: 日本語
   - **バンドル ID**: `com.wantto.wantTo`（Apple Developer Portal で登録済みのもの）
   - **SKU**: `actclip`（任意の一意な文字列）
4. 作成

### 3-2. アプリ内課金（Non-Consumable）を作成

1. 作成したアプリを開く → 左メニュー **「アプリ内課金」** → **「管理」** → **「+」** ボタン
2. タイプ: **「非消耗型」（Non-Consumable）** を選択
3. 以下を入力:
   - **参照名**: `プレミアム（買い切り）`（管理用、ユーザーには見えない）
   - **製品 ID**: `lifetime_2200`（RevenueCat の Product ID と**完全一致**）
4. 保存後、作成された商品をクリックして詳細を設定:

#### 価格

- **「サブスクリプション価格」** セクション → **「+」** で価格を追加
- **価格**: ¥2,200（Tier 22 相当）

#### App Store ローカリゼーション

言語ごとに表示名と説明を設定:

| 言語 | 表示名 | 説明 |
|------|--------|------|
| 日本語 | ActClip プレミアム | 読み取り・AI 機能を無制限で利用できます。一括買い切り。 |
| 英語 | ActClip Premium | Unlimited text recognition & AI features. One-time purchase. |

#### レビュー用スクリーンショット

- Paywall 画面のスクリーンショットを **1 枚** 添付（レビュー審査で必要）
- 実機またはシミュレータで Paywall 画面を開いてスクリーンショットを撮る

#### ステータス

- 全て入力したら **「提出準備完了」** にする

### 3-3. Shared Secret を取得（RevenueCat 連携用）

1. App Store Connect → **「マイ App」** → ActClip を選択
2. 左メニュー **「一般」** → **「App 情報」**
3. ページ下部 **「App 用共有シークレット」** → **「管理」** → **「生成」**
4. 表示された 32 文字のシークレット文字列をコピー
5. RevenueCat ダッシュボードに戻る:
   - **Apps** → ActClip (Apple App Store) の設定画面
   - **「App Store Connect App-Specific Shared Secret」** 欄に貼り付けて保存

> Shared Secret は RevenueCat がレシート検証を行うために必要。設定しないと購入が検証されない。

### 3-4. Sandbox テスト用 Apple ID を作成

1. App Store Connect → **「ユーザーとアクセス」** → **「Sandbox」** タブ
2. **「テスター」** → **「+」** で新しいテスト用アカウントを作成
   - メールアドレス: 実在しなくてよいが、フォーマットは有効なものにする
   - パスワード: 任意
3. 実機テスト時、App Store からサインアウトし、この Sandbox アカウントでサインインして購入テストを行う

### 3-5. レビュー提出時の注意

- アプリ内課金は **アプリ本体のレビューと同時に提出** する必要がある
- 初回提出時のレビュアー向けメモ（推奨文面）:

```
In-App Purchase Testing:
- Open Settings screen → tap "Upgrade" button, or use the app until
  the daily free limit is reached and tap "Upgrade" in the limit dialog.
- Product: Lifetime Premium (¥2,200, non-consumable)
- Restore: Available via "Restore Purchases" button on the paywall screen.

No login is required to use the app.
AI features require the user's own OpenAI API Key (optional).
```

---

## 4. アプリアイコン

### 4-1. 画像の仕様

| 項目 | 要件 |
|------|------|
| サイズ | 1024 x 1024 px |
| フォーマット | PNG |
| 透過 | なし（不透明な背景色を含むこと） |
| 角丸 | 不要（iOS が自動で角丸マスクを適用） |

### 4-2. flutter_launcher_icons で一括設定（推奨）

#### パッケージ追加

```bash
flutter pub add dev:flutter_launcher_icons
```

#### pubspec.yaml に設定を追加

`pubspec.yaml` の末尾に以下を追加:

```yaml
flutter_launcher_icons:
  ios: true
  android: true
  image_path: "assets/icon/app_icon.png"
  remove_alpha_ios: true
```

#### アイコン画像を配置して生成

```bash
# ディレクトリ作成
mkdir -p assets/icon

# ← ここに 1024x1024 の app_icon.png を配置

# アイコン生成（全サイズ自動作成）
dart run flutter_launcher_icons
```

これにより以下が自動生成される:
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` … iOS 用全サイズ
- `android/app/src/main/res/mipmap-*` … Android 用全サイズ

#### 確認

```bash
flutter run
```

シミュレータのホーム画面でアイコンが反映されていることを確認する。

### 4-3. 手動で設定する場合（Xcode）

1. `ios/Runner.xcworkspace` を Xcode で開く
2. 左ペインで **Runner** → **Assets** → **AppIcon**
3. 1024x1024 の画像を **App Store iOS 1024pt** のスロットにドラッグ&ドロップ
4. Xcode 15 以降では Single Size（1024pt）のみでOK（自動リサイズ）

---

## 5. セットアップ完了後のチェックリスト

全ての設定が正しく行われているか、以下で最終確認してください。

### RevenueCat

| # | 確認項目 | 確認場所 |
|---|---------|----------|
| 1 | プロジェクト「ActClip」が存在する | ダッシュボード トップ |
| 2 | Apple App Store の App が登録されている | Apps 一覧 |
| 3 | Product `lifetime_2200` が存在する | Products 一覧 |
| 4 | Entitlement `premium` が存在する | Entitlements 一覧 |
| 5 | `premium` に `lifetime_2200` が紐付いている | Entitlements → premium → Products |
| 6 | Offering `default` の Lifetime に商品がある | Offerings → default → Packages |
| 7 | Shared Secret が設定済み | Apps → App Settings |

### App Store Connect

| # | 確認項目 | 確認場所 |
|---|---------|----------|
| 8 | アプリ「ActClip」が作成されている | マイ App |
| 9 | Non-Consumable 商品 `lifetime_2200` がある | アプリ内課金 → 管理 |
| 10 | 商品の価格が ¥2,200 に設定されている | 商品詳細 → 価格 |
| 11 | ローカリゼーション（日本語・英語）が入力済み | 商品詳細 → ローカリゼーション |
| 12 | ステータスが「提出準備完了」になっている | 商品詳細 → ステータス |
| 13 | Sandbox テスターが作成されている | ユーザーとアクセス → Sandbox |

### ビルド

| # | 確認項目 | 確認方法 |
|---|---------|----------|
| 14 | `RC_IOS_KEY` を渡してビルドできる | `flutter run --dart-define=RC_IOS_KEY=appl_xxx` |
| 15 | Paywall 画面に商品が表示される | アプリ → 設定 → アップグレード |
| 16 | Sandbox で購入フローが完了する | 実機で Sandbox Apple ID を使用してテスト |
| 17 | 購入後に「プレミアム」表示になる | 設定画面のプラン表示 |
| 18 | 「購入を復元」が動作する | Paywall 画面の復元ボタン |

### アプリアイコン

| # | 確認項目 | 確認方法 |
|---|---------|----------|
| 19 | `assets/icon/app_icon.png` が 1024x1024 | ファイルプロパティ確認 |
| 20 | `dart run flutter_launcher_icons` が成功する | ターミナルで実行 |
| 21 | ホーム画面にアイコンが表示される | シミュレータ / 実機で確認 |

---

## トラブルシューティング

### Paywall に「プランを取得できません」と表示される

- `RC_IOS_KEY` がビルド時に渡されていない → `--dart-define=RC_IOS_KEY=appl_xxx` を確認
- RevenueCat の Offering にパッケージが紐付いていない → Offerings → default → Lifetime を確認
- App Store Connect の商品がまだ「提出準備完了」になっていない → ステータスを確認

### Sandbox で購入テストができない

- 実機の **設定** → **App Store** → 一番下の **「Sandbox アカウント」** に Sandbox テスターがサインインしているか確認
- シミュレータでは課金テストができない（実機必須）

### 購入後にプレミアムにならない

- RevenueCat の Entitlement `premium` に商品が紐付いているか確認
- Shared Secret が正しく設定されているか確認（レシート検証に必要）

---

## 参照リンク

| リソース | URL |
|---------|-----|
| RevenueCat ダッシュボード | https://app.revenuecat.com |
| RevenueCat iOS 設定ガイド | https://docs.revenuecat.com/docs/ios |
| App Store Connect | https://appstoreconnect.apple.com |
| Apple Developer | https://developer.apple.com |
| flutter_launcher_icons | https://pub.dev/packages/flutter_launcher_icons |
