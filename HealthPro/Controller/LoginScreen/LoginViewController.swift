//
//  LoginViewController.swift
//  HealthPro
//
//  Created by User on 8/3/22.
//
import UIKit
import RealmSwift

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
    private let realm = try! Realm()
    
    private func oopsAlert() {
        let alert = UIAlertController(title: "Oops\n Something wrong!", message: "Try to input data againg!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        
        clearBackgroundColor(of: alert.view)
        
        alert.view.layer.backgroundColor =  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7).cgColor
        alert.view.layer.cornerRadius = 10
        
        present(alert, animated: true, completion: nil)
    }
    
    private func invalidLoginDataAlert() {
        let alert = UIAlertController(title: "Oops\n Something wrong!", message: "Invalid password!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        
        clearBackgroundColor(of: alert.view)
        
        alert.view.layer.backgroundColor =  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7).cgColor
        alert.view.layer.cornerRadius = 10
        
        present(alert, animated: true, completion: nil)
    }
    
    private func notExistAccountAlert() {
        let alert = UIAlertController(title: "Oops\n Something wrong!", message: "Account with this loggin not exist!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        clearBackgroundColor(of: alert.view)
        
        alert.view.layer.backgroundColor =  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7).cgColor
        alert.view.layer.cornerRadius = 10
        
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
        
        let user = realm.object(ofType: UserModel.self, forPrimaryKey: "\(userNameTextField.text!)")
        
        guard user?.userName != nil else { return notExistAccountAlert() }
        
        if [user?.userName: user?.userPassword] as? Dictionary == ["\(userNameTextField.text!)": "\(passwordTextField.text!)"] {
            if let mainVC = mainTabBarStoryboard.instantiateViewController(withIdentifier: "mainTabBarVC") as? MainTabBarViewController {
                if let homeVC = mainVC.viewControllers?.first as? HomePageViewController {
                    homeVC.userName = userNameTextField.text!
                }
                
                UsersData.userDefault.set("\(userNameTextField.text!)", forKey: "currentUser")
                UsersData.userDefault.synchronize()
                
                try? realm.write {
                user?.isLoggined = true
                }
                
                PushNotification.pushNote("Nice to see you again, dude", 3)
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
