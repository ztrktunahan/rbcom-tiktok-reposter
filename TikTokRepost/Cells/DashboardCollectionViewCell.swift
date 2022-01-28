//
//  DashboardCollectionViewCell.swift
//  TikStats
//
//  Created by VladDeveloper on 09/10/21.
//  Copyright © 2021 VladDeveloper. All rights reserved.
//

import UIKit

// This the main collection view cell class
class DashboardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    private var gradient: CAGradientLayer!
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 8
    
    var gradientColors = Settings.shared.mainColor.getGradientColors()

    /// Configure cell with title and details
    func configure(details: DashboardConfig.SectionItemDetails) {
        let imageName = details.performanceType == .lost ? "arrowDown" : "arrowUp"
        arrowImageView?.image = UIImage(named: imageName)
        arrowImageView?.isHidden = details.performanceType == .none
        configure(title: details.title, details: details.details, colors: details.gradient)
    }
    
    /// Main function to configure custom style for cell
    private func configure(title: String, details: String, colors: [CGColor]) {
        titleLabel.text = title
        detailsLabel.text = details
        gradientColors = colors
        setupCustomCellStyle()
    }
}

// MARK: - Setup custom style for cell including rounded corners, gradient, etc
extension DashboardCollectionViewCell {
    func setupCustomCellStyle() {
        gradient?.removeFromSuperlayer()
        shadowLayer?.removeFromSuperlayer()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 10, y: 10, width: bounds.width - 20, height: bounds.height - 20), cornerRadius: cornerRadius).cgPath
        gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.mask = shapeLayer
        gradient.colors = gradientColors
        gradient.startPoint = CGPoint(x: 0.4, y: 0.0)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradient, at: 0)

        shadowLayer = CAShapeLayer()
        shadowLayer.path = shapeLayer.path
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = .zero
        shadowLayer.shadowOpacity = 0.15
        shadowLayer.shadowRadius = 5
        layer.insertSublayer(shadowLayer, at: 0)
    }
}

// Main configurations for dashboard screen
class DashboardConfig {
    
    static var gradientColors = Settings.shared.mainColor.getGradientColors()
    
    /// Struct used to configure a cell
    struct SectionItemDetails {
        var count: NSNumber
        var details: String
        var gradient: [CGColor] = gradientColors
        var performanceType: DataManager.FollowPerformanceType = .none
        var title: String { return Double(exactly: count)?.formattedFollow ?? "- -" }
    }
    
    /// Section type for main dashboard screen
    enum SectionType: String, CaseIterable {
        case followData = "Current follow details"
        case followPerformance = "Lost/Gained Followers"
        case videoCount = "Total Video posts"
    }
    
    /// Number of items for each section
    static func numberOfItems(inSection section: Int) -> Int {
        switch SectionType.allCases[section] {
        case .followData:
            return 2
        case .followPerformance:
            return hasFollowPerfomanceData ? 1 : 2
        case .videoCount:
            return 1
        }
    }
    
    /// Details class for section with item index
    static func details(forIndexPath indexPath: IndexPath) -> SectionItemDetails? {
        guard let model = DataManager.shared.userModel else { return nil }
        switch SectionType.allCases[indexPath.section] {
        case .followData:
            let index = indexPath.item
            let count = index == 0 ? model.followers : model.following
            let details = index == 0 ? "Followers" : "Following"
            let gradient = gradientColors
            return SectionItemDetails(count: count, details: details, gradient: gradient)
        case .followPerformance:
            if hasFollowPerfomanceData {
                let type = DataManager.shared.followPerformanceType
                let gradient = gradientColors
                let details = type == .lost ? "Lost" : "Gained"
                let count = NSNumber(value: DataManager.shared.followPerformance)
                return SectionItemDetails(count: count, details: details, gradient: gradient, performanceType: type)
            } else {
                let gradient = gradientColors
                let details = indexPath.item == 0 ? "Lost" : "Gained"
                return SectionItemDetails(count: 0, details: details, gradient: gradient)
            }
        case .videoCount:
            let details = "Videos"
            return SectionItemDetails(count: model.video, details: details, gradient: gradientColors)
        }
    }
    
    /// Section item cell type
    static func cellIdentifier(forIndexPath indexPath: IndexPath) -> String {
        switch SectionType.allCases[indexPath.section] {
        case .followData, .videoCount:
            return "followDataCell"
        case .followPerformance:
            return "lostGainedCell"
        }
    }
    
    /// Size for item in section
    static func size(forIndexPath indexPath: IndexPath) -> CGSize {
        switch SectionType.allCases[indexPath.section] {
        case .followPerformance:
            if hasFollowPerfomanceData { return AppConfig.fullSize }
        case .videoCount:
            return AppConfig.fullSize
        default: break
        }
        return AppConfig.halfSize
    }
    
    /// Decide if we show 2 or 1 cell for follow performance section
    static var hasFollowPerfomanceData: Bool {
        return DataManager.shared.followPerformance > 0
    }
}

