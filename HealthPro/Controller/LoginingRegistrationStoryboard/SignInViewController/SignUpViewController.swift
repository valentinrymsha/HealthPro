//
//  SigninViewController.swift
//  HealthPro
//
//  Created by User on 8/3/22.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Properties
    
    let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    func oopsAlert() {
        let alert = UIAlertController(title: "Oops\n Something wrong!", message: "Try to input data againg!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.layer.cornerRadius = 13
    }
    
    // MARK: Actions
    
    @IBAction func backToStartPageButton(_ sender: Any) {
        if let startVC = mainStoryBoard.instantiateViewController(withIdentifier: "StartVC") as? StartViewController {
            present(startVC, animated: false, completion: nil)
        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        if !self.userNameTextField.hasText || self.userNameTextField.text?.count ?? 0 >= 10 {
            oopsAlert()
        } else if !self.passwordTextField.hasText || self.passwordTextField.text?.count ?? 0 >= 15 {
            oopsAlert()
        } else if let mainVC = mainStoryBoard.instantiateViewController(withIdentifier: "MainPageVC") as? MainPageViewController {
            
            guard userNameTextField.hasText && passwordTextField.hasText else { return }
            UsersData.userDefault.setValue(["\(userNameTextField.text!)": "\(passwordTextField.text!)"], forKey: "\(userNameTextField.text!)")
            present(mainVC, animated: true, completion: nil)
            
        }
    }
    
    
    // MARK: Logic
    
  
    
    
}
