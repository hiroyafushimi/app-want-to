// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ActClip';

  @override
  String get homeMessage => 'Share a screenshot to get started.';

  @override
  String get settings => 'Settings';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get receivedImage => 'Received Image';

  @override
  String get goToRegionSelect => 'Select Region';

  @override
  String get noImage => 'No image found. Please share an image to get started.';

  @override
  String get regionSelect => 'Select Region';

  @override
  String get regionSelectInstruction =>
      'Drag to select the area you want to read';

  @override
  String get noImageSpecified => 'No image specified.';

  @override
  String get resetTooltip => 'Reset';

  @override
  String get ocrExecute => 'Read Text';

  @override
  String get processing => 'Processing...';

  @override
  String ocrFailed(String error) {
    return 'Text recognition failed: $error';
  }

  @override
  String get ocrResult => 'Result';

  @override
  String get textDisplay => 'Show Text';

  @override
  String get imagePreview => 'Image Preview';

  @override
  String get noTextRecognized => 'No text recognized';

  @override
  String get longPressToCopy => 'Long press to copy';

  @override
  String get classificationQuestion => 'What type of content is this?';

  @override
  String get classificationProduct => 'Product';

  @override
  String get classificationText => 'Text';

  @override
  String get classificationOther => 'Other';

  @override
  String get searchOnShoppingSite => 'Search Shopping Sites';

  @override
  String get askAi => 'Ask AI';

  @override
  String get copyText => 'Copy Text';

  @override
  String get copy => 'Copy';

  @override
  String get share => 'Share';

  @override
  String get copied => 'Copied';

  @override
  String get couldNotGenerateQuery => 'Could not generate search query';

  @override
  String searchQuery(String query) {
    return 'Search \"$query\"';
  }

  @override
  String get aiModalTitle => 'Ask AI';

  @override
  String get apiKeyNotSet => 'API Key not set';

  @override
  String get apiKeyNotSetDescription =>
      'Set your OpenAI API Key in Settings to use AI features like summarization, Q&A, and translation.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get enterQuestion => 'Enter your question';

  @override
  String get enterPrompt => 'Enter your prompt';

  @override
  String get send => 'Send';

  @override
  String get pleaseEnterText => 'Please enter text';

  @override
  String get aiResponse => 'AI Response';

  @override
  String get aiResponseCopied => 'AI response copied';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get aiPromptSummary => 'Summary';

  @override
  String get aiPromptQuestion => 'Q&A';

  @override
  String get aiPromptTranslate => 'Translate (JP→EN)';

  @override
  String get aiPromptCustom => 'Custom';

  @override
  String get aiDescSummary => 'Summarize within 300 characters';

  @override
  String get aiDescQuestion => 'Answer questions about the text';

  @override
  String get aiDescTranslate => 'Translate to natural English';

  @override
  String get aiDescCustom => 'Enter a custom prompt';

  @override
  String get aiIntegration => 'AI Integration';

  @override
  String get openaiApiKey => 'OpenAI API Key';

  @override
  String get loadingKey => 'Loading...';

  @override
  String keySet(String maskedKey) {
    return 'Set ($maskedKey)';
  }

  @override
  String get keyNotSet => 'Not set';

  @override
  String get deleteTooltip => 'Delete';

  @override
  String get apiKeyInfo =>
      'Set your OpenAI API Key to use features like summarization, Q&A, and translation.\nYour key is encrypted on-device and only sent to OpenAI.';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get apiKeySaved => 'API Key saved';

  @override
  String get deleteApiKey => 'Delete API Key';

  @override
  String get deleteApiKeyConfirm =>
      'Delete the saved API Key?\nAI features will be disabled.';

  @override
  String get delete => 'Delete';

  @override
  String get apiKeyDeleted => 'API Key deleted';

  @override
  String get usageSection => 'Usage (Free Plan)';

  @override
  String get usageOcr => 'Reads';

  @override
  String get usageAi => 'AI';

  @override
  String get usageUnlimited => 'Unlimited';

  @override
  String usageRemaining(int remaining, int total) {
    return '$remaining / $total remaining';
  }

  @override
  String usageLimitTitle(String featureName) {
    return '$featureName limit reached';
  }

  @override
  String usageLimitMessage(int dailyLimit) {
    return 'Free plan allows $dailyLimit uses per day.\nResets tomorrow.';
  }

  @override
  String get ok => 'OK';

  @override
  String get debugSection => 'Debug';

  @override
  String get shareDebugLog => 'Share Debug Log (iOS)';

  @override
  String get shareDebugLogSubtitle => 'View Share Extension logs';

  @override
  String get shareDebugLogTitle => 'Share Debug Log';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get Started';

  @override
  String get onboarding1Title => 'Share Screenshots';

  @override
  String get onboarding1Desc =>
      'Take a screenshot and\nselect \"ActClip\" from the share sheet.';

  @override
  String get onboarding2Title => 'Select & Read';

  @override
  String get onboarding2Desc =>
      'Drag to select the area you want to read.\nAutomatically recognizes Japanese & English text.';

  @override
  String get onboarding3Title => 'Use AI';

  @override
  String get onboarding3Desc =>
      'Set an API Key to unlock\nsummarization, translation, Q&A and more.\n(Optional, you can set it up later)';

  @override
  String get homePickImage => 'Pick Image from Album';

  @override
  String get homeOrShareHint => 'Or share an image from another app';

  @override
  String get paywallTitle => 'Upgrade to Premium';

  @override
  String get paywallFeature1 => 'Unlimited reads & AI';

  @override
  String get paywallFeature2 => 'No daily limits';

  @override
  String get paywallFeature3 => 'Priority support';

  @override
  String get paywallLifetime => 'Lifetime Plan';

  @override
  String paywallLifetimePrice(String price) {
    return '$price (one-time, lifetime)';
  }

  @override
  String get paywallRestore => 'Restore Purchases';

  @override
  String get paywallRestoreSuccess => 'Purchases restored';

  @override
  String get paywallRestoreNotFound => 'No purchases found to restore';

  @override
  String get paywallPurchaseSuccess => 'Upgrade complete!';

  @override
  String get paywallPurchaseFailed => 'Purchase failed. Please try again.';

  @override
  String get paywallLoading => 'Loading plans...';

  @override
  String get paywallUnavailable =>
      'Plans unavailable right now.\nPlease try again later.';

  @override
  String get planFree => 'Free Plan';

  @override
  String get planPremium => 'Premium';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get usageLimitUpgrade => 'Go Premium for unlimited access.';
}
