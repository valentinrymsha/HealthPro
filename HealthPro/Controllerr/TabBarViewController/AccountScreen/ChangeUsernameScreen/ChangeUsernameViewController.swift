//
//  ChangeUsernameViewController.swift
//  HealthPro
//
//  Created by User on 8/31/22.
//

import UIKit

class ChangeUsernameViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private  weak var changeUsernameTextField: UITextField!
    
    // MARK: Properties
    
    private let mainTabBarStoryboard: UIStoryboard = UIStoryboard(name: "MainTabBar", bundle: nil)
    private var dict: [String: Any]?
    
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
        let alert = UIAlertController(title: "Oops\n Something wrong!", message: "Try to input data againg!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
        
        clearBackgroundColor(of: alert.view)
        
        alert.view.layer.backgroundColor =  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7).cgColor
        alert.view.layer.cornerRadius = 10
        
        present(alert, animated: true, completion: nil)
    }
    
    private func duplicateAccountAlert() {
        let alert = UIAlertController(title: "This username already exist!", message: "Choose another username!", preferredStyle: .alert)
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
        changeUsernameTextField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        changeUsernameTextField.layer.borderWidth = 0.5
        changeUsernameTextField.layer.cornerRadius = 5
    }
    
    // MARK: Actions
    
    @IBAction func submitButton(_ sender: UIButton) {
//        guard changeUsernameTextField.hasText,
//              changeUsernameTextField.text!.count <= 10,
//              changeUsernameTextField.text!.count >= 3
//        else { return oopsAlert() }
//
//        changeUsernameTextField.text!.forEach{
//            if "#@$^&*()?!§±№;%><=+".contains($0) {
//                oopsAlert()
//            }
//        }
//
//        if let mainVC = mainTabBarStoryboard.instantiateViewController(withIdentifier: "mainTabBarVC") as? MainTabBarViewController {
//            guard changeUsernameTextField.text! != UsersData.userDefault.dictionary(forKey: "\(changeUsernameTextField.text!)")?.keys.first else { return duplicateAccountAlert() }
//
//            if let homeVC = mainVC.viewControllers?.first as? HomePageViewController {
//                homeVC.userName = changeUsernameTextField.text!
//            }
//            if let accountVC = mainVC.viewControllers?.last as? AccountViewController {
//                if UIImage(data: UsersData.userDefault.data(forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user") ?? Data()) == UIImage(data: Data()) {
//                    accountVC.accountImageView.image = UIImage(named: "user-4")
//                } else {
//                    accountVC.accountImageView.image =  UIImage(data: UsersData.userDefault.data(forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user") ?? Data() )
//                }
//            }
//
//            UsersData.userDefault.set("\(self.changeUsernameTextField.text!)", forKey: "currentUser")
//            UsersData.userDefault.synchronize()
//
//            changeUsernameTextField.text! = ""
//        }
//
//    }
    }
}

extension ChangeUsernameViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.5589081985, green: 0.7141136811, blue: 0.9897997975, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)

    }
}

extension Dictionary {
    mutating func switchKey(fromKey: Key, toKey: Key) {
        if let entry = removeValue(forKey: fromKey) {
            self[toKey] = entry
        }
    }
}
