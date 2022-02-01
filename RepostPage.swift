//
//  RepostPage.swift
//  TikTokRepost
//
//  Created by Bedri Doğan on 19.10.2021.
//

import UIKit
import BLTNBoard
import SPAlert
import TikTokFeed
import AVFoundation
class RepostPage: UIViewController, UITextFieldDelegate {

    
    var textField = UITextField()
    private var videoModel: VideoModel?
    var videoAssets: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width
        let stringMultiplier = 0.00115 * screenHeight
        
        let backgroundImage = UIImageView ()
        backgroundImage.image = UIImage(named: "img_pastelink_bg")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: screenWidth , height: screenHeight)
        backgroundImage.sendSubviewToBack(backgroundImage)
        view.addSubview(backgroundImage)
        

        
        
        let mainTitle = UILabel ()
        mainTitle.text = NSLocalizedString("Paste Video Link", comment: "")
        mainTitle.textAlignment = .center
        mainTitle.textColor = .black
        mainTitle.font = UIFont(name: "Poppins-Bold", size: 20 * stringMultiplier)
        mainTitle.frame = CGRect(x: 0.2 * screenWidth, y: 0.15 * screenHeight, width: 0.6 * screenWidth, height: 0.05 * screenHeight)
        view.addSubview(mainTitle)
        
        let subTitle = UILabel ()
        subTitle.text = NSLocalizedString("To repost the video, you need to copy\nthe link from TikTok and paste it here.", comment: "")
        subTitle.textAlignment = .center
        subTitle.textColor = .black
        subTitle.numberOfLines = 0
        subTitle.font = UIFont(name: "Poppins-Regular", size: 18 * stringMultiplier)
        subTitle.frame = CGRect(x: 0.05 * screenWidth, y: 0.25 * screenHeight, width: 0.9 * screenWidth, height: 0.1 * screenHeight)
        view.addSubview(subTitle)
        
        
        let pasteIcon = UIImageView ()
        
        pasteIcon.image = UIImage(named: "img_pasteLink")
        pasteIcon.frame = CGRect(x: 0.25 * screenWidth, y: 0.4 * screenHeight, width: 0.5 * screenWidth, height: 0.25 * screenHeight)
        view.addSubview(pasteIcon)
        
    
       
        textField.placeholder = "Paste Your Link"
        textField.frame = CGRect(x: 0.1 * screenWidth, y: 0.75 * screenHeight, width: 0.8 * screenWidth, height: 0.045 * screenHeight)
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .clear
        view.addSubview(textField)
        textField.setLeftPaddingPoints(10)
        textField.delegate = self
        
        let searchButton = UIButton ()
        searchButton.setTitle("Next", for: UIControl.State.normal)
        searchButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        searchButton.layer.cornerRadius = 10
        searchButton.layer.borderWidth = 1
        searchButton.backgroundColor = UIColor (red: 0.235, green: 0.145, blue: 0.243, alpha: 1)
        searchButton.frame = CGRect (x: 0.1 * screenWidth, y: 0.82 * screenHeight, width: 0.8 * screenWidth, height: 0.045 * screenHeight)
        view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(searchButtonClicked), for: UIControl.Event.touchUpInside)
        
        let subButton = UIButton ()
        subButton.setTitle("Open TikTok", for: UIControl.State.normal)
        subButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        subButton.frame = CGRect (x: 0.1 * screenWidth, y: 0.9 * screenHeight, width: 0.8 * screenWidth, height: 0.045 * screenHeight)
        view.addSubview(subButton)
        subButton.addTarget(self, action: #selector(openTiktokClicked), for: UIControl.Event.touchUpInside)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    /*
    func getVideoDetails(url : String){
     
//        AppLoader.show()
        LoadingView.showLoadingView()
        DataManager.shared.fetchVideoDetails(url: url) { (model) in
            DispatchQueue.main.async {
                if model == nil {
//                    AppLoader.hide()
                    LoadingView.removeLoadingView()
                    self.presentGenericError()
                    self.navigationController?.popViewController(animated: true)
                } else {
//                AppLoader.hide()
                self.videoModel = model
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        self.getVideoUrl(url: url)
                    })
                }
            }
        }
    }
    
    func getVideoUrl(url: String){
        
        
        if url != "" {
//            AppLoader.show()
            LoadingView.showLoadingView()
            DispatchQueue.global(qos: .background).async {
                DataManager.shared.downloadVideo { (videoURL) in
                    DispatchQueue.main.async {
//                        AppLoader.hide()
                        LoadingView.removeLoadingView()
                        guard let url = videoURL else {
                            self.getVideoUrl(url: url)
                            return
                        }
                        self.videoAssets = url
                       
                        
                        if let post = Database.shared.getPost(with: url.absoluteString) {
                            post.date = Date()
                            
                            self.presentPreviewController(with: post)
                            
                        }else{
                        
                        let post = Post()
                        post.videoURL = url
                        post.imageData = self.getThumbnailImage(forUrl: url)?.jpegData(compressionQuality: 0.5)
                        self.presentPreviewController(with: post)
                        
                            
                        }}
                    }
                }
            }
        }
    
    
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }


    /**
     * Called when the user click on the view (outside the UITextField).
     */
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
  
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    @objc func openTiktokClicked () {
        
        if let url = URL(string: "https://www.tiktok.com") {
              if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
              }
        
        }
        
    }
    
    @objc func searchButtonClicked() {
        
       
            let text = textField.text
        
            if let safeText = text, safeText.contains("tiktok.com") {
                textField.textColor = .black
                textField.backgroundColor = .white
                self.view.endEditing(true)
                
                self.loadMedia(from: safeText)
            } else {
                textField.textColor = .red
                textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            }
        
        
        
    }
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
    

    func loadMedia(from urlString: String) {
        let view_loading = create_loading_view(view: self.view)
        self.view.addSubview(view_loading)
        if let post = Database.shared.getPost(with: urlString) {
           post.date = Date()
            view_loading.removeFromSuperview()
           presentPreviewController(with: post)
       } else {

           MediaManager.shared.getPreviewImage(post: urlString) { (post) in

               DispatchQueue.main.async {
                   if let safePost = post {
                       LoadingView.removeLoadingView()
                       self.presentPreviewController(with: safePost)
                   } else {
                    
                   }
               }

           }

       }
       
   }
   // https://www.tiktok.com/@cznburak/video/7057873591055977729?is_from_webapp=1&sender_device=pc&web_id7058235165991388673
    
    func presentPreviewController(with post: Post) {
        
      
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PreviewController") as? PreviewController {
            vc.post = post
//            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            let navigationController = UINavigationController(rootViewController: vc)
            
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true) {
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



extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}




// Add Extension
var vSpinner : UIView?
extension UIViewController {
  func showSpinner(onView : UIView) {
    let spinnerView = UIView.init(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let ai = UIActivityIndicatorView.init(style: .whiteLarge)
    ai.startAnimating()
    ai.center = spinnerView.center
     
    DispatchQueue.main.async {
      spinnerView.addSubview(ai)
      onView.addSubview(spinnerView)
    }
     
    vSpinner = spinnerView
  }
   
  func removeSpinner() {
    DispatchQueue.main.async {
      vSpinner?.removeFromSuperview()
      vSpinner = nil
    }
  }
}
