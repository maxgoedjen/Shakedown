import UIKit

class LogViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var backgroundImageView: UIImageView!

    var report: BugReport?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateFromNotification:", name: Shakedown.Notifications.LogUpdated, object: nil)
        updateLog()
        let top = navigationController!.navigationBar.frame.height + (UIDevice.currentDevice().userInterfaceIdiom == .Phone ? UIApplication.sharedApplication().statusBarFrame.height : 0)
        let inset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        textView.scrollIndicatorInsets = inset
        textView.contentInset = inset
        title = NSLocalizedString("Log", comment: "Log")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateFromNotification(notification: NSNotification) {
        updateLog()
    }
    
    func updateLog() {
        let oldSize = textView.contentSize
        textView.text = report?.deviceLog
        if textView.contentOffset.y + textView.frame.height == oldSize.height {
            // At the bottom already, stay pinned to bottom as new logs come in
            let bottom = CGRect(x: 0, y: textView.contentSize.height-textView.frame.height, width: textView.frame.width, height: textView.frame.height)
            textView.scrollRectToVisible(bottom, animated: true)
        }
    }
    
}
