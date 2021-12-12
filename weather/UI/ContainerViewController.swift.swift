import UIKit
import SwiftMessages

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var loader: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.alpha = 0
        
        NotificationCenter.default.addObserver(forName: App.messageNotification, object: nil, queue: .main) {
            [weak self] notification in self?.handleNotification(notification: notification)
        }
        
        NotificationCenter.default.addObserver(forName: App.newDataIsReady, object: nil, queue: .main) {
            [weak self] notification in self?.onNewDataReady(notification: notification)
        }
        
        NotificationCenter.default.addObserver(forName: App.newDataRequested, object: nil, queue: .main) {
            [weak self] notification in self?.onNewDataRequested(notification: notification)
        }
    }
    
    func onNewDataReady(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            [weak self] in self?.loader?.alpha = 0
        }
    }
        
    func onNewDataRequested(notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            [weak self] in self?.loader?.alpha = 1
        }
    }
        
    
    func handleNotification(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let message = userInfo[App.notificationMessageUserInfoKey] as? String,
            let title = userInfo[App.notificationTitleUserInfoKey] as? String,
            let typeRaw = userInfo[App.notificationTypeUserInfoKey] as? Int,
            let messageType = App.MessageType(rawValue: typeRaw) else {
                return
        }
        let view = MessageView.viewFromNib(layout: .cardView)
        view.button?.isHidden = true
        let success = messageType == .Success
        view.configureTheme(success ? .success : .warning)
        view.configureContent(title: title, body: message, iconImage: UIImage(systemName:  success ? "checkmark" : "exclamationmark.triangle")!)
        SwiftMessages.show(view: view)
    }
}
