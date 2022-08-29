//
//  RecoveryViewController.swift
//  HealthPro
//
//  Created by User on 8/24/22.
//

import UIKit

final class RecoveryViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var yourPasswordLabel: UILabel!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    // MARK: Properties
    
    var password = String()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    }
    
    func setTextFieldsProperies() {
        
        loginTextField.delegate = self

        loginTextField.layer.borderWidth = 0.5

        loginTextField.layer.cornerRadius = 5
        
        loginTextField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        
    }
    
    // MARK: Lifecirle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTextFieldsProperies()
        
        showPasswordButton.layer.cornerRadius = 13
    }
    
    // MARK: Actions
    
    
    @IBAction func showPasswordButton(_ sender: UIButton) {
        if let text = UsersData.userDefault.dictionary(forKey: "\(loginTextField.text!)")?.values.first as? String {
            yourPasswordLabel.text = "Your password is:\n" + "'\(text)'"
        } else {
            yourPasswordLabel.text = "You have not account yet"
        }
        loginTextField.text = ""
    }
    
}

extension RecoveryViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.5589081985, green: 0.7141136811, blue: 0.9897997975, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)

    }
}
