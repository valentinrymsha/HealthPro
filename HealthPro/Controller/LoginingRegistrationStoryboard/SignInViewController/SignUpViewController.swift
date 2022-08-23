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
    
    private let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    private func oopsAlert() {
        let alert = UIAlertController(title: "Oops\n Something wrong!", message: "Try to input data againg!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
//    private func forgotPassAlert() {
//        let alert = UIAlertController(title: "Forgot your password?", message: "Write your login here", preferredStyle: .actionSheet)
//        alert.addTextField(configurationHandler: .none)
//        alert.addAction(UIAlertAction(title: "Represent password", style: .default, handler: nil))
//    }
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.layer.cornerRadius = 13
    }
    
    // MARK: Actions
    
    @IBAction private func backToStartPageButton(_ sender: Any) {
        if let startVC = mainStoryBoard.instantiateViewController(withIdentifier: "StartVC") as? StartViewController {
            present(startVC, animated: false, completion: nil)
        }
    }
    
    @IBAction private func submitButton(_ sender: Any) {
        if !self.userNameTextField.hasText || self.userNameTextField.text?.count ?? 0 >= 10 ||
            self.userNameTextField.text?.count ?? 0 < 3 {
            oopsAlert()
        } else if !self.passwordTextField.hasText || self.passwordTextField.text?.count ?? 0 >= 15 ||
            self.passwordTextField.text?.count ?? 0 < 5
        {
            oopsAlert()
        } else if let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "MainPageVC") as? MainPageViewController {
            
            guard userNameTextField.hasText,        passwordTextField.hasText,
                  repeatedPasswordTextField.text == passwordTextField.text
            else { return oopsAlert() }
            UsersData.userDefault.setValue(["\(userNameTextField.text!)": "\(passwordTextField.text!)"], forKey: "\(userNameTextField.text!)")
            present(mainVC, animated: true, completion: nil)
            
        }
    }
    
    
    // MARK: Logic
    
    
    
    
}
