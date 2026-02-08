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