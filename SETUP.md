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

**Android**: 共有用の intent-filter は **すでに追加済み**です（下記「intent-filter とは」参照）。

**iOS**: Share Extension の設定が別途必要です。手順は下記「iOS Share Extension の設定（詳細）」を参照してください。

### iOS Share Extension の設定（詳細）

共有シートから画像を受け取るには、`receive_sharing_intent` 用に **Share Extension** を Xcode で追加し、App Groups と URL スキームを設定する必要があります。

#### 1. Xcode で Share Extension ターゲットを追加

1. **Xcode でワークスペースを開く**
   ```bash
   cd /path/to/app-want-to
   open ios/Runner.xcworkspace
   ```
2. **File** → **New** → **Target**
3. **Share Extension** を選択 → **Next**
4. **Product Name**: `Share Extension`（または任意の名前。以下「Share Extension」で統一）Share Extensioで設定済み

5. **Finish** → ダイアログで **Activate** を選択
6. **Runner** と **Share Extension** の **Minimum Deployments**（iOS の最小バージョン）を同じにしておく（**General** タブで確認）

#### 2. Share Extension の Info.plist を設定

`ios/Share Extension/Info.plist` を次の内容に合わせて編集します（画像・テキスト・URL を受け取る例）。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>AppGroupId</key>
	<string>$(CUSTOM_GROUP_ID)</string>
	<key>CFBundleVersion</key>
	<string>$(FLUTTER_BUILD_NUMBER)</string>
	<key>NSExtension</key>
	<dict>
		<key>NSExtensionAttributes</key>
		<dict>
			<key>PHSupportedMediaTypes</key>
			<array>
				<string>Image</string>
			</array>
			<key>NSExtensionActivationRule</key>
			<dict>
				<key>NSExtensionActivationSupportsText</key>
				<true/>
				<key>NSExtensionActivationSupportsWebURLWithMaxCount</key>
				<integer>1</integer>
				<key>NSExtensionActivationSupportsImageWithMaxCount</key>
				<integer>100</integer>
			</dict>
		</dict>
		<key>NSExtensionMainStoryboard</key>
		<string>MainInterface</string>
		<key>NSExtensionPointIdentifier</key>
		<string>com.apple.share-services</string>
	</dict>
</dict>
</plist>
```

Wan to では画像が主なので上記のままで問題ありません。動画も受け取りたい場合は `PHSupportedMediaTypes` に `<string>Video</string>` を追加し、`NSExtensionActivationSupportsMovieWithMaxCount` を追加してください。

#### 3. Runner の Info.plist に URL スキームと AppGroupId を追加

`ios/Runner/Info.plist` の `<dict>` 直下に以下を追加します。

```xml
	<key>AppGroupId</key>
	<string>$(CUSTOM_GROUP_ID)</string>
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>ShareMedia-$(PRODUCT_BUNDLE_IDENTIFIER)</string>
			</array>
		</dict>
	</array>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>共有された画像を処理するためにフォトライブラリへのアクセスを使用します。</string>
