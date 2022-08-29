//
//  LoginViewController.swift
//  HealthPro
//
//  Created by User on 8/3/22.
//
import RealmSwift
import UIKit

final class LoginViewController: UIViewController {
    
    // swiftlint:disable force_try
    
    // MARK: Outlets
    
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: Properties
        
    private let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private let mainTabBarStoryboard: UIStoryboard = UIStoryboard(name: "MainTabBar", bundle: nil)
    private let homeStoryboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
    
    private func oopsAlert() {
        let alert = UIAlertController(title: "Oops\n Something wrong!", message: "Try to input data againg!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func invalidLoginDataAlert() {
        let alert = UIAlertController(title: "Oops\n Something wrong!", message: "Invalid login or password!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    }
    
    func setTextFieldsProperies() {
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        userNameTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderWidth = 0.5
        
        userNameTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
        
        userNameTextField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        passwordTextField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        
    }
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTextFieldsProperies()
        
       loginButton.layer.cornerRadius = 13
    }
    
    // MARK: Actions
    
    @IBAction private func backToStartPageButton(_ sender: Any) {
        if let startVC = mainStoryBoard.instantiateViewController(withIdentifier: "StartVC") as? StartViewController {
            present(startVC, animated: false, completion: nil)
        }
    }
    
    @IBAction private func loginButton(_ sender: Any) {
        guard userNameTextField.hasText,
              passwordTextField.hasText,
              userNameTextField.text?.contains("#@$^&*()?!§±№;%><=+") == false,
              passwordTextField.text?.contains("#@$^&*()?!§±№;%><=+") == false
        
        else { return self.oopsAlert() }
        
        if UsersData.userDefault.dictionary(forKey: "\(userNameTextField.text!)") as? Dictionary == ["\(userNameTextField.text!)": "\(passwordTextField.text!)"] {
            if let mainVC = mainTabBarStoryboard.instantiateViewController(withIdentifier: "mainTabBarVC") as? MainTabBarViewController {
                if let homeVC = mainVC.viewControllers?.first as? HomePageViewController {
                    homeVC.userName = userNameTextField.text!
                }
                
                UsersData.userDefault.set("\(userNameTextField.text ?? "User")", forKey: "currentUser")
                UsersData.userDefault.synchronize()
                
                UsersData.userDefault.set(true, forKey: "isLoggedIn")
                UsersData.userDefault.synchronize()
                
                present(mainVC, animated: true, completion: nil)
                
                
            }
        } else {
            invalidLoginDataAlert()
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.5589081985, green: 0.7141136811, blue: 0.9897997975, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)

    }
}
