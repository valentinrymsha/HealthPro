//
//  RecoveryViewController.swift
//  HealthPro
//
//  Created by User on 8/24/22.
//

import UIKit
import RealmSwift

final class RecoveryViewController: UIViewController {

    // swiftlint:disable force_try
    
    // MARK: Outlets
    
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var yourPasswordLabel: UILabel!
    @IBOutlet private weak var showPasswordButton: UIButton!
    
    // MARK: Properties
    
    var password = String()
    private let realm = try! Realm()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    }
    
    private func setTextFieldsProperies() {
        
        loginTextField.delegate = self

        loginTextField.layer.borderWidth = 0.5

        loginTextField.layer.cornerRadius = 5
        
        loginTextField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        
    }
    
    private func oopsAlert() {
        let alert = UIAlertController(title: "Oops\n Something wrong!", message: "Try to input data againg!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        
        alert.view.layer.backgroundColor =  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7).cgColor
        alert.view.layer.cornerRadius = 10
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Lifecirle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTextFieldsProperies()
        
        showPasswordButton.layer.cornerRadius = 13
    }
    
    // MARK: Actions
    
    
    @IBAction private func showPasswordButton(_ sender: UIButton) {
        guard loginTextField.hasText else { return oopsAlert() }
        
        let user = realm.object(ofType: UserModel.self, forPrimaryKey: "\(loginTextField.text!)")
        if let text = user?.userName {
            yourPasswordLabel.text = "Your password is:\n" + "'\(text)'"
        } else {
            yourPasswordLabel.text = "You have not account yet"
        }
        loginTextField.text = ""
    }
    
}

// MARK: UITextFieldDelegate

extension RecoveryViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.5589081985, green: 0.7141136811, blue: 0.9897997975, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)

    }
}
