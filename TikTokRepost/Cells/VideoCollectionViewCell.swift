//
//  VideoCollectionViewCell.swift
//  TikStats
//
//  Created by VladDeveloper on 09/10/21.
//  Copyright © 2021 VladDeveloper. All rights reserved.
//

import UIKit

// Collection view cell for video post
class VideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    func configure(videoModel: VideoDetail?) {
        if let cover = videoModel?.cover {
            DataManager.shared.downloadImage(url: cover) { (image) in
                DispatchQueue.main.async {
                    self.coverImageView.image = image
                    UIView.animate(withDuration: 0.4) {
                        self.coverImageView.alpha = image != nil ? 1.0 : 0.4
                    }
                }
            }
        }
        countLabel.text = "♥︎ \(Double(integerLiteral:  videoModel?.likes ?? 0).formattedLikeComment)"
    }
}
