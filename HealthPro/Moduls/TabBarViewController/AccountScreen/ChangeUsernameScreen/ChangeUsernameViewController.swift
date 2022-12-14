//
//  ChangeUsernameViewController.swift
//  HealthPro
//
//  Created by User on 8/31/22.
//

import RealmSwift
import UIKit

final class ChangeUsernameViewController: UIViewController {

    // swiftlint:disable force_try
    
    // MARK: Outlets
    
    @IBOutlet private  weak var changePasswordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: Properties
    
    private let mainTabBarStoryboard: UIStoryboard = UIStoryboard(name: "MainTabBar", bundle: nil)
    private let realm = try! Realm()
    
    private func clearBackgroundColor(of view: UIView) {
        if let effectsView = view as? UIVisualEffectView {
            effectsView.removeFromSuperview()
            return
        }

        view.backgroundColor = .clear
        view.subviews.forEach { (subview) in
            clearBackgroundColor(of: subview)
        }
    }
    
    private func oopsAlert() {
        let alert = UIAlertController(title: "Oops\n Field should have minimum 5 simbols!", message: "Try to input data againg!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        
        clearBackgroundColor(of: alert.view)
        
        alert.view.layer.backgroundColor =  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7).cgColor
        alert.view.layer.cornerRadius = 10
        
        present(alert, animated: true, completion: nil)
    }
    
    private func invalidSimbolsAlert() {
        let alert = UIAlertController(title: "Oops\n Invalid simbols in the field!", message: "Try to input data againg!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        
        clearBackgroundColor(of: alert.view)
        
        alert.view.layer.backgroundColor =  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7).cgColor
        alert.view.layer.cornerRadius = 10
        
        present(alert, animated: true, completion: nil)
    }
    
    private func duplicateAccountAlert() {
        let alert = UIAlertController(title: "This password is a current pass for this account!", message: "Choose another password!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        clearBackgroundColor(of: alert.view)
        
        alert.view.layer.backgroundColor =  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7).cgColor
        alert.view.layer.cornerRadius = 10
        
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    }
    
    // MARK: Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        changeUsernameTextField.delegate = self
        changePasswordTextField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        changePasswordTextField.layer.borderWidth = 0.5
        changePasswordTextField.layer.cornerRadius = 5
        changePasswordTextField.delegate = self
        
        submitButton.layer.cornerRadius = 13
    }
    
    // MARK: Actions
    
    @IBAction func submitButton(_ sender: UIButton) {
        guard changePasswordTextField.hasText,
              changePasswordTextField.text!.count <= 12,
              changePasswordTextField.text!.count >= 5
        else { return oopsAlert() }

        changePasswordTextField.text!.forEach {
            if "#@$^&*()?!???????;%><=+".contains($0) {
                invalidSimbolsAlert()
            }
        }

        if let _ = mainTabBarStoryboard.instantiateViewController(withIdentifier: "mainTabBarVC") as? MainTabBarViewController {
            
            let user = realm.object(ofType: UserModel.self, forPrimaryKey: UsersData.userDefault.string(forKey: "currentUser")!)
            
            guard changePasswordTextField.text! != user!.userPassword else { return duplicateAccountAlert() }

            try! realm.write {
                user!.userPassword = changePasswordTextField.text!
            }
        }
        
        PushNotification.pushNote("You changed your password!", 3)
        changePasswordTextField.text = ""
    }
}

extension ChangeUsernameViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.5589081985, green: 0.7141136811, blue: 0.9897997975, alpha: 1)
        textField.layer.borderWidth = 1.2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)

    }
}
