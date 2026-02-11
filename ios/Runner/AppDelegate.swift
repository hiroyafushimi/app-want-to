import Flutter
import UIKit
import UserNotifications

private let kAppGroupId = "group.com.wantto.wantTo"
private let kShareNotificationCategoryId = "WANTO_OPEN_FROM_SHARE"

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Share Extension が「タップして開く」ローカル通知を出せるように許可をリクエスト
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    // 通知タップのハンドラを自分にする
    UNUserNotificationCenter.current().delegate = self
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// 共有シートから URL スキームで呼ばれたとき
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    return super.application(app, open: url, options: options)
  }

  // MARK: - UNUserNotificationCenterDelegate

  /// 通知タップ時: Share Extension の通知なら URL スキームをアプリ内から開き、
  /// receive_sharing_intent プラグインに共有データを読み込ませる
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    if response.notification.request.content.categoryIdentifier == kShareNotificationCategoryId {
      // プラグインが URL スキーム経由で起動されたときと同じ処理を走らせる
      let urlString = "ShareMedia-com.wantto.wantTo://share"
      if let url = URL(string: urlString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
    completionHandler()
  }

  /// アプリがフォアグラウンドのときに通知を表示する（バナーで出す）
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .sound])
    } else {
      completionHandler([.alert, .sound])
    }
  }

}
