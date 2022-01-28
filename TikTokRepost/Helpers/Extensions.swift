//
//  FCAlert.swift
//  TimetableSwift
//
//  Created by Влад Лыков on 13.01.2021.
//

import UIKit
import MessageUI
import StoreKit
import BLTNBoard
import SwiftyStoreKit

/// This is an extension on UIColor to set colors for dashboard items
extension UIColor {
//    static var blueGradient: [CGColor] = [#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)]
//    static var purpleGradient: [CGColor] = [#colorLiteral(red: 0.3098039216, green: 0.4470588235, blue: 0.9960784314, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)]
//    static var redGradient: [CGColor] = [#colorLiteral(red: 1, green: 0.2549019608, blue: 0.1137254902, alpha: 1),#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)]
//    static var greenGradient: [CGColor] = [#colorLiteral(red: 0.5294117647, green: 0.8784313725, blue: 0.2362426135, alpha: 1),#colorLiteral(red: 0.2104253752, green: 0.831372549, blue: 0.2901960784, alpha: 1)]
//    static var orangeGradient: [CGColor] = [#colorLiteral(red: 1, green: 0.645037046, blue: 0.3218522944, alpha: 1),#colorLiteral(red: 1, green: 0.5021148739, blue: 0.1159516494, alpha: 1)]
}

// Extension on view controller to perfom generic actions
extension UIViewController {
    func presentGenericError() {
        presentAlert(title: AppConfig.genericErrorTitle, message: AppConfig.genericErrorMessage)
    }
    
