//
//  SwiftyStoreKitOperations.swift
//  SwiftyStoreKitOperations
//
//  Created by Tuna Öztürk on 17.08.2021.
//

import Foundation
import SwiftyStoreKit
import UIKit


var priceMonthly = String()
var priceAnnual = String()



let monthlyProductID = "unlock.tiksaver.monthly"
let annualProductID = "unlock.tiksaver.annual"



class StoreKitOperations{

    let sharedSecret = "8bff400a74044f2ca88105a700bd5c7b"
    
    
func configureStoreKit(){
    // see notes below for the meaning of Atomic / Non-Atomic
    SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
        for purchase in purchases {
            switch purchase.transaction.transactionState {
            case .purchased, .restored:
                if purchase.needsFinishTransaction {
                    // Deliver content from server, then:
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                // Unlock content
            case .failed, .purchasing, .deferred:
                break // do nothing
            }
        }
    }
}

    func retriveProductInfo(productID : String){
        

        
        SwiftyStoreKit.retrieveProductsInfo([productID]) { result in
            if let product = result.retrievedProducts.first {
                let price = product.localizedPrice
               
                switch productID {
                    
                case monthlyProductID:
                    
                    priceMonthly = price!
                    uDefaults.setValue(priceMonthly, forKey: "priceMonthly")
                    
                case annualProductID:
                    
                    priceAnnual = price!
                    uDefaults.setValue(priceAnnual, forKey: "priceAnnual")
                    
                default:
                    
                    break
                }
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
              
            }
            else {
                print("Error: \(result.error)")
             
            }
        }
        
     
        
    }
    
    func setPrices(){

       
        
        retriveProductInfo(productID: monthlyProductID)
        retriveProductInfo(productID: annualProductID)
        
    }
    
   
   
    
    
    func purchaseProduct(productID : String, viewController : UIViewController){
      
        vibrate(style: .medium)
        let view_loading = create_loading_view(view: viewController.view)
        viewController.view.addSubview(view_loading)
        
        SwiftyStoreKit.purchaseProduct(productID, quantity: 1, atomically: true) { result in
            
            view_loading.removeFromSuperview()
            
            switch result {
            case .success(let purchase):
                
                print("Purchase Success: \(purchase.productId)")
                isUserPremium = true
                uDefaults.setValue(true, forKey: "isUserPremium")
                
               
                let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let VC1 = board.instantiateViewController(withIdentifier: "RepostVC") as! RepostController
                viewController.present(VC1, animated:true, completion: nil)
                
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
        
    }
    
    func restorePurchase(viewController : UIViewController){
        
        vibrate(style: .medium)
        let view_loading = create_loading_view(view: viewController.view)
        viewController.view.addSubview(view_loading)
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            
            view_loading.removeFromSuperview()
            
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                
                showAlert(title: NSLocalizedString("Can't Restored!", comment: ""), message: NSLocalizedString("Oh no!. We couldn't find any subscriptions in your account.", comment: ""), viewController: viewController)
                
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                
                isUserPremium = true
           
                uDefaults.setValue(true, forKey: "isUserPremium")
                let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let VC1 = board.instantiateViewController(withIdentifier: "RepostVC") as! RepostController
                viewController.self.present(VC1, animated:true, completion: nil)
                
                
            }
            else {
                print("Nothing to Restore")
                
                view_loading.removeFromSuperview()
                showAlert(title: NSLocalizedString("Can't Restored!", comment: ""), message: NSLocalizedString("Oh no!. We couldn't find any subscriptions in your account.", comment: ""), viewController: viewController)
                
            }
        }

        
        
    }
    
    func verifySubscription(){
        
        
        var allProducts = [String]()
        
        
        allProducts.append(monthlyProductID)
        allProducts.append(annualProductID)
        
        for productID in allProducts{
            
            if productID != ""{
                
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
              
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productID,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productID) is valid until \(expiryDate)\n\(items)\n")
                    isUserPremium = true
                    uDefaults.setValue(true, forKey: "isUserPremium")
                case .expired(let expiryDate, let items):
                    print("\(productID) is expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    print("The user has never purchased \(productID)")
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
        
    }
    
        }
        
        
    }
    
    
   


}

