//
//  SettingsCell.swift
//  TimetableSwift
//
//  Created by Влад Лыков on 13.01.2021.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView?.layer.cornerRadius = CGFloat(iconImageView.bounds.size.height / 4)
    }

}
