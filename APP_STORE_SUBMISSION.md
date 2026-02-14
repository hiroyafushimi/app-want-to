# ActClip App Store 提出情報

App Store Connect に入力する情報をまとめています。コピペして使ってください。

---

## ステップ 1: IPA アップロード

Xcode Organizer が開いているはずです。

1. **Runner** アーカイブを選択
2. **「Distribute App」** をクリック
3. **「App Store Connect」** → **「Upload」** を選択
4. オプションはデフォルトのまま **「Next」**
5. 証明書とプロファイルを確認して **「Upload」**
6. アップロード完了まで待つ（数分かかります）

> アップロード後、App Store Connect に反映されるまで 5〜15 分かかることがあります。

---

## ステップ 2: App Store Connect でアプリバージョンを設定

https://appstoreconnect.apple.com → **マイ App** → **ActClip** → 左メニュー **「App Store」** タブ

### 2-1. アプリ内課金を紐付け（重要！）

> 最初のアプリ内課金は、新しいアプリバージョンと一緒に提出する必要があります。

1. アプリバージョンページを下にスクロール
2. **「アプリ内課金とサブスクリプション」** セクションを見つける
3. **「+」** または **「アプリ内課金を選択」** をクリック
4. 作成済みの **プレミアム（買い切り）** を選択して紐付け

### 2-2. スクリーンショット

以下のサイズが必要です（実機またはシミュレータで撮影）:

| デバイスサイズ | 解像度 | 必須 | 対象デバイス |
|---|---|---|---|
| 6.7 インチ | 1290 × 2796 | 推奨 | iPhone 15 Pro Max, 16 Pro Max |
| 6.5 インチ | 1242 × 2688 | **必須** | iPhone 11 Pro Max, XS Max |
| 5.5 インチ | 1242 × 2208 | 任意 | iPhone 8 Plus |

#### 推奨スクリーンショット構成（3〜5枚）

1. **ホーム画面** - 「アルバムから画像を選択」の画面
2. **範囲指定画面** - 指で範囲を囲んでいる状態
3. **OCR 結果画面** - テキスト読み取り結果と分類ボタン
4. **AI 回答画面** - AI に質問して回答が表示された状態
5. **設定画面** - API Key 設定やプレミアム情報

#### シミュレータでスクリーンショットを撮る方法

```bash
# 6.5 インチ (iPhone 15 Pro Max)
flutter run --dart-define=RC_IOS_KEY=appl_rluKExnhcHcMPmXrolxhvZnPttp -d "iPhone 15 Pro Max"

# シミュレータで Cmd + S でスクリーンショット保存
# 保存先: ~/Desktop/
```

### 2-3. アプリ情報

#### 日本語（プライマリ）

**アプリ名:**
```
ActClip
```

**サブタイトル（30文字以内）:**
```
スクショからテキスト抽出＆即アクション
```

**プロモーションテキスト（170文字以内）:**
```
スクショを共有するだけ。指で囲んで即テキスト化。商品名から通販サイト比較検索、文章はAIで要約・翻訳・質問回答。毎日の情報収集をもっとスマートに。
```

**説明（4000文字以内）:**
```
ActClip は、スクリーンショットからテキストを素早く抽出し、次のアクションにつなげるアプリです。

■ 使い方はかんたん
1. スクリーンショットを撮影
2. 共有シートから ActClip を選択（またはアルバムから画像を選択）
3. 指でドラッグして読み取りたい範囲を選択
4. テキストが自動認識されます

■ 読み取ったテキストを即アクション
・商品名や価格 → Amazon / 楽天 / Yahoo!ショッピングで比較検索
・文章 → AI で要約・翻訳・質問回答（OpenAI API Key が必要）
・その他 → テキストをコピー、LINE や Slack で共有

■ プライバシー重視の設計
・OCR（テキスト認識）はすべてデバイス上で処理。画像は外部に送信されません
・API Key はデバイス内に暗号化保存。開発者を含む第三者に共有されません
・常駐プロセスやバックグラウンド通信なし

■ 料金プラン
・無料プラン：1日5回の OCR 読み取り、AI 送信1回/日
・プレミアム（買い切り）：OCR・AI ともに回数無制限
  ※ AI 機能の利用には OpenAI の API Key が別途必要です

■ 対応言語
・日本語・英語のテキスト認識に対応
・アプリ UI は日本語・英語に対応
```

