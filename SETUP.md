# ActClip プロジェクトセットアップ（SPEC_WANT_TO.md 準拠）

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

Flutter 本体のインストールは成功していれば、`flutter doctor` で ✓ が付くのは Flutter と Network のみで、以下が ✗ になることがあります。**ActClip は iOS/Android がメイン**なので、使うプラットフォームに応じて対応してください。

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
- **パッケージ名**: `want_to`（アプリ表示名: ActClip）
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

- `lib/main.dart` が上書きされた場合は、`runApp(const ActClipApp());` で起動する内容に戻してください。
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

ActClip では画像が主なので上記のままで問題ありません。動画も受け取りたい場合は `PHSupportedMediaTypes` に `<string>Video</string>` を追加し、`NSExtensionActivationSupportsMovieWithMaxCount` を追加してください。

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
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = "ActClip で開く"
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

実機またはシミュレータで、写真アプリなどから画像を選択 → 共有 → 「ActClip」（または Share Extension 名）を選び、メインアプリで画像が受け取れることを確認してください。

#### よくあるエラーと対処

| 現象 | 対処 |
|------|------|
| **pod install** で `Unable to find compatibility version string for object version 70` | Xcode 16 のプロジェクト形式（object version 70）を CocoaPods が未対応のため。`ios/Runner.xcodeproj/project.pbxproj` で `objectVersion = 70` を `56` に、`compatibilityVersion = "Xcode 9.3"` を `"Xcode 14.0"` に変更してから再度 `pod install`。Xcode でプロジェクトを開くと「プロジェクト形式をアップグレード」と出る場合があるが、無視してよい。 |
| No such module 'receive_sharing_intent' | **Runner** の Build Phases で **Embed Foundation Extensions** を **Run Script** より上に移動する |
| Share Extension 追加後にビルドが失敗する | Share Extension の **Build Settings** → **Linking / Other Linker Flags** でメインプロジェクト由来の CocoaPods 設定を削除する |
| Invalid Bundle. The bundle contains disallowed file 'Frameworks' | [Stack Overflow のこの回答](https://stackoverflow.com/a/25789145/2061365) などで Frameworks の埋め込み方法を確認する |
| 共有シートにアプリが出ない | Share Extension の **Deployment Target** が Runner と一致しているか、Info.plist の NSExtension 設定を確認する |
| **ActClip を選ぶと一瞬で消えてメインアプリが開かない** | Share Extension がメインアプリを開く URL に **Extension の Bundle ID**（例: `com.wantto.wantTo.Share-Extension`）を使っているため、Runner がそのスキームを扱えていない。Runner の **Info.plist** の **CFBundleURLTypes** に、`ShareMedia-com.wantto.wantTo.Share-Extension` を**2つ目の URL スキーム**として追加する（プロジェクトの Bundle ID に合わせて変更）。 |

---

### Android の intent-filter とは（共有シート受信）

**intent-filter** は、Android に「このアプリはこんな受け取りができます」と宣言する設定です。

- **共有シート**（他アプリで「共有」→ アプリを選ぶ）から画像を受け取るには、  
  「`SEND`（1枚）」「`SEND_MULTIPLE`（複数枚）」で **image/\*** を受け取ると宣言する必要があります。
- これを **AndroidManifest.xml** の MainActivity に `<intent-filter>` として書きます。
- 書いておくことで、ユーザーが写真アプリなどで画像を「共有」→「ActClip」を選んだときに、Android が ActClip を起動し、`receive_sharing_intent` が画像パスを Flutter に渡します。

**今回の変更**: `android/app/src/main/AndroidManifest.xml` に以下を追加済みです。

- `android.intent.action.SEND` ＋ `image/*` … 画像1枚の共有を受け取る
- `android.intent.action.SEND_MULTIPLE` ＋ `image/*` … 画像複数枚の共有を受け取る
- `launchMode="singleTask"` … 共有のたびに新しい画面が積まれないようにする

追加していないと、共有シートに「ActClip」が出ても、受け取った画像をアプリ側で扱えません。

## 実装順（進行中）

1. ✅ 共有インテント受信 → 画像表示
2. 範囲選択 + OCR
3. 分類ルールベース
4. API Key 設定 + セキュア保存
5. プロトタイプ検証

---

## iOS 共有シート確認手順（B）

共有シートから画像を受け取り、アプリで表示されるまでが正しく動くか、**iOS シミュレータまたは実機**で確認する手順です。ここが通れば、次（範囲選択 + OCR）に進めます。

### 前提

- Xcode がインストール済み
- iOS Share Extension の設定が完了している（上記「iOS Share Extension の設定（詳細）」済み）
- プロジェクトで `flutter pub get` と `cd ios && pod install` が成功している

### 手順 1: iOS シミュレータを用意する

**A. シミュレータで確認する場合**

1. **Xcode を起動**する。
2. メニュー **Xcode** → **Open Developer Tool** → **Simulator** を選ぶ（または Spotlight で「Simulator」と検索して起動）。
3. シミュレータが起動したら、メニュー **File** → **Open Simulator** → 使いたい **iOS のバージョン**（例: iOS 18.2）→ **機種**（例: iPhone 16）を選ぶ。  
   - 一覧に機種が出ない場合は、**Xcode** → **Settings**（または **Preferences**）→ **Platforms** で iOS のシミュレータランタイムを追加する。
4. シミュレータのウィンドウに iPhone の画面が表示されていれば OK。

**B. 実機で確認する場合**

1. iPhone を USB で Mac に接続する。
2. iPhone で「このコンピュータを信頼しますか？」と出たら **信頼** をタップする。
3. （初回のみ）Xcode で Apple ID でサインインし、実機の「開発者モード」やプロビジョニングの指示に従う。

### 手順 2: アプリを iOS で起動する

1. **ターミナル**でプロジェクトのルートに移動する。
   ```bash
   cd /Users/fushimiyoukana/Desktop/app-want-to
   ```
2. 次のコマンドを実行する。
   ```bash
   flutter run
   ```
3. デバイス選択の一覧が表示されたら、**iOS のシミュレータまたは実機**の番号を入力して Enter。  
   - 例: `[3]: iPhone 16 (mobile)` と出ていれば `3` と入力。  
   - 実機の場合は名前で「iPhone」などと表示される。
4. ビルドが終わると、シミュレータまたは実機に ActClip アプリが起動する。  
   - 「共有シートから画像を受信して起動します。」という画面が出ていれば起動成功。

**iOS が一覧に出ない場合**

- シミュレータ: 上記のとおり Simulator アプリで機種を選んでから、もう一度 `flutter run` を実行する。
- 実機: ケーブル・信頼設定を確認し、`flutter devices` で一覧に iPhone が出るか確認する。

### 手順 3: 写真アプリで画像を選び、共有する

1. **ホーム画面から「写真」アプリを開く**（シミュレータにも標準で入っています）。
2. **写真を 1 枚選ぶ**。  
   - シミュレータにはサンプル写真が入っていない場合がある。そのときは **Safari** で適当な画像を表示 → 長押し → **画像を保存** で写真に保存してから、写真アプリでその画像を選ぶ。
3. 選んだ写真を**タップして大きく表示**する。
4. 画面左下の **共有ボタン**（四角から上向き矢印のアイコン）をタップする。
5. 共有シートが開いたら、一覧から **「ActClip」**（または Share Extension で付けた名前）を探してタップする。  
   - 一覧の下の方や「その他」の中にある場合がある。  
   - 出てこない場合は、Share Extension の設定（Info.plist の NSExtension、App Groups、ビルドターゲット）を再確認する。
6. 「ActClip で開く」などと出た場合はそのボタンをタップする（`shouldAutoRedirect() == true` のとき）。

### 手順 4: アプリで画像が表示されるか確認する

1. ActClip アプリが前面に切り替わり、**共有した画像が表示された画面**に遷移していれば成功です。
2. 「受信画像」画面で画像が表示され、「範囲指定へ」などのボタンがあれば、共有シート → 画像表示までの流れは問題ありません。

**うまくいかない場合**

- アプリは起動するが画像が出ない: Share Extension と Runner の **App Group ID** が同じか、**CUSTOM_GROUP_ID** が正しいか確認する。
- 共有シートに「ActClip」が出ない: Share Extension の **Deployment Target** が Runner と一致しているか、`ios/Share Extension/Info.plist` の NSExtension 設定を確認する。
- **「ActClip」を選ぶと一瞬で消えてメインアプリが開かない**: iOS の制限で Share Extension からメインアプリを直接開けません。**ローカル通知**で「タップして ActClip で開く」を表示するようにしてあります。共有シートで「ActClip」→「ActClip で開く」のあと、約 1 秒後に通知が出るので、**その通知をタップ**するとメインアプリが開き、共有画像が表示されます。初回のみ、メインアプリ起動時に通知の許可を求めるダイアログが出ます（許可すると通知が表示されます）。
- 実機で「信頼されていないデベロッパ」と出る: 下記「実機で信頼されていないデベロッパと出るとき」を参照。

#### 実機で「信頼されていないデベロッパ」と出るとき

実機に初めてインストールしたとき、開発用証明書が信頼されていないとアプリが起動できません。次の手順で信頼してください。

1. **iPhone の「設定」アプリ**を開く。
2. **一般** → **VPNとデバイス管理**（または **プロファイルとデバイス管理**）をタップする。
3. **デベロッパ」APP** の下に、自分の **Apple ID（メールアドレス）** が表示されている行がある。それをタップする。
4. **「〇〇を信頼」**（〇〇はあなたの Apple ID）をタップする。
5. 確認ダイアログで **「信頼」** をタップする。
6. これで ActClip アプリを起動できるようになります。まだ開いていなければ、ホーム画面から ActClip をタップして起動する。

※ 証明書の有効期限が切れたり、別の Mac / Apple ID でビルドしたりすると、再度「信頼されていないデベロッパ」と出ることがあります。そのときは上記の手順で再度信頼するか、同じ Mac で `flutter run` し直してください。

#### 共有デバッグログの確認（1から詳しい手順）

「ActClip」を選ぶと一瞬で消える・メインアプリが開かないとき、どこで止まっているかをログで確認できます。**iOS シミュレータまたは実機**で、次の順に進めてください。

**1. アプリを iOS で起動する**

1. ターミナルでプロジェクトのルートに移動する。
   ```bash
   cd /Users/fushimiyoukana/Desktop/app-want-to
   ```
2. `flutter run` を実行する。
3. デバイス一覧が表示されたら、**iPhone のシミュレータまたは実機**の番号を入力して Enter（例: `3`）。
4. ビルドが終わり、ActClip アプリが起動する。「共有シートから画像を受信して起動します。」の画面が出ていれば OK。**このターミナルは閉じずにそのままにしておく**（あとでログが出る）。

**2. 共有操作を再現する（症状を出す）**

1. **ホーム画面に一度戻る**（シミュレータなら Cmd+Shift+H、実機ならホームボタンまたはスワイプ）。
2. **写真**アプリを開く。
3. 写真を 1 枚選んでタップし、大きく表示する。
4. 画面左下の **共有ボタン**（四角から矢印が出ているアイコン）をタップする。
5. 共有シートが開いたら、一覧から **「ActClip」** をタップする。
6. 「want to に接続」などが一瞬出て消える、または何も起きない状態を再現する。
7. その後、**もう一度 ActClip アプリを手動で開く**（ホーム画面のアイコンをタップ）。メインアプリが前面に出ていれば、そのまま次へ。出ていなければ、Dock や App スイッチャーから ActClip を選んで開く。

**3. アプリ内で「共有デバッグログ」を開く**

1. ActClip アプリが前面にある状態で、画面右上の **歯車アイコン（設定）** をタップする。
2. 設定画面が開いたら、**「共有デバッグログ（iOS）」** の行をタップする。
3. **「共有デバッグログ」** というタイトルの画面に切り替わり、テキストが表示される（初回は「読み込み中...」のあと、ログまたは「(ログファイルなし)」などになる）。

**4. ログの内容を確認する**

- 画面に表示されているのが、Share Extension と Runner（メインアプリ）が **App Group** に書き出したログです。
- **更新ボタン**（右上の矢印アイコン）をタップすると、最新のログを再取得して表示します。共有操作の直後に開いた場合は、そのまま表示されているはずです。
- **コピーボタン**（右上のコピーアイコン）をタップすると、表示中のログ全文がクリップボードにコピーされます。サポートに貼り付けたり、メモに保存したりするときに使います。

**5. ログの見方（何を確認するか）**

ログは **1 行が 1 件**で、左側に時刻、右側にメッセージが出ます。次の順番で出ているか、どの行まで出ているかを確認します。

| 順番 | ログの例 | 意味 |
|------|----------|------|
| 1 | `[ShareExt] viewDidLoad` | Share Extension が起動した（「ActClip」をタップしたタイミング）。 |
| 2 | `[ShareExt] presentationAnimationDidFinish` | 拡張の画面表示が終わった。このあと約 0.4 秒で「メインアプリを開く」処理が走る。 |
| 3 | `[ShareExt] openURL(ShareMedia-com.wantto.wantTo://) = true` または `= false` | レスポンダチェーンでメインアプリを開こうとした結果。**true** なら「開く処理は成功」、**false** なら「開けなかった」（ここで止まっている可能性大）。 |
| 4 | `[ShareExt] viewWillDisappear` | 拡張の画面が閉じる直前。ここでもう一度 openURL を試している。 |
| 5 | `[Runner] application(open: ShareMedia-com.wantto.wantTo://)` | **メインアプリ（Runner）が URL を受け取った**。ここまで出ていれば、共有シートからメインアプリへの「開く」連携は動いている。 |
| 6 | `[Runner] didFinishLaunching` | メインアプリが起動した（またはバックグラウンドから復帰した）タイミング。 |

**症状別の目安**

- **「一瞬で消える」だけで、メインアプリが開かない**
  - `openURL(...) = false` だけ出ている → Share Extension 側で「メインアプリを開く」処理が失敗している（レスポンダチェーンの問題）。
  - `[Runner] application(open: ...)` が **一切ない** → URL がメインアプリに届いていない（スキームの登録や Info.plist を疑う）。
  - `[Runner] application(open: ...)` は **ある** → URL は届いている。メインアプリが前面に出ていないだけの可能性（別ウィンドウやバックグラウンドで起動している）。

- **メインアプリは開くが、画像が表示されない**
  - ターミナル（`flutter run` している画面）に `[WanTo] getInitialMedia: 0 件` と出る → メインアプリ側で「共有データ」を 0 件しか受け取れていない（App Group の書き出し・読み取りや CUSTOM_GROUP_ID を疑う）。
  - `[WanTo] getInitialMedia: 1 件` と出るのに画面に画像が出ない → 表示側（ReceivedImageScreen や path の扱い）を疑う。

**6. ターミナルにも出るログ**

`flutter run` したままにしているターミナルには、次のようなログが出ます。

- `[WanTo] getInitialMedia: N 件` … アプリ起動時に「共有で渡されたメディア」を N 件取得した。0 ならまだ何も受け取っていない。
- `[WanTo] mediaStream: N 件` … アプリが起動しているあいだに、共有が届いたときに N 件。

共有操作のあと、メインアプリが前面に来たタイミングで `getInitialMedia: 1 件` などと出ていれば、データは届いています。

**7. ログを共有するとき**

- アプリ内の **共有デバッグログ** 画面で **コピー** をタップする。
- メールやチャットに貼り付けて送る。または、ログ全文をテキストファイルに保存して添付する。
- 「いつ・どの操作をしたか」（例: 写真アプリで画像選択 → 共有 → ActClip をタップ → 一瞬で消えた）を一言添えると原因を絞りやすいです。

ここまで確認できたら **B 完了**。次は範囲選択画面の実装（C）に進めます。

---

## 課金UI非表示について

- `lib/services/iap_service.dart` の `IAPService(paywallVisible: false)` にすると、Paywall 表示を行いません。
- アプリ起動時に `paywallVisible` をリモート設定や Feature Flag で切り替える設計にすると、必要時に非表示にできます。
