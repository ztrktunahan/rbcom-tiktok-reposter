//
//  MediaCell.swift
//  HashtagsForInstagramSwift
//
//  Created by Влад Лыков on 06.03.2021.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView?.clipsToBounds = true
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
    
}
