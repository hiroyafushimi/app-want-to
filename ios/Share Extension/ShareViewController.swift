import UIKit
import UserNotifications
import receive_sharing_intent

private let kAppGroupId = "group.com.wantto.wantTo"
private let kShareNotificationCategoryId = "WANTO_OPEN_FROM_SHARE"

class ShareViewController: RSIShareViewController {

    override func shouldAutoRedirect() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func presentationAnimationDidFinish() {
        super.presentationAnimationDidFinish()
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = "ActClip で開く"
        // shouldAutoRedirect = true により、プラグインがメインアプリを自動で開く。
        // 通知は不要（自動遷移で画像が表示されるため）。
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    private func openMainAppViaResponderChain() -> Bool {
        let mainAppScheme = "ShareMedia-com.wantto.wantTo"
        guard let url = URL(string: "\(mainAppScheme)://") else { return false }
        return openURL(url)
    }

    @objc private func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while let r = responder {
            if let app = r as? UIApplication {
                return app.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = r.next
        }
        return false
    }

    /// ローカル通知を発火させ、タップでメインアプリを開く（App Group のデータはその時点で読める）
    private func scheduleOpenAppNotification() {
        let content = UNMutableNotificationContent()
        content.title = "ActClip"
        content.body = "タップして共有した画像を開く"
        content.sound = .default
        content.categoryIdentifier = kShareNotificationCategoryId
        // ユーザーが「ActClip で開く」をタップしてプラグインが App Group に保存する時間を確保
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { [weak self] error in
            if let e = error {
                print("[ShareExt] 通知スケジュール失敗: \(e.localizedDescription)")
            } else {
                // 通知スケジュール成功
            }
        }
    }
}