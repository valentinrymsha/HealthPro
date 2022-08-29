//
//  AccountViewController.swift
//  HealthPro
//
//  Created by User on 8/29/22.
//

import UIKit
import RealmSwift

class AccountViewController: UIViewController {

    // swiftlint:disable force_try
    
    // MARK: Outlets
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    // MARK: Properties
    
    
    
    // MARK: Lifecirlce
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            accountImageView.isUserInteractionEnabled = true
            accountImageView.addGestureRecognizer(tapGestureRecognizer)
        
        accountImageView.image =  UIImage(data: UsersData.userDefault.data(forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user") ?? Data())
        
        accountImageView.layer.cornerRadius = accountImageView.frame.width / 2
        userNameLabel.text = UsersData.userDefault.string(forKey: "currentUser") ?? "User"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        accountImageView.image =  UIImage(data: UsersData.userDefault.data(forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user") ?? Data())

    }
    
    // MARK: Actions
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {

        let imageVC = UIImagePickerController()
        imageVC.sourceType = .photoLibrary
        imageVC.delegate = self
        imageVC.allowsEditing = true
        
        present(imageVC, animated: true)
        // Your action
    }
}

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            let data = image.pngData()
            UsersData.userDefault.set(data, forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user")
            
            accountImageView.image = image
            accountImageView.contentMode = .scaleAspectFill
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