```

- **CFBundleURLTypes**: Share Extension からメインアプリを開くための URL スキーム（`receive_sharing_intent` が使用）
- **NSPhotoLibraryUsageDescription**: 写真選択時の説明文（必須）

#### 4. Runner の Entitlements で App Groups を有効化

Xcode の画面に不慣れな方向けに、操作手順を画面の流れで説明します。

**4-1. Runner ターゲットを選ぶ**

1. Xcode の**左側のサイドバー**（プロジェクトナビゲーター）を開いておく。表示されていない場合はメニュー **View** → **Navigators** → **Project**（または `Cmd + 1`）。
2. 一番上の**青いプロジェクトアイコン**（「Runner」やプロジェクト名）をクリックする。
3. 中央のエディタエリアの**左側**に、「TARGETS」と「PROJECT」という見出しがある。その下の **TARGETS** の一覧から **Runner** を**1回クリック**して選択する（RunnerTests や Share Extension ではなく「Runner」）。

**4-2. Signing & Capabilities タブを開く**

1. Runner を選択した状態で、中央エディタの**上側**に「General」「Signing & Capabilities」「Resource Tags」などのタブが並んでいる。
2. その中の **Signing & Capabilities** をクリックする。
3. 画面に「Signing」や「Capability」のブロックが表示される。

**4-3. App Groups を追加する**

1. 「Signing & Capabilities」の画面で、**+ Capability** というボタンを探す（たいていは「Capability」セクションの左上か、既存の Capability の下あたり）。
2. **+ Capability** をクリックする。
3. 検索欄に「App Groups」と入力する。
4. 一覧に表示された **App Groups** を**ダブルクリック**する（または選択して **Add** をクリック）。
5. 「App Groups」のセクションが追加され、その中に「App Groups」とコンテナの一覧（まだ空の場合あり）が表示される。

**4-4. 新しい App Group コンテナを追加する**

1. 追加された「App Groups」のセクション内で、**+**（プラス）ボタンを探す。コンテナ一覧の横や下にあることが多い。
2. **+** をクリックする。
3. 新しい App Group の ID を入力する。例: `group.com.wantto.wantTo`  
   - 形式は `group.` で始まり、その後にバンドル ID に近い名前（例: `com.wantto.wantTo`）を付けると分かりやすい。  
   - **Runner** と **Share Extension** で**同じ ID** を使う必要があるので、ここで入力した ID をメモしておく。
4. 入力後 **OK** または **Add** をクリックする。
5. 一覧に追加したグループ（例: `group.com.wantto.wantTo`）が表示され、**チェックが入っている**ことを確認する。

**4-5. Entitlements ファイルを確認・指定する**

App Groups を追加すると、多くの場合 Xcode が **Runner.entitlements** を自動作成し、**Code Signing Entitlements** に自動で設定します。自動作成されていない場合の手順です。

1. 左サイドバーで **Runner** フォルダを開き、**Runner.entitlements** というファイルがあるか確認する。
2. **ない場合**: Runner フォルダを右クリック → **New File** → **Property List** を選び、名前を `Runner.entitlements` にして保存。左サイドバーの Runner グループ内に置く。
3. **Runner** ターゲットを選択したまま、上側のタブで **Build Settings** をクリックする。
4. 検索欄に「Code Signing Entitlements」と入力する。
5. **Code Signing Entitlements** の行の「Value」列に、`Runner/Runner.entitlements` と入力する（パスはプロジェクト構成に合わせて調整。通常は `Runner/Runner.entitlements` でよい）。

ここまでで、**Runner** 側の App Groups と Entitlements の設定は完了です。次は **Share Extension** 側（手順 5）で、同じ App Group ID を指定します。

#### 5. Share Extension に App Groups と CUSTOM_GROUP_ID を設定

1. **Share Extension** ターゲットを選択 → **Signing & Capabilities**
2. **+ Capability** → **App Groups** を追加し、**4** で作成したものと同じグループ（例: `group.com.wantto.wantTo`）を選択
3. **Share Extension** ターゲットで **Build Settings** を開く → **+** から **Add User-Defined Setting**
4. 名前: `CUSTOM_GROUP_ID`、値: 上記の App Group ID（例: `group.com.wantto.wantTo`）
5. **Runner** ターゲットの **Build Settings** にも同じ **User-Defined** の `CUSTOM_GROUP_ID` を追加し、同じ値を設定

#### 6. Podfile に Share Extension ターゲットを追加

`ios/Podfile` の `target 'Runner' do` ブロック内に、次のように **Share Extension** ターゲットを追加します（ターゲット名は Xcode で付けた名前と一致させる）。

```ruby
target 'Runner' do
  use_frameworks!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  # Share Extension（Xcode で付けた名前が「Share Extension」の場合）
  target 'Share Extension' do
    inherit! :search_paths
  end
  target 'RunnerTests' do
    inherit! :search_paths
  end
end
```

保存後、ターミナルで `cd ios && pod install` を実行します。

#### 7. Build Phases の順序を変更（Runner ターゲット）

1. **Runner** ターゲットを選択 → **Build Phases**
2. **Embed Foundation Extensions**（または **Embed App Extensions**）を **Run Script**（Thin Binary など）**より上**にドラッグして移動
3. これを行わないと「No such module 'receive_sharing_intent'」が出ることがあります

#### 8. ShareViewController をプラグインの RSIShareViewController で継承

Xcode が自動作成した `ios/Share Extension/ShareViewController.swift` を、次の内容に差し替えます。

```swift
import receive_sharing_intent

