# Wan to プロジェクトセットアップ（SPEC_WANT_TO.md 準拠）

## Flutter のインストール（macOS）

Homebrew でインストールする方法（推奨）:

```bash
brew install --cask flutter
```

インストール後、次で確認します。

```bash
flutter --version
flutter doctor
```

- **iOS 開発**: Xcode と CocoaPods が必要です。`flutter doctor` の指示に従って設定してください。
- **Android 開発**: Android Studio または Android SDK のコマンドラインツールが必要です。

公式: [Flutter クイックインストール](https://docs.flutter.dev/learn/pathway/quick-install)、[macOS セットアップ](https://docs.flutter.dev/platform-integration/macos/setup)。

### flutter doctor で見つかった問題の解消

Flutter 本体のインストールは成功していれば、`flutter doctor` で ✓ が付くのは Flutter と Network のみで、以下が ✗ になることがあります。**Wan to は iOS/Android がメイン**なので、使うプラットフォームに応じて対応してください。

| 項目 | 必要なもの | 手順 |
|------|------------|------|
| **Android** | Android SDK + cmdline-tools | Android Studio 導入済みの場合は下記「Android SDK の入れ方」を参照。未導入の場合は [Android Studio](https://developer.android.com/studio) をインストールし、初回起動で SDK を導入。 |
| **Xcode（iOS/macOS）** | Xcode + CocoaPods + Simulator | 1) [App Store で Xcode](https://apps.apple.com/app/xcode/id497799835) をインストール<br>2) ターミナルで以下を実行（`-runFirstLaunch` は末尾 **h** まで正確に）:<br>`sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`<br>`sudo xcodebuild -runFirstLaunch`<br>3) CocoaPods: `brew install cocoapods`（`sudo gem install` は macOS 標準 Ruby 2.6 だと失敗する場合あり）<br>4) 「Unable to get list of installed Simulator runtimes」が出る場合: Xcode を開く → **Settings** → **Platforms** で iOS シミュレータを追加、または `xcodebuild -downloadPlatform iOS` |
| **Chrome（Web）** | Chrome または Chromium | Web ターゲットのみ使う場合。Chrome をインストールするか、別の Chromium を使う場合は **実在するパス**で `export CHROME_EXECUTABLE=/path/to/chromium` を設定。`/path/to/chromium` はプレースホルダなのでそのまま設定するとエラーになる。Web 開発しないなら `unset CHROME_EXECUTABLE` で未設定に。 |

#### Android SDK の入れ方（Android Studio 導入済みの場合）

Android Studio は入っているが「cmdline-tools component is missing」「Android license status unknown」と出る場合の手順です。

1. **Android Studio を起動**
2. **SDK の場所を確認**
   - **Android Studio** → **Settings**（macOS は **Preferences**）→ **Languages & Frameworks** → **Android SDK**
   - 上部の **Android SDK Location** をメモ（例: `/Users/あなたのユーザー名/Library/Android/sdk`）
3. **SDK と cmdline-tools を入れる**
   - 同じ画面で **SDK Platforms** タブ: 使いたい Android のバージョンにチェック（例: Android 15.0 "Vanilla Ice Cream"）→ **Apply** でインストール
   - **SDK Tools** タブを開く → **Android SDK Command-line Tools (latest)** にチェック → **Apply** でインストール
4. **環境変数 ANDROID_HOME（任意だが推奨）**
   - SDK の場所が上記の標準パスなら、Flutter はよく自動検出します。検出されない場合のみ:
   - `~/.zshrc` に追加: `export ANDROID_HOME=$HOME/Library/Android/sdk` と `export PATH=$PATH:$ANDROID_HOME/platform-tools`
   - 反映: `source ~/.zshrc`（`compdef: command not found` が出ても、ANDROID_HOME と PATH は設定されているので無視してよい）
   - または Flutter に直接伝える: `flutter config --android-sdk $HOME/Library/Android/sdk`
5. **ライセンス同意（必須）**
   - ターミナルで実行: `flutter doctor --android-licenses`（オプションは **licenses** で末尾に **s** が必要。`--android-license` だとエラーになる）
   - 各質問には **`y` だけ入力**して Enter（`y0` のように余計な文字を入れない）
6. **確認**
   - `flutter doctor` で Android が ✓ になるか確認

#### 残りよくあるパターン（Android 完了後）

- **「Some Android licenses not accepted」**  
  `flutter doctor --android-licenses` を再実行し、各プロンプトで **`y` のみ**入力して Enter（`y0` など余計な文字を入れない）。
- **「Unable to get list of installed Simulator runtimes」**  
  Xcode を開く → **Settings**（または **Preferences**）→ **Platforms** で iOS のシミュレータランタイムをインストール。またはターミナルで `xcodebuild -downloadPlatform iOS`。
- **Chrome が「/path/to/chromium is not executable」**  
  `export CHROME_EXECUTABLE=/path/to/chromium` は**例**のパスなので、そのまま設定するとエラーになる。Web 開発しないなら `unset CHROME_EXECUTABLE` で未設定に。Chrome を使うなら [Chrome](https://www.google.com/chrome/) をインストールし、`CHROME_EXECUTABLE` は未設定のまま（Flutter が標準パスを参照する）。

解消後、再度確認:

```bash
flutter doctor
flutter doctor -v   # 詳細
```

## Cursor MCP（推奨）

このプロジェクトには **Dart and Flutter MCP server** 用の設定が `.cursor/mcp.json` に含まれています。Flutter 3.35 / Dart 3.9 以上で利用可能です。

- エラー解析・修正、シンボル解決・ドキュメント取得
- pub.dev 検索、`pubspec.yaml` の依存関係管理
- テスト実行・結果解析、`dart format` 準拠のフォーマット

Cursor でプロジェクトを開けばこの MCP が有効になります。未導入の場合は **Cursor > Settings > Cursor Settings > Tools & Integrations** で MCP を確認してください。

## 実施済み

- **ブランチ**: `feature/project-setup`
- **パッケージ名**: `want_to`（アプリ名: Wan to / wantTo 等いずれも可）
- **pubspec.yaml**: `want_to`、Flutter SDK、`flutter_secure_storage`、`http`、`purchases_flutter`、`receive_sharing_intent`
- **lib/**:
  - `main.dart` / `app.dart` … ルート、共有インテント受信 → 受信画像画面へ遷移
  - `screens/` … 受信画像（画像表示・範囲指定へ）、範囲指定（スタブ）、結果・設定
  - `services/` … API Key 保存、分類、**IAP（RevenueCat・課金UI非表示対応）**、**共有インテント**
  - `models/` … OcrResult
- **課金**: RevenueCat を両方実装。`IAPService.paywallVisible == false` で Paywall 非表示可能。
- **共有**: 共有シートから画像受信 → 受信画像画面表示 → 「範囲指定へ」で範囲指定画面へ。

## Android / iOS フォルダの生成

Flutter CLI が使える環境で以下を実行してください（退避不要で実行してよい前提）。

```bash
cd /path/to/app-want-to
flutter create . --project-name want_to --org com.wantto
```

- `lib/main.dart` が上書きされた場合は、`runApp(const WanToApp());` で起動する内容に戻してください。
- または `scripts/create_platforms.sh` を実行しても構いません。

**Android**: `android/app/src/main/AndroidManifest.xml` に共有インテント用の intent-filter を追加する必要があります（`receive_sharing_intent` のドキュメント参照）。

**iOS**: Share Extension の設定が別途必要です（Xcode で Share Extension ターゲット追加など）。

## 実装順（進行中）

1. ✅ 共有インテント受信 → 画像表示
2. 範囲選択 + OCR
3. 分類ルールベース
4. API Key 設定 + セキュア保存
5. プロトタイプ検証

## 課金UI非表示について

- `lib/services/iap_service.dart` の `IAPService(paywallVisible: false)` にすると、Paywall 表示を行いません。
- アプリ起動時に `paywallVisible` をリモート設定や Feature Flag で切り替える設計にすると、必要時に非表示にできます。
