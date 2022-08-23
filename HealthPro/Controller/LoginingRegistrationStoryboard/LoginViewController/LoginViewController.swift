//
//  LoginViewController.swift
//  HealthPro
//
//  Created by User on 8/3/22.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: Properties
    
    private let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
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
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginButton.layer.cornerRadius = 13
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
            if let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "MainPageVC") as? MainPageViewController {
                present(mainVC, animated: true, completion: nil)
                
            }
            
        } else {
            invalidLoginDataAlert()
        }
    }
    
    @IBAction private func forgotPassword(_ sender: Any) {
        
    }
}