    func presentGenericError(tryAgain: UIAlertAction) {
        let alert = UIAlertController(title: AppConfig.genericErrorTitle,
                                      message: AppConfig.genericErrorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(tryAgain)
        present(alert, animated: true, completion: nil)
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// Loading view with blur effect
class LoadingView {
    /// Static function to present a loading/spinner view when purchasing is in progress
    static func showLoadingView() {
        removeLoadingView()
        let mainView = UIView(frame: UIScreen.main.bounds)
        mainView.backgroundColor = .clear
        let spinnerView = UIActivityIndicatorView(style: .white)
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.frame = UIScreen.main.bounds
        mainView.addSubview(blurView)
        mainView.addSubview(spinnerView)
        spinnerView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        spinnerView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        spinnerView.startAnimating()
        mainView.tag = 1991
        DispatchQueue.main.async {
            (UIApplication.shared.delegate as? AppDelegate)?.window?.addSubview(mainView)
        }
    }
    
    /// Static function to remove the loading/spinner view
    static func removeLoadingView() {
        DispatchQueue.main.async {
            (UIApplication.shared.delegate as? AppDelegate)?.window?.viewWithTag(1991)?.removeFromSuperview()
        }
    }
}

/// This is an extension on Double to format the numbers showing 'K' , 'M', 'B'
extension Double {
    var formattedFollow: String {
        if self > 999999999 {
            return String(format: "%.1fB", locale: Locale.current, self/1000000000).replacingOccurrences(of: ".0", with: "")
        }
        if self > 999999 {
            return String(format: "%.1fM", locale: Locale.current, self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        return String(format: "%.0f", locale: Locale.current, self)
    }
    
    var formattedLikeComment: String {
        return String(format: "%.0f", locale: Locale.current, self)
    }
}


// MARK: SwiftyStoreKit

extension SwiftyStoreKit {
    
    class func subscriptionPeriodUnit(from subscriptionPeriod: SKProductSubscriptionPeriod) -> String? {
        
        let dateComponents: DateComponents
        
        switch subscriptionPeriod.unit {
        case .day: dateComponents = DateComponents(day: subscriptionPeriod.numberOfUnits)
        case .week: dateComponents = DateComponents(weekOfMonth: subscriptionPeriod.numberOfUnits)
        case .month: dateComponents = DateComponents(month: subscriptionPeriod.numberOfUnits)
        case .year: dateComponents = DateComponents(year: subscriptionPeriod.numberOfUnits)
        @unknown default:
            dateComponents = DateComponents(month: subscriptionPeriod.numberOfUnits)
        }

        return DateComponentsFormatter.localizedString(from: dateComponents, unitsStyle: .full)?.letters
    }
    
    class func verifySubscription(with productID: String, completion: @escaping (Bool) -> Void) {

        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: AppConfig.sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            
            if case .success(let receipt) = result {
                
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable,
                    productId: productID,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(_, _):
                    Settings.shared.isPremium = true
                    Settings.shared.premiumID = productID
                    completion(true)
                case .expired(_, _):
                    Settings.shared.isPremium = false
                    completion(false)
                case .notPurchased:
                    Settings.shared.isPremium = false
                    completion(false)
                }

            }
            
        }
        
    }
    
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

// MARK: DispatchQueue

extension DispatchQueue {
    private static var _onceTracker = [String]()
    class func once(file: String = #file, function: String = #function, line: Int = #line, block:()->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}

//MARK: String

extension String {
    
    var letters: String {
        return String(unicodeScalars.filter(CharacterSet.letters.contains))
    }
    
}

// MARK: BLTNItemManager

extension BLTNItemManager {

    class func showAlert(title: String?, description: String?, buttonTitle: String?, image: UIImage? = nil, in vc: UIViewController, actionHandler: ((BLTNActionItem) -> Void)? = nil) {
              
        var bulletinManager = BLTNItemManager(rootItem: BLTNItem())
        
        let page = BLTNPageItem(title: title ?? "")

        page.isDismissable = true
        
        page.descriptionText = description
        page.actionButtonTitle = buttonTitle
        
        if let safeImage = image {
            page.image = safeImage
        }
        
        let tintColor: UIColor = Settings.shared.mainColor
        
        page.appearance.actionButtonColor = tintColor
        page.appearance.imageViewTintColor = tintColor
                
        page.actionHandler = { item in
            if let safeActionHandler = actionHandler {
                safeActionHandler(item)
            } else {
                DispatchQueue.main.async {
                    bulletinManager.dismissBulletin(animated: true)
                }
            }
        }
        
        bulletinManager = BLTNItemManager(rootItem: page)
        
        if #available(iOS 13.0, *) {
            bulletinManager.backgroundColor = .tertiarySystemBackground
        } else {
            bulletinManager.backgroundColor = .white
        }
        
        bulletinManager.showBulletin(above: vc, animated: true)
        UIImpactFeedbackGenerator.tapticFeedback()
        
    }
    
}

// MARK: UIViewController

extension UIViewController {
    
    func setAsRoot() {
        UIApplication.shared.windows.first?.rootViewController = self
    }
    
}

// MARK: UIScrollView

extension UIScrollView {

    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: true)
    }
}

// MARK: UISearchController

extension UISearchController {
    var hairlineView: UIView? {
        let barBackgroundView = searchBar.superview?.subviews.first { String(describing: type(of: $0)) == "_UIBarBackground" }
        
        guard let background = barBackgroundView else { return nil }
        return background.subviews.first { $0.bounds.height == 1 / self.traitCollection.displayScale }
    }
}

// MARK: UIImpactFeedbackGenerator

extension UIImpactFeedbackGenerator {

    class func tapticFeedback() {
        
        if Settings.shared.tapticEngine {
            UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle(rawValue: Settings.shared.tapticStyle) ?? .light).impactOccurred()
        }
                
    }
    
    class func tapticErrorFeedback() {
        
        if Settings.shared.tapticEngine {
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
        }
        
    }
    
}

// MARK: UIColor

extension UIColor {
    
    static let customOrange: UIColor = .systemOrange
    static let customGreen: UIColor  = .systemGreen
    static let customRed: UIColor    = .systemRed
    static let customPink: UIColor   = .systemPink
    static let customPurple: UIColor = hexStringToUIColor(hex: "5856D6")
    static let customYellow: UIColor = .systemYellow
    static let customBlue: UIColor   = hexStringToUIColor(hex: "0091FF")

    class func hexStringToUIColor (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red:   CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue:  CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
    }
    
    class func colorWithGradient(gradientColors: [UIColor], with frame: CGRect) -> UIColor {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.type = .axial
        
        gradientLayer.frame = frame

        var cgColors: [CGColor] = []

        for color in gradientColors.reversed() {
            cgColors.append(color.cgColor)
        }

        gradientLayer.colors = cgColors
        
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.locations = [0, 1]

        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, false, 0)

        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)

        guard let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
        else {return UIColor()}

        UIGraphicsEndImageContext()

        return UIColor(patternImage: backgroundColorImage)
        
    }
    
