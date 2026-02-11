// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ActClip';

  @override
  String get homeMessage => '共有シートから画像を受信して起動します。';

  @override
  String get settings => '設定';

  @override
  String get settingsTooltip => '設定';

  @override
  String get receivedImage => '受信画像';

  @override
  String get goToRegionSelect => '範囲指定へ';

  @override
  String get noImage => '画像がありません。共有シートから画像を送ってください。';

  @override
  String get regionSelect => '範囲指定';

  @override
  String get regionSelectInstruction => '指でドラッグして、読み取りたい範囲を選択してください';

  @override
  String get noImageSpecified => '画像が指定されていません。';

  @override
  String get resetTooltip => 'やり直す';

  @override
  String get ocrExecute => 'テキストを読み取る';

  @override
  String get processing => '処理中...';

  @override
  String ocrFailed(String error) {
    return 'テキストの読み取りに失敗しました: $error';
  }

  @override
  String get ocrResult => '読み取り結果';

  @override
  String get textDisplay => 'テキスト表示';

  @override
  String get imagePreview => '画像プレビュー';

  @override
  String get noTextRecognized => 'テキストを認識できませんでした';

  @override
  String get longPressToCopy => '長押しでコピー';

  @override
  String get classificationQuestion => 'このテキストはどの内容ですか？';

  @override
  String get classificationProduct => '商品';

  @override
  String get classificationText => '文章';

  @override
  String get classificationOther => 'その他';

  @override
  String get searchOnShoppingSite => '通販サイトで検索';

  @override
  String get askAi => 'AI に聞く';

  @override
  String get copyText => 'テキストをコピー';

  @override
  String get copy => 'コピー';

  @override
  String get share => '共有';

  @override
  String get copied => 'コピーしました';

  @override
  String get couldNotGenerateQuery => '検索クエリを生成できませんでした';

  @override
  String searchQuery(String query) {
    return '「$query」を検索';
  }

  @override
  String get aiModalTitle => 'AI に聞く';

  @override
  String get apiKeyNotSet => 'API Key が未設定です';

  @override
  String get apiKeyNotSetDescription =>
      '設定画面で OpenAI の API Key を登録すると、AI による要約・質問回答・翻訳などが利用できます。';

  @override
  String get openSettings => '設定画面を開く';

  @override
  String get enterQuestion => '質問を入力してください';

  @override
  String get enterPrompt => 'プロンプトを入力してください';

  @override
  String get send => '送信';

  @override
  String get pleaseEnterText => 'テキストを入力してください';

  @override
  String get aiResponse => 'AI の回答';

  @override
  String get aiResponseCopied => 'AI の回答をコピーしました';

  @override
  String get errorOccurred => 'エラーが発生しました';

  @override
  String get aiPromptSummary => '要約';

  @override
  String get aiPromptQuestion => '質問回答';

  @override
  String get aiPromptTranslate => '翻訳（日→英）';

  @override
  String get aiPromptCustom => 'カスタム';

  @override
  String get aiDescSummary => '300字以内で簡潔に要約';

  @override
  String get aiDescQuestion => 'テキストについて質問に回答';

  @override
  String get aiDescTranslate => '自然な英語に翻訳';

  @override
  String get aiDescCustom => '自由にプロンプトを入力';

  @override
  String get aiIntegration => 'AI 連携';

  @override
  String get openaiApiKey => 'OpenAI API Key';

  @override
  String get loadingKey => '読み込み中...';

  @override
  String keySet(String maskedKey) {
    return '設定済み（$maskedKey）';
  }

  @override
  String get keyNotSet => '未設定';

  @override
  String get deleteTooltip => '削除';

  @override
  String get apiKeyInfo =>
      'OpenAI の API Key を設定すると、読み取ったテキストの要約・質問回答・翻訳などが利用できます。\nAPI Key は端末内に暗号化保存され、OpenAI 以外には送信されません。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get apiKeySaved => 'API Key を保存しました';

  @override
  String get deleteApiKey => 'API Key を削除';

  @override
  String get deleteApiKeyConfirm => '保存されている API Key を削除しますか？\nAI 機能が使えなくなります。';

  @override
  String get delete => '削除';

  @override
  String get apiKeyDeleted => 'API Key を削除しました';

  @override
  String get usageSection => '利用状況（無料プラン）';

  @override
  String get usageOcr => '読み取り';

  @override
  String get usageAi => 'AI';

  @override
  String get usageUnlimited => '無制限';

  @override
  String usageRemaining(int remaining, int total) {
    return '残り $remaining / $total 回';
  }

  @override
  String usageLimitTitle(String featureName) {
    return '$featureName の上限に達しました';
  }

  @override
  String usageLimitMessage(int dailyLimit) {
    return '無料プランでは1日 $dailyLimit 回まで利用できます。\n明日リセットされます。';
  }

  @override
  String get ok => 'OK';

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingStart => 'はじめる';

  @override
  String get onboarding1Title => 'スクショを共有';

  @override
  String get onboarding1Desc => 'スクリーンショットを撮って、\n共有シートから「ActClip」を選択します。';

  @override
  String get onboarding2Title => '囲んで読み取り';

  @override
  String get onboarding2Desc => '指でドラッグして読み取りたい範囲を選択。\n日本語・英語のテキストを自動認識します。';

  @override
  String get onboarding3Title => 'AI で活用';

  @override
  String get onboarding3Desc =>
      'API Key を設定すると、\n要約・翻訳・質問回答などが利用できます。\n（設定は任意、後からでもOK）';

  @override
  String get homePickImage => 'アルバムから画像を選択';

  @override
  String get homeOrShareHint => 'または共有シートから画像を送ってください';

  @override
  String get paywallTitle => 'プレミアムにアップグレード';

  @override
  String get paywallFeature1 => '読み取り・AI 無制限';

  @override
  String get paywallFeature2 => '毎日の回数制限なし';

  @override
  String get paywallFeature3 => '優先サポート';

  @override
  String get paywallLifetime => '買い切りプラン';

  @override
  String paywallLifetimePrice(String price) {
    return '$price（一括・永年）';
  }

  @override
  String get paywallRestore => '購入を復元';

  @override
  String get paywallRestoreSuccess => '購入を復元しました';

  @override
  String get paywallRestoreNotFound => '復元可能な購入が見つかりませんでした';

  @override
  String get paywallPurchaseSuccess => 'アップグレードが完了しました！';

  @override
  String get paywallPurchaseFailed => '購入に失敗しました。もう一度お試しください。';

  @override
  String get paywallLoading => 'プラン情報を取得中...';

  @override
  String get paywallUnavailable => '現在プランを取得できません。\nしばらくしてからお試しください。';

  @override
  String get planFree => '無料プラン';

  @override
  String get planPremium => 'プレミアム';

  @override
  String get upgrade => 'アップグレード';

  @override
  String get usageLimitUpgrade => 'プレミアムなら無制限で使えます。';
}
