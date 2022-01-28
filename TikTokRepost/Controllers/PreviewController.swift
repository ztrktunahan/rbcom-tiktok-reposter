//
//  PreviewController.swift
//  HashtagsForInstagramSwift
//
//  Created by Влад Лыков on 03.04.2021.
//

import UIKit
import MKProgress
import SPAlert
import AVKit
import Photos

protocol PreviewControllerDelegate: AnyObject {
    func controllerDidDismissed()
}

// MARK: PreviewController

class PreviewController: UITableViewController {
    
    weak var delegate: PreviewControllerDelegate?

    var post: Post?

    @IBOutlet weak var imageView: UIImageView!

    var image: UIImage! {
        didSet {
            guard let image = image else {return}
            imageView?.image = image
            imageView?.frame = AVMakeRect(aspectRatio: image.size, insideRect: imageView.bounds)
        }
    }
    
    var player: AVPlayer? = nil {
        didSet {
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
                self?.player?.seek(to: CMTime.zero)
                self?.player?.play()
            }
        }
    }
    
    var isShowedAd: Bool = false
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageData = post?.imageData {
            image = UIImage(data: imageData)
        }
        

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        self.imageView.backgroundColor = .clear
        self.imageView.frame = CGRect(x: 0 * screenWidth, y: 0.3 * screenHeight, width: 0.6 * screenWidth, height: 0.12 * screenHeight)
                    
        navigationController?.presentationController?.delegate = self
     
        // Repost BUTTON KISMI
        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width
        let stringMultiplier = 0.00115 * screenHeight
        
        let backgroundView = UIView()
        //backgroundView.frame =  CGRect(x: 0 * screenWidth, y: 0 * screenHeight, width: 414 * screenWidth, height: 0.130 * screenHeight)
        backgroundView.backgroundColor = UIColor(red: 0.24, green: 0.15, blue: 0.24, alpha: 1.00)
        backgroundView.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.shadowOpacity = 1.4
        backgroundView.frame = CGRect(x: 0 * screenWidth, y: -0.07 * screenHeight, width: 1 * screenWidth, height: 0.130 * screenHeight)
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.masksToBounds = true
        view.sendSubviewToBack(backgroundView)
        view.addSubview(backgroundView)
        
        let repostButton = UIButton()
        repostButton.setBackgroundImage(UIImage(named: "btn_repost"), for: UIControl.State.normal)
        repostButton.frame = CGRect(x: 0 * screenWidth, y: 0.670 * screenHeight, width: 0.999 * screenWidth, height: 0.12 * screenHeight)
        repostButton.contentVerticalAlignment.self = .center
        repostButton.contentHorizontalAlignment.self = .center
        repostButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 20 * stringMultiplier)
        view.addSubview(repostButton)
        repostButton.addTarget(self, action: #selector(repostButtonClicked), for: UIControl.Event.touchUpInside)
        
        let repostLabel = UILabel ()
        
        repostLabel.text = NSLocalizedString("Repost", comment: "")
        repostLabel.textAlignment = .left
        repostLabel.textColor = .black
        repostLabel.font = UIFont(name: "Poppins-Regular", size: 18 * stringMultiplier)
        repostLabel.frame = CGRect(x: 0.25 * screenWidth, y: 0.670 * screenHeight, width: 0.4 * screenWidth, height: 0.12 * screenHeight)
        view.addSubview(repostLabel)
        
        
        
        /*
                
        // Save BUTTON KISMI
        let saveButton = UIButton()
        saveButton.setBackgroundImage(UIImage(named: "btn_save"), for: UIControl.State.normal)
        saveButton.frame = CGRect(x: 0 * screenWidth, y: 0.76 * screenHeight, width: 0.999 * screenWidth, height: 0.12 * screenHeight)
        saveButton.contentVerticalAlignment.self = .center
        saveButton.contentHorizontalAlignment.self = .center
        saveButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 20 * stringMultiplier)
        view.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: UIControl.Event.touchUpInside)
        
        
        let saveLabel = UILabel ()
        
        saveLabel.text = NSLocalizedString("Save", comment: "")
        saveLabel.textAlignment = .left
        saveLabel.textColor = .black
        saveLabel.font = UIFont(name: "Poppins-Regular", size: 18 * stringMultiplier)
        saveLabel.frame = CGRect(x: 0.25 * screenWidth, y: 0.76 * screenHeight, width: 0.4 * screenWidth, height: 0.12 * screenHeight)
        view.addSubview(saveLabel)
        
        
        */
        
        let backButton = UIButton()
        backButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        backButton.setBackgroundImage(UIImage(named: "btn_cross"), for: UIControl.State.normal)
        backButton.frame = CGRect(x: 0.05 * screenWidth, y: 0.015 * screenHeight, width: 0.060 * screenWidth, height: 0.028 * screenHeight)
        backButton.layer.shadowColor = UIColor(red: 0.44, green: 0.56, blue: 0.69, alpha: 0.20).cgColor
        backButton.layer.shadowRadius = 5
        backButton.layer.shadowOpacity = 1.4
        backButton.contentVerticalAlignment.self = .center
        backButton.contentHorizontalAlignment.self = .center
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: UIControl.Event.touchUpInside)

        tableView.isScrollEnabled = false
        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        
        view.frame = CGRect(x: 0, y: 0.5 * screenHeight, width: screenWidth, height: screenHeight)
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem?.tintColor = Settings.shared.mainColor
    }
    
    @objc func saveButtonClicked() {
        
        Settings.shared.repostsCount += 1

        if let  premium = uDefaults.value(forKey: "isUserPremium") as? Bool{
            isUserPremium = premium
        }
        
        if !isUserPremium{
            
            
            let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let VC1 = board.instantiateViewController(withIdentifier: "inAppVC") as! inAppVC
            self.present(VC1, animated:true, completion: nil)
                return

        }

        guard let videoURL = post?.videoURL else {return}
        
        DispatchQueue.main.async {
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            }) { saved, error in
                if saved {
                    
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                }
            }
        }

    }
    @objc func repostButtonClicked() {
        
        Settings.shared.repostsCount += 1
        
        if let  premium = uDefaults.value(forKey: "isUserPremium") as? Bool{
            isUserPremium = premium
        }
        
        if !isUserPremium {
            
            let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let VC1 = board.instantiateViewController(withIdentifier: "inAppVC") as! inAppVC
            self.present(VC1, animated:true, completion: nil)
            return
        }
        
        guard let videoURL = post?.videoURL else {return}
        
        let activityViewController = UIActivityViewController(activityItems: [videoURL], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)

    }
    @objc func backButtonClicked (){
      
        let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let VC1 = board.instantiateViewController(withIdentifier: "RepostVC") as! RepostController
        self.present(VC1, animated:true, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
       
        if let videoURL = post?.videoURL, player?.currentTime() == nil {
            player = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = imageView.bounds
            imageView.layer.addSublayer(playerLayer)
            player?.play()
            
        }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
            print("Playing \(post?.videoURL)")
            print("Error \(player?.currentTime())")
        }
       
        
        StoreReviewHelper.askForReview()
        
        if !isShowedAd {
            isShowedAd = true
            AdsManager.shared.showInterstitialAd(from: self)
        }
        
    }
    
    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = indexPath.section
        
        if section == 0 {
            return view.bounds.height * 0.58
        }
        
        return 50
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: Actions

    @IBAction func saveAction(_ sender: UIButton) {
        
 

    }
    
    @IBAction func repostAction(_ sender: UIButton) {
        


    }
    
    @IBAction func closeAction(_ sender: CloseButton) {
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "toMain", sender: nil)
            //self.dismiss(animated: true) {
            do {
                self.delegate?.controllerDidDismissed()
            }
        }
    }
            
}

// MARK: UITextViewDelegate

extension PreviewController: UITextViewDelegate {
    
    // Resize textview depending on it's content
    func textViewDidChange(_ textView: UITextView) {

        // Get textview content size
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: .greatestFiniteMagnitude))

        // Resize the cell only when cell's size is changed
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)

            let indexPath = IndexPath(row: 0, section: 3)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
}

// MARK: UIAdaptivePresentationControllerDelegate

extension PreviewController : UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.controllerDidDismissed()
    }
}


