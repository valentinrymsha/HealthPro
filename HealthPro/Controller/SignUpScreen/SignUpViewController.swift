//
//  SigninViewController.swift
//  HealthPro
//
//  Created by User on 8/3/22.
//

import RealmSwift
import UIKit

final class SignUpViewController: UIViewController {

    // swiftlint:disable force_try
    
    // MARK: Outlets
    
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var repeatedPasswordTextField: UITextField!
    @IBOutlet private weak var repeatedPasswordImage: UIImageView!
    
    // MARK: Properties
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    private let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private let mainTabBarStoryboard: UIStoryboard = UIStoryboard(name: "MainTabBar", bundle: nil)
    private let homeStoryboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
    
    private let userRealm = UserModel()
    private let realm = try! Realm()
    
        
    func clearBackgroundColor(of view: UIView) {
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
        let alert = UIAlertController(title: "Oops\n Something wrong!", message: "Try to input data againg!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        
        clearBackgroundColor(of: alert.view)
        
        alert.view.layer.backgroundColor =  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7).cgColor
        alert.view.layer.cornerRadius = 10
        
        present(alert, animated: true, completion: nil)
    }
    
    private func duplicateAccountAlert() {
        let alert = UIAlertController(title: "Account with this nickname already exist!", message: "Choose another nickname!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        clearBackgroundColor(of: alert.view)
        
        alert.view.layer.backgroundColor =  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7).cgColor
        alert.view.layer.cornerRadius = 10
        
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    }
    
    private func setTextFieldsProperies() {
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        repeatedPasswordTextField.delegate = self
        
        userNameTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderWidth = 0.5
        repeatedPasswordTextField.layer.borderWidth = 0.5
        
        userNameTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        repeatedPasswordImage.layer.cornerRadius = 5
        
        userNameTextField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        passwordTextField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        repeatedPasswordTextField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        
    }
    
    // MARK: LifeCircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldsProperies()
        
        submitButton.layer.cornerRadius = 13
        
        userNotificationCenter.delegate = self
    }
    
    // MARK: Actions
    
    @IBAction private func backToStartPageButton(_ sender: Any) {
        if let startVC = mainStoryBoard.instantiateViewController(withIdentifier: "StartVC") as? StartViewController {
            present(startVC, animated: false, completion: nil)
        }
    }
    
    @IBAction private func submitButton(_ sender: Any) {
        guard userNameTextField.hasText,
              passwordTextField.hasText,
              repeatedPasswordTextField.hasText
        else { return oopsAlert() }
        
        guard userNameTextField.text!.trimmingCharacters(in: .whitespaces).count <= 10,
              userNameTextField.text!.trimmingCharacters(in: .whitespaces).count >= 3,
              passwordTextField.text!.trimmingCharacters(in: .whitespaces).count <= 12,
              passwordTextField.text!.trimmingCharacters(in: .whitespaces).count >= 5,
              repeatedPasswordTextField.text!.trimmingCharacters(in: .whitespaces).count <= 12,
              repeatedPasswordTextField.text!.trimmingCharacters(in: .whitespaces).count >= 5
        else { return oopsAlert() }
        
        userNameTextField.text!.forEach {
            if "#@$^&*()?!§±№;%><=+".contains($0) {
                oopsAlert()
            }
        }
        passwordTextField.text!.forEach {
            if "#@$^&*()?!§±№;%><=+".contains($0) {
                oopsAlert()
            }
        }
           
        if let mainVC = mainTabBarStoryboard.instantiateViewController(withIdentifier: "mainTabBarVC") as? MainTabBarViewController {
        guard userNameTextField.text!.trimmingCharacters(in: .whitespaces) != realm.object(ofType: UserModel.self, forPrimaryKey: "\(userNameTextField.text!.trimmingCharacters(in: .whitespaces))")?.userName  else { return duplicateAccountAlert() }
            
            if passwordTextField.text!.trimmingCharacters(in: .whitespaces) == repeatedPasswordTextField.text!.trimmingCharacters(in: .whitespaces) {
                
                userRealm.userName = userNameTextField.text!.trimmingCharacters(in: .whitespaces)
                userRealm.userPassword = passwordTextField.text!.trimmingCharacters(in: .whitespaces)
                userRealm.isLoggined = true
                
                try! realm.write {
                realm.add(userRealm)
                }

            } else {
                oopsAlert()
            }
            if let homeVC = mainVC.viewControllers?.first as? HomePageViewController {
                homeVC.userName = userNameTextField.text!.trimmingCharacters(in: .whitespaces)
            }
            
            
            UsersData.userDefault.set("\(userNameTextField.text!.trimmingCharacters(in: .whitespaces))", forKey: "currentUser")
            UsersData.userDefault.synchronize()
            
            PushNotification.pushNote("Congrats with a new account <3", 3)
            
            present(mainVC, animated: true, completion: nil)
            
        }
    }
}

// MARK: UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.5589081985, green: 0.7141136811, blue: 0.9897997975, alpha: 1)
        textField.layer.borderWidth = 1.2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)

    }
}

// MARK: UNUserNotificationCenterDelegate

extension SignUpViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .badge, .sound])
    }
    
   
}