    func encode() -> Data? {
         return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
    
    func getGradientColors() -> [CGColor] {
                
        guard let components = self.cgColor.components, components.count >= 3
        else {return [self.cgColor, self.cgColor]}

        let topColor = UIColor(red:   components[0],
                               green: components[1] + 0.2,
                               blue:  components[2],
                               alpha: 1)
        
        return [topColor.cgColor, self.cgColor]
    }
    
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
    
}


// MARK: UserDefaults

extension UserDefaults {
    
  func colorForKey(key: String) -> UIColor? {
    
    var colorReturnded: UIColor?
    
    if let colorData = data(forKey: key) {
      do {
        if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
          colorReturnded = color
        }
      } catch {
        print("Error UserDefaults")
      }
    }
    
    return colorReturnded
    
  }
  
  func setColor(color: UIColor?, forKey key: String) {
    
    var colorData: Data?
    
    if let color = color {
      do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as Data?
        colorData = data
      } catch {
        print("Error UserDefaults")
      }
    }
    
    set(colorData, forKey: key)
    synchronize()
    
  }
    
}

// MARK: MFMailComposeViewController

extension MFMailComposeViewController {
    
    class func defaultFeedbackMail() -> MFMailComposeViewController {
        
        let mail = MFMailComposeViewController()
                
        let deviceModel = UIDevice.current.model
        let systemVersion = UIDevice.current.systemVersion
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName")
        
        let message = "\n\n\n\n\n\nDevice: \(deviceModel)\niOS: \(systemVersion)\nApp Version: \(appVersion ?? "")"
        
        mail.setMessageBody(message, isHTML: false)
        mail.setSubject(appName as! String)
        mail.setToRecipients([""])
        
        return mail
        
    }
    
}

// MARK: String

extension String {
    func indexOf(char: Character) -> Int? {
        return lastIndex(of: char)?.utf16Offset(in: self)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

//MARK: UserDefaults

extension UserDefaults {
    
  func color(for key: String) -> UIColor? {
    
    var colorReturnded: UIColor?
    
    if let colorData = data(forKey: key) {
      do {
        if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
          colorReturnded = color
        }
      } catch {
        print("Error UserDefaults")
      }
    }
    
    return colorReturnded
    
  }
  
  func set(color: UIColor?, forKey key: String) {
    
    var colorData: Data?
    
    if let color = color {
      do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as Data?
        colorData = data
      } catch {
        print("Error UserDefaults")
      }
    }
    
    set(colorData, forKey: key)
    synchronize()
    
  }
    
}

// MARK: Date

extension Date {

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday:     Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow:  Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
    
    static func date(_ date: Date?, isBetweenDate beginDate: Date?, andDate endDate: Date?) -> Bool {
        
        if let beginDate = beginDate {
            if date?.compare(beginDate) == .orderedAscending {
                return false
            }
        }
    
        if let endDate = endDate {
            if date?.compare(endDate) == .orderedDescending {
                return false
            }
        }
    
        return true
    }
    
    func dateByAddingMinutes(_ minutes: Int) -> Date {
        
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .minute, value: minutes, to: self)!
        
        return date
    }
    
}

//MARK: URL

extension URL {
    
    func openURL(completionHandler completion: ((Bool) -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.shared.open(self, options: [:]) { (success) in
                completion?(success)
            }
        }
    }
    
}

// MARK: UIViewController

extension UIViewController {
    
    var navBarHeight: CGFloat {
        return (UIApplication.shared.statusBarFrame.size.height) +
            (self.navigationController?.navigationBar.frame.size.height ?? 0.0)
    }
    
}
