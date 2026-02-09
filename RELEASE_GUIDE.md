# ActClip 公開前セットアップガイド

App Store / Google Play に提出する前に完了させる設定項目をまとめたドキュメントです。

---

## 目次

1. [RevenueCat ダッシュボード設定](#1-revenuecat-ダッシュボード設定)
2. [ビルドと API Key の渡し方](#2-ビルドと-api-key-の渡し方)
3. [App Store Connect の設定（iOS）](#3-app-store-connect-の設定ios)
4. [Google Play Console の設定（Android）](#4-google-play-console-の設定android)
5. [アプリアイコン](#5-アプリアイコン)
6. [Android リリース署名](#6-android-リリース署名)
7. [セットアップ完了後のチェックリスト](#7-セットアップ完了後のチェックリスト)

---

## 現在のアプリ情報（参照用）

| 項目 | iOS | Android |
|------|-----|---------|
| アプリ名 | ActClip | ActClip |
| Bundle ID / Application ID | `com.wantto.wantTo` | `com.wantto.want_to` |
| Dart パッケージ名 | `want_to` | `want_to` |
| RevenueCat Entitlement ID | `premium` | `premium` |
| RevenueCat Product ID | `lifetime_2200` | `lifetime_2200` |
| 課金プラン | 買い切り ¥2,200（Non-Consumable） | 買い切り ¥2,200（Non-Consumable） |
| 環境変数 | `RC_IOS_KEY` | `RC_ANDROID_KEY` |

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
4. この API Key を控えておく（`RC_IOS_KEY` として使用）

### 1-3. App（Android）を登録

1. 左メニュー **「Apps」** → **「+ New」**
2. **Google Play Store** を選択し、以下を入力:
   - **App name**: `ActClip`
   - **Package Name**: `com.wantto.want_to`
3. **Service Credentials JSON**: [手順 4-4](#4-4-service-account-json-を取得revenuecat-連携用) で取得後にアップロード
4. 保存すると **Public API Key**（`goog_xxxxxxxx` 形式）が表示される
5. この API Key を控えておく（`RC_ANDROID_KEY` として使用）

### 1-4. Product を作成

iOS と Android で **同じ Product ID** を使うことで管理を簡素化する。

1. 左メニュー **「Products」** → **「+ New」**

**iOS 用:**
| フィールド | 値 |
|-----------|-----|
| Identifier | `lifetime_2200` |
| Store | Apple App Store |
| Product ID | `lifetime_2200` |

**Android 用:**
| フィールド | 値 |
|-----------|-----|
| Identifier | `lifetime_2200_android` |
| Store | Google Play Store |
| Product ID | `lifetime_2200` |

> Product ID は各ストアで作成する製品 ID と **完全一致** させる必要がある。

### 1-5. Entitlement を作成

1. 左メニュー **「Entitlements」** → **「+ New」**
2. **Identifier**: `premium`
   - コード内 `IAPService.entitlementId` と完全一致させる
3. 保存後、作成された **premium** をクリック
4. **「Attach」** ボタン → iOS 用の `lifetime_2200` と Android 用の `lifetime_2200_android` の **両方** を紐付け

### 1-6. Offering を作成

1. 左メニュー **「Offerings」** → デフォルトの `default` Offering をクリック（なければ「+ New」）
2. **「+ New Package」** をクリック
3. **Identifier** のドロップダウンから **「Lifetime」** を選択
4. 作成された Package をクリック → **「Attach Product」**
   - iOS 用 `lifetime_2200` を Attach
   - Android 用 `lifetime_2200_android` を Attach
5. 保存

### 確認ポイント

```
Offerings → default → Lifetime パッケージ → lifetime_2200 (iOS) + lifetime_2200_android (Android)
Entitlements → premium → 両方の Product が紐付いている
```

---

## 2. ビルドと API Key の渡し方

### 2-1. 開発時（シミュレータ / 実機テスト）

```bash
# iOS
flutter run --dart-define=RC_IOS_KEY=appl_xxxxxxxxxxxxxxxx

# Android
flutter run --dart-define=RC_ANDROID_KEY=goog_xxxxxxxxxxxxxxxx
```

### 2-2. VS Code / Cursor の launch.json に設定（毎回入力を省略）

`.vscode/launch.json` を作成または編集:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "ActClip (iOS)",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=RC_IOS_KEY=appl_xxxxxxxxxxxxxxxx"
      ]
    },
    {
      "name": "ActClip (Android)",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=RC_ANDROID_KEY=goog_xxxxxxxxxxxxxxxx"
      ]
    }
  ]
}
```

### 2-3. リリースビルド

```bash
# ───── iOS ─────
# iOS リリースビルド
flutter build ios --release \
  --dart-define=RC_IOS_KEY=appl_xxxxxxxxxxxxxxxx

# IPA 作成（App Store 提出用）
flutter build ipa --release \
  --dart-define=RC_IOS_KEY=appl_xxxxxxxxxxxxxxxx

# ───── Android ─────
# App Bundle 作成（Google Play 提出用 ← 推奨）
flutter build appbundle --release \
  --dart-define=RC_ANDROID_KEY=goog_xxxxxxxxxxxxxxxx

# APK 作成（直接配布用）
flutter build apk --release \
  --dart-define=RC_ANDROID_KEY=goog_xxxxxxxxxxxxxxxx
```

### 2-4. CI/CD の場合

GitHub Actions などの CI/CD では、API Key を **シークレット変数** に保存して参照する:

```yaml
# GitHub Actions の例
- run: |
    flutter build ipa --release --dart-define=RC_IOS_KEY=${{ secrets.RC_IOS_KEY }}
    flutter build appbundle --release --dart-define=RC_ANDROID_KEY=${{ secrets.RC_ANDROID_KEY }}
```

### 補足: API Key の安全性

- `appl_xxxxx` / `goog_xxxxx` は RevenueCat の **Public API Key** であり、秘密鍵ではない
- ソースコードにハードコードしても技術的には問題ないが、環境変数や CI のシークレットで管理するのがベター
- 現在のコード（`lib/services/iap_service.dart`）は `String.fromEnvironment()` で受け取る設計

---

## 3. App Store Connect の設定（iOS）

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

| 言語 | 表示名 | 説明 |
|------|--------|------|
| 日本語 | ActClip プレミアム | 読み取り・AI 機能を無制限で利用できます。一括買い切り。 |
| 英語 | ActClip Premium | Unlimited text recognition & AI features. One-time purchase. |

#### レビュー用スクリーンショット

- Paywall 画面のスクリーンショットを **1 枚** 添付

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

### 3-4. Sandbox テスト用 Apple ID を作成

1. App Store Connect → **「ユーザーとアクセス」** → **「Sandbox」** タブ
2. **「テスター」** → **「+」** で新しいテスト用アカウントを作成
3. 実機テスト時にこの Sandbox アカウントでサインインして購入テストを行う

### 3-5. レビュー提出時の注意

- アプリ内課金は **アプリ本体のレビューと同時に提出** する必要がある
- 初回提出時のレビュアー向けメモ:

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

## 4. Google Play Console の設定（Android）

### 4-1. デベロッパーアカウントを作成

1. https://play.google.com/console にアクセス
2. **Google デベロッパーアカウント** がなければ作成（初回のみ登録料 $25）
3. 本人確認・支払いプロフィールの設定を完了させる

### 4-2. アプリを作成

1. Google Play Console → **「アプリを作成」**
2. 以下を入力:
   - **アプリ名**: ActClip
   - **デフォルトの言語**: 日本語
   - **アプリまたはゲーム**: アプリ
   - **無料または有料**: 無料（アプリ内課金あり）
3. 宣言事項にチェックを入れて **「アプリを作成」**

### 4-3. アプリ内アイテム（買い切り商品）を作成

1. 左メニュー **「収益化」** → **「アプリ内アイテム」**
2. **「アイテムを作成」** をクリック
3. 以下を入力:
   - **アイテム ID**: `lifetime_2200`（RevenueCat の Product ID と**完全一致**）
   - **名前**: ActClip プレミアム
   - **説明**: 読み取り・AI 機能を無制限で利用できます。一括買い切り。
4. **価格設定**:
   - **デフォルト価格**: ¥2,200（JPY）
   - 他の国の価格は「国別の価格を設定」でデフォルト換算を適用するか個別に設定
5. ステータスを **「有効」** にする

> **注意**: アプリ内アイテムを作成するには、先にアプリの **App Bundle を 1 回以上アップロード** する必要がある（内部テストトラックでOK）。

### 4-4. Service Account JSON を取得（RevenueCat 連携用）

RevenueCat が Google Play のレシートを検証するために必要。

1. **Google Cloud Console**（https://console.cloud.google.com）を開く
2. Google Play Console と同じ Google アカウントでログイン
3. **「IAM と管理」** → **「サービスアカウント」** → **「+ サービスアカウントを作成」**
   - サービスアカウント名: `revenuecat-actclip`（任意）
   - **「作成して続行」**
4. ロール: 不要（スキップ）→ **「完了」**
5. 作成したサービスアカウントをクリック → **「キー」** タブ → **「鍵を追加」** → **「新しい鍵を作成」**
   - 種類: **JSON**
   - ダウンロードされた `.json` ファイルを安全な場所に保存
6. **Google Play Console** に戻る → **「設定」** → **「API アクセス」**
   - 「Google Cloud プロジェクトにリンク」がまだの場合はリンクする
   - 作成したサービスアカウントが一覧に表示される → **「権限を付与」**
   - **「財務データ」** の権限（「財務データ、注文、キャンセルに関するアンケートの回答の閲覧」「注文と定期購入の管理」）にチェック → **「ユーザーを招待」**
7. **RevenueCat ダッシュボード** → **Apps** → ActClip (Google Play Store) → **「Service Credentials」**
   - 先ほどダウンロードした JSON ファイルをアップロード

> 権限反映に **最大 24〜48 時間** かかる場合がある。設定直後に購入テストが失敗する場合は待ってから再試行。

### 4-5. ライセンステスト用アカウントを設定

1. Google Play Console → **「設定」** → **「ライセンステスト」**
2. **「Gmail アカウントを追加」** に、テストに使う Google アカウントのメールアドレスを追加
3. **ライセンスの応答**: **「LICENSED」** を選択
4. 保存

> これにより、追加したアカウントではアプリ内課金が課金されずにテストできる。

### 4-6. 内部テストでアプリをアップロード

課金商品を有効化するために、最低 1 回 App Bundle をアップロードする必要がある。

1. 左メニュー **「テスト」** → **「内部テスト」** → **「新しいリリースを作成」**
2. **署名鍵**:
   - 初回は「Google Play アプリ署名を使用する」→ **「続行」**
3. **App Bundle をアップロード**:
   ```bash
   flutter build appbundle --release \
     --dart-define=RC_ANDROID_KEY=goog_xxxxxxxxxxxxxxxx
   ```
   - 生成される `build/app/outputs/bundle/release/app-release.aab` をアップロード
4. **リリース名**: `1.0.0`（任意）
5. **「リリースのレビュー」** → **「内部テストトラックにリリース開始」**
6. **テスター** タブ → テスト用メーリングリストを作成 → テスターを追加

### 4-7. ストア掲載情報

Google Play に公開する前に、以下の情報が必須:

| 項目 | 内容 |
|------|------|
| アプリ名 | ActClip |
| 簡単な説明（80 文字以内） | スクショを共有 → 指で囲んでテキスト化。AI で要約・翻訳も。 |
| 詳しい説明（4000 文字以内） | アプリの機能を詳細に記述 |
| スクリーンショット | 最低 2 枚（スマホ）。推奨: 16:9 の縦画像 |
| アプリアイコン | 512 x 512 px PNG（Google Play 用） |
| フィーチャー グラフィック | 1024 x 500 px PNG/JPG |
| プライバシーポリシー URL | 必須（カメラ/写真アクセスあるため） |
| カテゴリ | ツール |
| コンテンツのレーティング | アンケートに回答して取得 |

### 4-8. レビュー提出時の注意

- Google Play はレビューに **数日〜1 週間** かかることがある（初回は特に長い）
- アプリ内アイテムは **有効** になっていないとテストもできない
- 内部テストは **審査不要** ですぐに配信される → まず内部テストで課金フローを確認

---

## 5. アプリアイコン

### 5-1. 画像の仕様

| 項目 | iOS | Android (Google Play) |
|------|-----|----------------------|
| サイズ | 1024 x 1024 px | 512 x 512 px（アプリ内: 自動リサイズ） |
| フォーマット | PNG | PNG |
| 透過 | なし | なし |
| 角丸 | 不要（iOS が自動適用） | 不要（アダプティブアイコン対応） |

### 5-2. flutter_launcher_icons で一括設定（推奨）

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

# アイコン生成（iOS + Android 全サイズ自動作成）
dart run flutter_launcher_icons
```

生成先:
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Android: `android/app/src/main/res/mipmap-*/`

### 5-3. 手動で設定する場合

**iOS（Xcode）:**
1. `ios/Runner.xcworkspace` を Xcode で開く
2. **Runner** → **Assets** → **AppIcon** に 1024x1024 画像をドラッグ

**Android（Android Studio）:**
1. `android/` フォルダを Android Studio で開く
2. `app/src/main/res` を右クリック → **New** → **Image Asset**
3. **Foreground Layer**: 用意したアイコン画像を選択
4. **Background Layer**: 背景色を設定
5. **Next** → **Finish**

---

## 6. Android リリース署名

Google Play にリリースするには、デバッグ用ではなくリリース用の署名鍵が必要。

### 6-1. キーストアを作成

```bash
keytool -genkey -v -keystore ~/actclip-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias actclip
```

プロンプトに従ってパスワードと情報を入力する。

> **重要**: `actclip-release-key.jks` は **絶対に Git にコミットしない**。紛失するとアプリの更新ができなくなるため、安全な場所にバックアップすること。

### 6-2. key.properties を作成

`android/key.properties` ファイルを作成:

```properties
storePassword=<キーストアのパスワード>
keyPassword=<キーのパスワード>
keyAlias=actclip
storeFile=/Users/<ユーザー名>/actclip-release-key.jks
```

> このファイルも **Git にコミットしない**。`.gitignore` に `android/key.properties` を追加すること。

### 6-3. build.gradle.kts にリリース署名を設定

`android/app/build.gradle.kts` を編集:

```kotlin
import java.util.Properties
import java.io.FileInputStream

// ファイル先頭（plugins ブロックの前）に追加
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// android ブロック内に signingConfigs を追加
android {
    // ... 既存の設定 ...

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

### 6-4. .gitignore に追加

```
# Android release signing
android/key.properties
*.jks
```

### 6-5. リリースビルド

```bash
flutter build appbundle --release \
  --dart-define=RC_ANDROID_KEY=goog_xxxxxxxxxxxxxxxx
```

生成された `build/app/outputs/bundle/release/app-release.aab` を Google Play Console にアップロードする。

---

## 7. セットアップ完了後のチェックリスト

### RevenueCat（共通）

| # | 確認項目 | 確認場所 |
|---|---------|----------|
| 1 | プロジェクト「ActClip」が存在する | ダッシュボード トップ |
| 2 | Apple App Store の App が登録されている | Apps 一覧 |
| 3 | Google Play Store の App が登録されている | Apps 一覧 |
| 4 | iOS Product `lifetime_2200` が存在する | Products 一覧 |
| 5 | Android Product `lifetime_2200_android` が存在する | Products 一覧 |
| 6 | Entitlement `premium` に両方の Product が紐付いている | Entitlements → premium |
| 7 | Offering `default` の Lifetime に商品がある | Offerings → default → Packages |
| 8 | iOS Shared Secret が設定済み | Apps → iOS App Settings |
| 9 | Android Service Credentials JSON がアップロード済み | Apps → Android App Settings |

### App Store Connect（iOS）

| # | 確認項目 | 確認場所 |
|---|---------|----------|
| 10 | アプリ「ActClip」が作成されている | マイ App |
| 11 | Non-Consumable 商品 `lifetime_2200` がある | アプリ内課金 → 管理 |
| 12 | 商品の価格が ¥2,200 に設定されている | 商品詳細 → 価格 |
| 13 | ローカリゼーション（日本語・英語）が入力済み | 商品詳細 |
| 14 | ステータスが「提出準備完了」 | 商品詳細 |
| 15 | Sandbox テスターが作成されている | ユーザーとアクセス → Sandbox |

### Google Play Console（Android）

| # | 確認項目 | 確認場所 |
|---|---------|----------|
| 16 | アプリ「ActClip」が作成されている | すべてのアプリ |
| 17 | アプリ内アイテム `lifetime_2200` が有効 | 収益化 → アプリ内アイテム |
| 18 | 価格が ¥2,200 に設定されている | アイテム詳細 |
| 19 | ライセンステスト用アカウントが追加されている | 設定 → ライセンステスト |
| 20 | Service Account JSON が RevenueCat にアップロード済み | RevenueCat → Android App Settings |
| 21 | App Bundle が内部テストにアップロード済み | テスト → 内部テスト |

### ビルド（iOS）

| # | 確認項目 | 確認方法 |
|---|---------|----------|
| 22 | `RC_IOS_KEY` を渡してビルドできる | `flutter run --dart-define=RC_IOS_KEY=appl_xxx` |
| 23 | Paywall 画面に商品が表示される | アプリ → 設定 → アップグレード |
| 24 | Sandbox で購入フローが完了する | 実機で Sandbox Apple ID を使用 |
| 25 | 購入後に「プレミアム」表示になる | 設定画面のプラン表示 |
| 26 | 「購入を復元」が動作する | Paywall 画面 |

### ビルド（Android）

| # | 確認項目 | 確認方法 |
|---|---------|----------|
| 27 | `RC_ANDROID_KEY` を渡してビルドできる | `flutter run --dart-define=RC_ANDROID_KEY=goog_xxx` |
| 28 | Paywall 画面に商品が表示される | アプリ → 設定 → アップグレード |
| 29 | ライセンステストで購入フローが完了する | 実機でテスト用 Google アカウントを使用 |
| 30 | 購入後に「プレミアム」表示になる | 設定画面のプラン表示 |
| 31 | リリース署名でビルドが成功する | `flutter build appbundle --release` |

### アプリアイコン

| # | 確認項目 | 確認方法 |
|---|---------|----------|
| 32 | `assets/icon/app_icon.png` が 1024x1024 | ファイルプロパティ確認 |
| 33 | `dart run flutter_launcher_icons` が成功する | ターミナルで実行 |
| 34 | iOS ホーム画面にアイコンが表示される | シミュレータ / 実機 |
| 35 | Android ホーム画面にアイコンが表示される | エミュレータ / 実機 |

---

## トラブルシューティング

### 共通

#### Paywall に「プランを取得できません」と表示される
- API Key がビルド時に渡されていない → `--dart-define` を確認
- RevenueCat の Offering にパッケージが紐付いていない → Offerings を確認
- ストア側の商品がまだ有効になっていない → ステータスを確認

#### 購入後にプレミアムにならない
- RevenueCat の Entitlement `premium` に商品が紐付いているか確認
- レシート検証用の認証情報が正しく設定されているか確認

### iOS 固有

#### Sandbox で購入テストができない
- 実機の **設定** → **App Store** → **「Sandbox アカウント」** にサインインしているか確認
- シミュレータでは課金テストができない（実機必須）

### Android 固有

#### 「このアイテムはお住まいの国ではご利用いただけません」
- ライセンステスト用アカウントが Google Play Console に追加されていない
- App Bundle がまだ内部テストにアップロードされていない

#### 「このバージョンのアプリはアプリ内課金に対応していません」
- ビルドのバージョンコードが Google Play にアップロード済みのものと一致していない
- リリース署名ではなくデバッグ署名でビルドしている → [手順 6](#6-android-リリース署名) を確認

#### Service Credentials が機能しない
- Google Play Console でサービスアカウントに財務権限を付与してから **24〜48 時間** 待つ必要がある
- Google Cloud Console とGoogle Play Console が同じアカウントでリンクされているか確認

---

## 参照リンク

| リソース | URL |
|---------|-----|
| RevenueCat ダッシュボード | https://app.revenuecat.com |
| RevenueCat iOS 設定ガイド | https://docs.revenuecat.com/docs/ios |
| RevenueCat Android 設定ガイド | https://docs.revenuecat.com/docs/android |
| RevenueCat Google Play 認証情報 | https://docs.revenuecat.com/docs/creating-play-service-credentials |
| App Store Connect | https://appstoreconnect.apple.com |
| Google Play Console | https://play.google.com/console |
| Apple Developer | https://developer.apple.com |
| Google Cloud Console | https://console.cloud.google.com |
| flutter_launcher_icons | https://pub.dev/packages/flutter_launcher_icons |
| Flutter Android リリース署名 | https://docs.flutter.dev/deployment/android |
