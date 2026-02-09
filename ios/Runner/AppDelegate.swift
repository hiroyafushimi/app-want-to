import Flutter
import UIKit
import UserNotifications

private let kAppGroupId = "group.com.wantto.wantTo"
private let kShareDebugLogFilename = "share_extension_debug.log"
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
    let ret = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    appendShareDebugLog("[Runner] didFinishLaunching")
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "want_to/share_debug_log",
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { [weak self] call, result in
        if call.method == "getShareExtensionDebugLog" {
          result(self?.readShareExtensionDebugLog() ?? "")
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }
    return ret
  }

  /// 共有シートから URL スキームで呼ばれたとき
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    appendShareDebugLog("[Runner] application(open: \(url.absoluteString))")
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
    appendShareDebugLog("[Runner] 通知タップ: \(response.notification.request.content.categoryIdentifier)")
    if response.notification.request.content.categoryIdentifier == kShareNotificationCategoryId {
      // プラグインが URL スキーム経由で起動されたときと同じ処理を走らせる
      let urlString = "ShareMedia-com.wantto.wantTo://share"
      if let url = URL(string: urlString) {
        appendShareDebugLog("[Runner] 内部から openURL: \(urlString)")
        UIApplication.shared.open(url, options: [:]) { ok in
          self.appendShareDebugLog("[Runner] openURL 結果: \(ok)")
        }
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

  private func readShareExtensionDebugLog() -> String {
    guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: kAppGroupId) else {
      return "(App Group にアクセスできません)"
    }
    let fileURL = container.appendingPathComponent(kShareDebugLogFilename)
    guard FileManager.default.fileExists(atPath: fileURL.path),
          let data = try? Data(contentsOf: fileURL),
          let s = String(data: data, encoding: .utf8) else {
      return "(ログファイルなし)"
    }
    return s
  }

  private func appendShareDebugLog(_ line: String) {
    let full = "\(iso8601())\t\(line)\n"
    guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: kAppGroupId) else {
      return
    }
    let fileURL = container.appendingPathComponent(kShareDebugLogFilename)
    if let data = full.data(using: .utf8) {
      if FileManager.default.fileExists(atPath: fileURL.path) {
        if let f = FileHandle(forWritingAtPath: fileURL.path) {
          f.seekToEndOfFile()
          f.write(data)
          try? f.close()
        }
      } else {
        try? data.write(to: fileURL)
      }
    }
  }

  private func iso8601() -> String {
    let f = ISO8601DateFormatter()
    f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return f.string(from: Date())
  }
}
