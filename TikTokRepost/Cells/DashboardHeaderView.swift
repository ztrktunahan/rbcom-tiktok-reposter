//
//  DashboardHeaderView.swift
//  TikStats
//
//  Created by VladDeveloper on 09/10/21.
//  Copyright © 2021 VladDeveloper. All rights reserved.
//

import UIKit
import SafariServices

// Section header view to show the title
class DashboardHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    /// Set header title for section
    func setTitle(string: String) {
        titleLabel?.text = string
        actionButton?.setTitle(string, for: .normal)
    }
    
}
