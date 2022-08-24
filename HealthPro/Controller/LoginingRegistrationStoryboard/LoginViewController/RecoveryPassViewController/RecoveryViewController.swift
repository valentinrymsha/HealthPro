//
//  RecoveryViewController.swift
//  HealthPro
//
//  Created by User on 8/24/22.
//

import UIKit

class RecoveryViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var yourPasswordLabel: UILabel!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    // MARK: Properties
    
    var password = String()
    
    // MARK: Lifecirle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showPasswordButton.layer.cornerRadius = 13
    }
    
    // MARK: Actions
    
    
    @IBAction func showPasswordButton(_ sender: UIButton) {
        if let text = UsersData.userDefault.dictionary(forKey: "\(loginTextField.text!)")?.values.first as? String {
            yourPasswordLabel.text = "Your password is:\n" + "'\(text)'"
        } else {
            yourPasswordLabel.text = "You have not account yet"
        }
    }
    
}
