import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ja, this message translates to:
  /// **'Wan to'**
  String get appTitle;

  /// No description provided for @homeMessage.
  ///
  /// In ja, this message translates to:
  /// **'共有シートから画像を受信して起動します。'**
  String get homeMessage;

  /// No description provided for @settings.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settings;

  /// No description provided for @settingsTooltip.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settingsTooltip;

  /// No description provided for @receivedImage.
  ///
  /// In ja, this message translates to:
  /// **'受信画像'**
  String get receivedImage;

  /// No description provided for @goToRegionSelect.
  ///
  /// In ja, this message translates to:
  /// **'範囲指定へ'**
  String get goToRegionSelect;

  /// No description provided for @noImage.
  ///
  /// In ja, this message translates to:
  /// **'画像がありません。共有シートから画像を送ってください。'**
  String get noImage;

  /// No description provided for @regionSelect.
  ///
  /// In ja, this message translates to:
  /// **'範囲指定'**
  String get regionSelect;

  /// No description provided for @regionSelectInstruction.
  ///
  /// In ja, this message translates to:
  /// **'指でドラッグして、読み取りたい範囲を選択してください'**
  String get regionSelectInstruction;

  /// No description provided for @noImageSpecified.
  ///
  /// In ja, this message translates to:
  /// **'画像が指定されていません。'**
  String get noImageSpecified;

  /// No description provided for @resetTooltip.
  ///
  /// In ja, this message translates to:
  /// **'やり直す'**
  String get resetTooltip;

  /// No description provided for @ocrExecute.
  ///
  /// In ja, this message translates to:
  /// **'テキストを読み取る'**
  String get ocrExecute;

  /// No description provided for @processing.
  ///
  /// In ja, this message translates to:
  /// **'処理中...'**
  String get processing;

  /// No description provided for @ocrFailed.
  ///
  /// In ja, this message translates to:
  /// **'テキストの読み取りに失敗しました: {error}'**
  String ocrFailed(String error);

  /// No description provided for @ocrResult.
  ///
  /// In ja, this message translates to:
  /// **'読み取り結果'**
  String get ocrResult;

  /// No description provided for @textDisplay.
  ///
  /// In ja, this message translates to:
  /// **'テキスト表示'**
  String get textDisplay;

  /// No description provided for @imagePreview.
  ///
  /// In ja, this message translates to:
  /// **'画像プレビュー'**
  String get imagePreview;

  /// No description provided for @noTextRecognized.
  ///
  /// In ja, this message translates to:
  /// **'テキストを認識できませんでした'**
  String get noTextRecognized;

  /// No description provided for @longPressToCopy.
  ///
  /// In ja, this message translates to:
  /// **'長押しでコピー'**
  String get longPressToCopy;

  /// No description provided for @classificationQuestion.
  ///
  /// In ja, this message translates to:
  /// **'このテキストはどの内容ですか？'**
  String get classificationQuestion;

  /// No description provided for @classificationProduct.
  ///
  /// In ja, this message translates to:
  /// **'商品'**
  String get classificationProduct;

  /// No description provided for @classificationText.
  ///
  /// In ja, this message translates to:
  /// **'文章'**
  String get classificationText;

  /// No description provided for @classificationOther.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get classificationOther;

  /// No description provided for @searchOnShoppingSite.
  ///
  /// In ja, this message translates to:
  /// **'通販サイトで検索'**
  String get searchOnShoppingSite;

  /// No description provided for @askAi.
  ///
  /// In ja, this message translates to:
  /// **'AI に聞く'**
  String get askAi;

  /// No description provided for @copyText.
  ///
  /// In ja, this message translates to:
  /// **'テキストをコピー'**
  String get copyText;

  /// No description provided for @copy.
  ///
  /// In ja, this message translates to:
  /// **'コピー'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In ja, this message translates to:
  /// **'共有'**
  String get share;

  /// No description provided for @copied.
  ///
  /// In ja, this message translates to:
  /// **'コピーしました'**
  String get copied;

  /// No description provided for @couldNotGenerateQuery.
  ///
  /// In ja, this message translates to:
  /// **'検索クエリを生成できませんでした'**
  String get couldNotGenerateQuery;

  /// No description provided for @searchQuery.
  ///
  /// In ja, this message translates to:
  /// **'「{query}」を検索'**
  String searchQuery(String query);

  /// No description provided for @aiModalTitle.
  ///
  /// In ja, this message translates to:
  /// **'AI に聞く'**
  String get aiModalTitle;

  /// No description provided for @apiKeyNotSet.
  ///
  /// In ja, this message translates to:
  /// **'API Key が未設定です'**
  String get apiKeyNotSet;

  /// No description provided for @apiKeyNotSetDescription.
  ///
  /// In ja, this message translates to:
  /// **'設定画面で OpenAI の API Key を登録すると、AI による要約・質問回答・翻訳などが利用できます。'**
  String get apiKeyNotSetDescription;

  /// No description provided for @openSettings.
  ///
  /// In ja, this message translates to:
  /// **'設定画面を開く'**
  String get openSettings;

  /// No description provided for @enterQuestion.
  ///
  /// In ja, this message translates to:
  /// **'質問を入力してください'**
  String get enterQuestion;

  /// No description provided for @enterPrompt.
  ///
  /// In ja, this message translates to:
  /// **'プロンプトを入力してください'**
  String get enterPrompt;

  /// No description provided for @send.
  ///
  /// In ja, this message translates to:
  /// **'送信'**
  String get send;

  /// No description provided for @pleaseEnterText.
  ///
  /// In ja, this message translates to:
  /// **'テキストを入力してください'**
  String get pleaseEnterText;

  /// No description provided for @aiResponse.
  ///
  /// In ja, this message translates to:
  /// **'AI の回答'**
  String get aiResponse;

  /// No description provided for @aiResponseCopied.
  ///
  /// In ja, this message translates to:
  /// **'AI の回答をコピーしました'**
  String get aiResponseCopied;

  /// No description provided for @errorOccurred.
  ///
  /// In ja, this message translates to:
  /// **'エラーが発生しました'**
  String get errorOccurred;

  /// No description provided for @aiPromptSummary.
  ///
  /// In ja, this message translates to:
  /// **'要約'**
  String get aiPromptSummary;

  /// No description provided for @aiPromptQuestion.
  ///
  /// In ja, this message translates to:
  /// **'質問回答'**
  String get aiPromptQuestion;

  /// No description provided for @aiPromptTranslate.
  ///
  /// In ja, this message translates to:
  /// **'翻訳（日→英）'**
  String get aiPromptTranslate;

  /// No description provided for @aiPromptCustom.
  ///
  /// In ja, this message translates to:
  /// **'カスタム'**
  String get aiPromptCustom;

  /// No description provided for @aiDescSummary.
  ///
  /// In ja, this message translates to:
  /// **'300字以内で簡潔に要約'**
  String get aiDescSummary;

  /// No description provided for @aiDescQuestion.
  ///
  /// In ja, this message translates to:
  /// **'テキストについて質問に回答'**
  String get aiDescQuestion;

  /// No description provided for @aiDescTranslate.
  ///
  /// In ja, this message translates to:
  /// **'自然な英語に翻訳'**
  String get aiDescTranslate;

  /// No description provided for @aiDescCustom.
  ///
  /// In ja, this message translates to:
  /// **'自由にプロンプトを入力'**
  String get aiDescCustom;

  /// No description provided for @aiIntegration.
  ///
  /// In ja, this message translates to:
  /// **'AI 連携'**
  String get aiIntegration;

  /// No description provided for @openaiApiKey.
  ///
  /// In ja, this message translates to:
  /// **'OpenAI API Key'**
  String get openaiApiKey;

  /// No description provided for @loadingKey.
  ///
  /// In ja, this message translates to:
  /// **'読み込み中...'**
  String get loadingKey;

  /// No description provided for @keySet.
  ///
  /// In ja, this message translates to:
  /// **'設定済み（{maskedKey}）'**
  String keySet(String maskedKey);

  /// No description provided for @keyNotSet.
  ///
  /// In ja, this message translates to:
  /// **'未設定'**
  String get keyNotSet;

  /// No description provided for @deleteTooltip.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get deleteTooltip;

  /// No description provided for @apiKeyInfo.
  ///
  /// In ja, this message translates to:
  /// **'OpenAI の API Key を設定すると、読み取ったテキストの要約・質問回答・翻訳などが利用できます。\nAPI Key は端末内に暗号化保存され、OpenAI 以外には送信されません。'**
  String get apiKeyInfo;

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @apiKeySaved.
  ///
  /// In ja, this message translates to:
  /// **'API Key を保存しました'**
  String get apiKeySaved;

  /// No description provided for @deleteApiKey.
  ///
  /// In ja, this message translates to:
  /// **'API Key を削除'**
  String get deleteApiKey;

  /// No description provided for @deleteApiKeyConfirm.
  ///
  /// In ja, this message translates to:
  /// **'保存されている API Key を削除しますか？\nAI 機能が使えなくなります。'**
  String get deleteApiKeyConfirm;

  /// No description provided for @delete.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get delete;

  /// No description provided for @apiKeyDeleted.
  ///
  /// In ja, this message translates to:
  /// **'API Key を削除しました'**
  String get apiKeyDeleted;

  /// No description provided for @usageSection.
  ///
  /// In ja, this message translates to:
  /// **'利用状況（無料プラン）'**
  String get usageSection;

  /// No description provided for @usageOcr.
  ///
  /// In ja, this message translates to:
  /// **'読み取り'**
  String get usageOcr;

  /// No description provided for @usageAi.
  ///
  /// In ja, this message translates to:
  /// **'AI'**
  String get usageAi;

  /// No description provided for @usageUnlimited.
  ///
  /// In ja, this message translates to:
  /// **'無制限'**
  String get usageUnlimited;

  /// No description provided for @usageRemaining.
  ///
  /// In ja, this message translates to:
  /// **'残り {remaining} / {total} 回'**
  String usageRemaining(int remaining, int total);

  /// No description provided for @usageLimitTitle.
  ///
  /// In ja, this message translates to:
  /// **'{featureName} の上限に達しました'**
  String usageLimitTitle(String featureName);

  /// No description provided for @usageLimitMessage.
  ///
  /// In ja, this message translates to:
  /// **'無料プランでは1日 {dailyLimit} 回まで利用できます。\n明日リセットされます。'**
  String usageLimitMessage(int dailyLimit);

  /// No description provided for @ok.
  ///
  /// In ja, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @debugSection.
  ///
  /// In ja, this message translates to:
  /// **'デバッグ'**
  String get debugSection;

  /// No description provided for @shareDebugLog.
  ///
  /// In ja, this message translates to:
  /// **'共有デバッグログ（iOS）'**
  String get shareDebugLog;

  /// No description provided for @shareDebugLogSubtitle.
  ///
  /// In ja, this message translates to:
  /// **'Share Extension のログを確認'**
  String get shareDebugLogSubtitle;

  /// No description provided for @shareDebugLogTitle.
  ///
  /// In ja, this message translates to:
  /// **'共有デバッグログ'**
  String get shareDebugLogTitle;

  /// No description provided for @onboardingSkip.
  ///
  /// In ja, this message translates to:
  /// **'スキップ'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In ja, this message translates to:
  /// **'次へ'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In ja, this message translates to:
  /// **'はじめる'**
  String get onboardingStart;

  /// No description provided for @onboarding1Title.
  ///
  /// In ja, this message translates to:
  /// **'スクショを共有'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In ja, this message translates to:
  /// **'スクリーンショットを撮って、\n共有シートから「Wan to」を選択します。'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In ja, this message translates to:
  /// **'囲んで読み取り'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In ja, this message translates to:
  /// **'指でドラッグして読み取りたい範囲を選択。\n日本語・英語のテキストを自動認識します。'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In ja, this message translates to:
  /// **'AI で活用'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In ja, this message translates to:
  /// **'API Key を設定すると、\n要約・翻訳・質問回答などが利用できます。\n（設定は任意、後からでもOK）'**
  String get onboarding3Desc;

  /// No description provided for @homePickImage.
  ///
  /// In ja, this message translates to:
  /// **'アルバムから画像を選択'**
  String get homePickImage;

  /// No description provided for @homeOrShareHint.
  ///
  /// In ja, this message translates to:
  /// **'または共有シートから画像を送ってください'**
  String get homeOrShareHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
