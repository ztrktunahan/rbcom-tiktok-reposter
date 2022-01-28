//
//  SearchUserController.swift
//  TikTokRepost
//
//  Created by Влад Лыков on 12.09.2021.
//

import UIKit

class SearchUserController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Settings.shared.username != nil,
           let vc = storyboard?.instantiateViewController(withIdentifier: "dashboard") {
            navigationController?.setViewControllers([vc], animated: false)
        }
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        
        if let username = textField.text, !username.isEmpty,
           let vc = storyboard?.instantiateViewController(withIdentifier: "dashboard") {
           Settings.shared.username = username
            navigationController?.setViewControllers([vc], animated: false)
        } else { presentAlert(title: "Invalid Username", message: "Your username is empty or invalid") }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
