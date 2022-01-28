//
//  CustomBLTNItemManager.swift
//  HashtagsForInstagramSwift
//
//  Created by Влад Лыков on 04.02.2021.
//

import UIKit
import BLTNBoard

@objc protocol BulletinManagerDelegate: AnyObject {
    @objc optional func bulletinDismissedWithError()
    @objc optional func bulletinOpenInstagramTapped()
}

enum PageType {
    case loading
    case textField
}

class BulletinManager {

    weak var delegate: BulletinManagerDelegate?
        
    let settings = Settings.shared
    
    var bulletin = BLTNItemManager(rootItem: BLTNItem())
    
    var currentPageType: PageType?
    
    func showBulletin(in vc: UIViewController) {

        DispatchQueue.main.async {
       
            if !self.bulletin.isShowingBulletin {
                
             
                self.bulletin.showBulletin(above: vc)
                if self.currentPageType == .loading {
                    self.bulletin.displayActivityIndicator()
                }
            }
            
        }
        
    }
    
    func dismissBulletin() {
                
        DispatchQueue.main.async {
            if self.bulletin.isShowingBulletin {
                self.bulletin.dismissBulletin(animated: true)
                self.currentPageType = nil
            }
        }
        
    }
    
    // MARK: DataSource
        
    func makeHashtagsPage(for hashtag: Hashtag) {
        
        guard let title = hashtag.title else {return}
        
        let page = BLTNPageItem(title: title)
        
        page.descriptionText = hashtag.tags
        page.actionButtonTitle = NSLocalizedString("Copy", comment: "")
        page.appearance.actionButtonColor = settings.mainColor
        
        page.actionHandler = { item in
            UIImpactFeedbackGenerator.tapticFeedback()
            UIPasteboard.general.string = hashtag.tags
            item.manager?.dismissBulletin()
        }
        
        bulletin = BLTNItemManager(rootItem: page)
                
    }
    
    func makeLoadingPage() {
        
        let page = BLTNPageItem(title: "")
        
        page.descriptionText = ""
        page.actionButtonTitle = ""
        page.appearance.actionButtonColor = .clear
        
        bulletin = BLTNItemManager(rootItem: page)
        
        currentPageType = .loading
        
    }
    
     func makeTextFieldPage(with urlString: String) {

        let page = TextFieldBulletinPage(title: NSLocalizedString("Paste video link", comment: ""))
        page.descriptionText = NSLocalizedString("To repost the video, you need to copy the link from TikTok and paste it here.", comment: "")
        page.actionButtonTitle = NSLocalizedString("Next", comment: "")
        page.alternativeButtonTitle = NSLocalizedString("Open TikTok", comment: "")
        
        page.appearance.actionButtonColor = UIColor(red: 0.49, green: 0.89, blue: 0.95, alpha: 1.00)
        page.appearance.actionButtonTitleColor = .black
        page.appearance.alternativeButtonTitleColor = .black
    
        

        if urlString.count != 0 {
            page.text = urlString
        } else {
            page.placeholder = NSLocalizedString("Paste Your Link", comment: "")
        }
                
        page.textInputHandler = { (item, text) in
            if let safeText = text, safeText.contains("tiktok.com") {
                item.manager?.displayActivityIndicator()
                self.loadMedia(from: safeText)
            } else {
                page.descriptionLabel!.textColor = .red
                page.textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            }
        }
        
        page.alternativeHandler = { _ in
            self.delegate?.bulletinOpenInstagramTapped?()
        }

        bulletin = BLTNItemManager(rootItem: page)

        
        currentPageType = .textField

    }
    
     func loadMedia(from urlString: String) {
                        
        if let post = Database.shared.getPost(with: urlString) {
            post.date = Date()
            presentPreviewController(with: post)
        } else {

            MediaManager.shared.getPreviewImage(post: urlString) { (post) in

                DispatchQueue.main.async {
                    if let safePost = post {
                        self.presentPreviewController(with: safePost)
                    } else {
                        self.dismissBulletin()
                        self.delegate?.bulletinDismissedWithError?()
                    }
                }

            }

        }
        
    }
    
    func presentPreviewController(with post: Post) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PreviewController") as? PreviewController {
            vc.post = post
            vc.delegate = self
            self.topViewController().present(UINavigationController(rootViewController: vc), animated: true) {
                Database.shared.saveContext()
            }
        }
        
    }
    
    private func topViewController() -> UIViewController {
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        
        return UIViewController()
        
    }

}

// MARK: - PreviewControllerDelegate

extension BulletinManager: PreviewControllerDelegate {
    func controllerDidDismissed() {
        dismissBulletin()
    }
}