**キーワード（100文字以内、カンマ区切り）:**
```
OCR,スクリーンショット,テキスト認識,文字認識,AI,翻訳,要約,商品検索,共有,コピー
```

**サポート URL:**
```
https://github.com/hiroyafushimi/app-want-to/issues
```

**プライバシーポリシー URL:**
```
https://github.com/hiroyafushimi/app-want-to/blob/main/privacy_policy.md
```

**著作権:**
```
© 2026 bay
```

**What's New（新機能）:**
```
ActClip の初回リリースです。
```

#### English

**App Name:**
```
ActClip
```

**Subtitle:**
```
Extract Text from Screenshots
```

**Promotional Text:**
```
Just share a screenshot. Select the area, extract text instantly. Search products across shopping sites, summarize or translate text with AI. Make your daily info gathering smarter.
```

**Description:**
```
ActClip extracts text from screenshots quickly and connects you to the next action.

■ Simple to Use
1. Take a screenshot
2. Select ActClip from the share sheet (or pick an image from your album)
3. Drag to select the area you want to read
4. Text is automatically recognized

■ Take Instant Action on Extracted Text
• Product names & prices → Compare across Amazon, Rakuten, Yahoo! Shopping
• Text & articles → Summarize, translate, or ask questions with AI (OpenAI API Key required)
• Anything else → Copy text, share via LINE, Slack, email, and more

■ Privacy-First Design
• OCR runs entirely on-device. Images are never sent externally
• API Key is encrypted on-device. Never shared with the developer or third parties
• No background processes or persistent network connections

■ Pricing
• Free: 5 OCR reads per day, 1 AI request per day
• Premium (one-time purchase): Unlimited OCR and AI usage
  * AI features require a separate OpenAI API Key

■ Supported Languages
• Japanese & English text recognition
• App UI available in Japanese & English
```

**Keywords:**
```
OCR,screenshot,text,recognition,AI,translate,summarize,search,copy,share
```

**What's New:**
```
Initial release of ActClip.
```

### 2-4. カテゴリ

| 項目 | 設定値 |
|---|---|
| プライマリカテゴリ | **ユーティリティ** |
| セカンダリカテゴリ | **仕事効率化** |

### 2-5. 年齢制限（レーティング）

すべての質問に **「いいえ」** を選択してください（暴力・ギャンブルなどの要素なし）。

→ 結果: **4+**

### 2-6. App Review 情報

審査チーム向けのメモを入力してください:

**審査メモ:**
```
This app receives images via the iOS Share Extension or photo library picker. 

How to test:
1. Take a screenshot on the device
2. Open the Photos app, select the screenshot, tap Share → "ActClip"
3. The app opens with the image. Drag to select a text area.
4. Text is extracted via on-device OCR (no network required)
5. Choose an action: search shopping sites, ask AI, copy, or share

AI features require an OpenAI API Key (set in Settings). This is the user's own key - the app does not provide one.

In-app purchase: One-time "Premium" purchase removes daily usage limits for OCR and AI features.

No demo account is needed. The app works without login.
```

### 2-7. App Privacy（プライバシー詳細）

App Store Connect → **「App のプライバシー」** セクション:

| 質問 | 回答 |
|---|---|
| サードパーティのアナリティクスを使用? | **いいえ** |
| 収集するデータタイプ | **購入** のみ（RevenueCat 経由の課金情報） |
| 購入データはユーザーに紐付く？ | **いいえ**（匿名） |
| 購入データはトラッキングに使用？ | **いいえ** |

---

## ステップ 3: ビルドを選択

1. App Store Connect → アプリバージョンページ
2. **「ビルド」** セクションの **「+」** をクリック
3. アップロードした **1.0.0 (1)** ビルドを選択

---

## ステップ 4: 最終確認 → 審査に提出

すべて入力したら:

1. ページ上部の **「審査に追加」** → **「審査に提出」** をクリック
2. 審査は通常 **24〜48 時間** で完了します

---

## チェックリスト

- [ ] IPA を Xcode から App Store Connect にアップロード
- [ ] アプリ内課金をアプリバージョンに紐付け
- [ ] スクリーンショット（6.5 インチ必須、3枚以上）
- [ ] アプリ説明文（日本語）
- [ ] サブタイトル
- [ ] キーワード
- [ ] サポート URL
- [ ] プライバシーポリシー URL
- [ ] カテゴリ設定
- [ ] 年齢制限設定
- [ ] App Review メモ
- [ ] App Privacy 設定
- [ ] ビルドを選択
- [ ] 審査に提出
