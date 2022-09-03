//
//  SigninViewController.swift
//  HealthPro
//
//  Created by User on 8/3/22.
//

import UIKit


final class SignUpViewController: UIViewController {

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
    
    // swiftlint:disable force_try
        
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
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldsProperies()
        
        submitButton.layer.cornerRadius = 13
        
        userNotificationCenter.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
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
        
        guard userNameTextField.text!.count <= 10,
              userNameTextField.text!.count >= 3,
              passwordTextField.text!.count <= 12,
              passwordTextField.text!.count >= 5,
              repeatedPasswordTextField.text!.count <= 12,
              repeatedPasswordTextField.text!.count >= 5
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
            guard userNameTextField.text! != UsersData.userDefault.dictionary(forKey: "\(userNameTextField.text!)")?.keys.first else { return duplicateAccountAlert() }
            
            if passwordTextField.text == repeatedPasswordTextField.text {
                UsersData.userDefault.setValue(["\(userNameTextField.text!)": "\(passwordTextField.text!)"], forKey: "\(userNameTextField.text!)")
            } else {
                oopsAlert()
            }
            if let homeVC = mainVC.viewControllers?.first as? HomePageViewController {
                homeVC.userName = userNameTextField.text!
            }
            
            
            UsersData.userDefault.set("\(userNameTextField.text ?? "User")", forKey: "currentUser")
            UsersData.userDefault.synchronize()
            
            UsersData.userDefault.set(true, forKey: "isLoggedIn")
            UsersData.userDefault.synchronize()
            
            PushNotification.pushNote("Congrats with a new account <3", 3)
            
            present(mainVC, animated: true, completion: nil)
            
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.5589081985, green: 0.7141136811, blue: 0.9897997975, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)

    }
}

extension SignUpViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .badge, .sound])
    }
    
   
}