class ShareViewController: RSIShareViewController {

    // 共有後にメインアプリへ自動で遷移させない場合は false
    override func shouldAutoRedirect() -> Bool {
        return true
    }

    // 共有シートの「投稿」ボタンのラベルを変更する場合
    override func presentationAnimationDidFinish() {
        super.presentationAnimationDidFinish()
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = "Wan to で開く"
    }
}
```

- `shouldAutoRedirect() == true`: 共有をタップするとメインアプリが開き、`getInitialMedia()` / `getMediaStream()` で受け取れます
- `false`: 拡張内で完結させたい場合に使用

#### 9. ビルドと動作確認

```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run
```

実機またはシミュレータで、写真アプリなどから画像を選択 → 共有 → 「Wan to」（または Share Extension 名）を選び、メインアプリで画像が受け取れることを確認してください。

#### よくあるエラーと対処

| 現象 | 対処 |
|------|------|
| **pod install** で `Unable to find compatibility version string for object version 70` | Xcode 16 のプロジェクト形式（object version 70）を CocoaPods が未対応のため。`ios/Runner.xcodeproj/project.pbxproj` で `objectVersion = 70` を `56` に、`compatibilityVersion = "Xcode 9.3"` を `"Xcode 14.0"` に変更してから再度 `pod install`。Xcode でプロジェクトを開くと「プロジェクト形式をアップグレード」と出る場合があるが、無視してよい。 |
| No such module 'receive_sharing_intent' | **Runner** の Build Phases で **Embed Foundation Extensions** を **Run Script** より上に移動する |
| Share Extension 追加後にビルドが失敗する | Share Extension の **Build Settings** → **Linking / Other Linker Flags** でメインプロジェクト由来の CocoaPods 設定を削除する |
| Invalid Bundle. The bundle contains disallowed file 'Frameworks' | [Stack Overflow のこの回答](https://stackoverflow.com/a/25789145/2061365) などで Frameworks の埋め込み方法を確認する |
| 共有シートにアプリが出ない | Share Extension の **Deployment Target** が Runner と一致しているか、Info.plist の NSExtension 設定を確認する |

---

### Android の intent-filter とは（共有シート受信）

**intent-filter** は、Android に「このアプリはこんな受け取りができます」と宣言する設定です。

- **共有シート**（他アプリで「共有」→ アプリを選ぶ）から画像を受け取るには、  
  「`SEND`（1枚）」「`SEND_MULTIPLE`（複数枚）」で **image/\*** を受け取ると宣言する必要があります。
- これを **AndroidManifest.xml** の MainActivity に `<intent-filter>` として書きます。
- 書いておくことで、ユーザーが写真アプリなどで画像を「共有」→「Wan to」を選んだときに、Android が Wan to を起動し、`receive_sharing_intent` が画像パスを Flutter に渡します。

**今回の変更**: `android/app/src/main/AndroidManifest.xml` に以下を追加済みです。

- `android.intent.action.SEND` ＋ `image/*` … 画像1枚の共有を受け取る
- `android.intent.action.SEND_MULTIPLE` ＋ `image/*` … 画像複数枚の共有を受け取る
- `launchMode="singleTask"` … 共有のたびに新しい画面が積まれないようにする

追加していないと、共有シートに「Wan to」が出ても、受け取った画像をアプリ側で扱えません。

## 実装順（進行中）

1. ✅ 共有インテント受信 → 画像表示
2. 範囲選択 + OCR
3. 分類ルールベース
4. API Key 設定 + セキュア保存
5. プロトタイプ検証

## 課金UI非表示について

- `lib/services/iap_service.dart` の `IAPService(paywallVisible: false)` にすると、Paywall 表示を行いません。
- アプリ起動時に `paywallVisible` をリモート設定や Feature Flag で切り替える設計にすると、必要時に非表示にできます。
