//
//  VideoListViewController.swift
//  TikStats
//
//  Created by VladDeveloper on 09/10/21.
//  Copyright © 2021 VladDeveloper. All rights reserved.
//

import UIKit

// Main controller/screen to show a list of video posts
class VideoListViewController: UIViewController {

    let gradient = Settings.shared.mainColor.getGradientColors()
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var videoPosts: [VideoDetail]?
    
    /// Initial logic when screen loads
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMediaData()
    }
    
    /// Fetch video media for user
    private func fetchMediaData() {
        LoadingView.showLoadingView()
        DataManager.shared.fetchMediaData { (model) in
            DispatchQueue.main.async {
                guard self.videoPosts == nil else { return }
                LoadingView.removeLoadingView()
                if let mediaModel = model, mediaModel.videoPosts.count > 0 {
                    self.videoPosts = mediaModel.videoPosts.sorted(by: { $0.likes > $1.likes })
                    self.collectionView.reloadData()
                } else {
                    self.presentGenericError(tryAgain: UIAlertAction(title: "Retry", style: .default, handler: { (_) in
                        self.fetchMediaData()
                    }))
                }
            }
        }
    }
    
    /// Dismiss video list screen when user tap on Cancel
    @IBAction func dismissVideoList(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Handle categories collection view items
extension VideoListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /// Number of sections for videos and total likes cell
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    /// Number of items for each section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 2 : videoPosts?.count ?? 0
    }
    
    /// Cells/Items for each section
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /// This will load the comments and likes cells
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "followDataCell", for: indexPath) as? DashboardCollectionViewCell {
                let index = indexPath.item
                let count = videoPosts?.compactMap({ index == 0 ? $0.likes : $0.comments }).reduce(0, +) ?? 0
                let text = "\(index == 0 ? "likes" : "comments") on\nrecent posts"
                let color = gradient
                let details = DashboardConfig.SectionItemDetails(count: NSNumber(value: count), details: text, gradient: color)
                cell.configure(details: details)
                return cell
            }
        }
        
        /// This will load the video cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as? VideoCollectionViewCell {
            cell.configure(videoModel: videoPosts?[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    /// Size for each item in sections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 { return CGSize(width: collectionView.frame.width/2 - 5, height: 150) }
        return CGSize(width: collectionView.frame.width/2 - 5, height: (collectionView.frame.width/2) * 1.4)
    }
    
    /// Navigate to TikTok app or web to see video post details
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        if let post = videoPosts?[indexPath.row], let user = UserDefaults.standard.string(forKey: "last_username") {
         
            if let url = URL(string: "https://www.tiktok.com/@\(user)/video/\(post.id)") {
                print(url)
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
