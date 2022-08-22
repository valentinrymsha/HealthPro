//
//  LoginViewController.swift
//  HealthPro
//
//  Created by User on 8/3/22.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: Properties
    
    let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    func oopsAlert() {
        let alert = UIAlertController(title: "Oops\n Something wrong!", message: "Try to input data againg!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func invalidLoginDataAlert() {
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
    
    @IBAction func backToStartPageButton(_ sender: Any) {
        if let startVC = mainStoryBoard.instantiateViewController(withIdentifier: "StartVC") as? StartViewController {
            present(startVC, animated: false, completion: nil)
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard userNameTextField.hasText && passwordTextField.hasText else { return oopsAlert() }
        if UsersData.userDefault.dictionary(forKey: "\(userNameTextField.text!)") as? Dictionary == ["\(userNameTextField.text!)": "\(passwordTextField.text!)"] {
            if let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "MainPageVC") as? MainPageViewController {
                present(mainVC, animated: true, completion: nil)
                
            }
            
        } else {
            invalidLoginDataAlert()
        }
    }
}
