//
//  AccountViewController.swift
//  HealthPro
//
//  Created by User on 8/29/22.
//

import UIKit

class AccountViewController: UIViewController {

    // swiftlint:disable force_try
    
    // MARK: Outlets
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var changeUserNameButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var faqButton: UIButton!
    
    // MARK: Properties

    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    private func buttonConfig(_ button: UIButton) {
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.6765247583, green: 0.8675484657, blue: 0.7702565789, alpha: 1).withAlphaComponent(0.6)
        button.isUserInteractionEnabled = true
        button.isEnabled = true
    }
    
    // MARK: Lifecirlce
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonConfig(changeUserNameButton)
        buttonConfig(logoutButton)
        buttonConfig(faqButton)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            accountImageView.isUserInteractionEnabled = true
            accountImageView.addGestureRecognizer(tapGestureRecognizer)
        
        if UIImage(data: UsersData.userDefault.data(forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user") ?? Data()) == UIImage(data: Data()) {
            accountImageView.image = UIImage(named: "user-4")
        } else {
        accountImageView.image =  UIImage(data: UsersData.userDefault.data(forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user") ?? Data() )
        }
        
        accountImageView.layer.cornerRadius = accountImageView.frame.width / 2
        userNameLabel.text = UsersData.userDefault.string(forKey: "currentUser") ?? "User"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIImage(data: UsersData.userDefault.data(forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user") ?? Data()) == UIImage(data: Data()) {
            accountImageView.image = UIImage(named: "user-4")
        } else {
        accountImageView.image =  UIImage(data: UsersData.userDefault.data(forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user") ?? Data() )
        }

    }
    
    // MARK: Actions
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {

        // Create the AlertController
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // Create and add the Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSheetController.dismiss(animated: true, completion: nil)  }
        actionSheetController.addAction(cancelAction)

        // Create and add first option action
        let setPictureAction = UIAlertAction(title: "Set photo from gallery", style: .default) { action -> Void in
            let imageVC = UIImagePickerController()
            imageVC.sourceType = .photoLibrary
            imageVC.delegate = self
            imageVC.allowsEditing = true
            
            self.present(imageVC, animated: true)
        }
        actionSheetController.addAction(setPictureAction)

        let setPictureFromCameraAction = UIAlertAction(title: "Set photo from camera", style: .default) { action -> Void in
            let imageVC = UIImagePickerController()
            
            imageVC.sourceType = .camera
            
            imageVC.delegate = self
            imageVC.allowsEditing = true
            
            self.present(imageVC, animated: true)
        }
        actionSheetController.addAction(setPictureFromCameraAction)
        
        let deletePhotoAction = UIAlertAction(title: "Delete current photo", style: .default) { action -> Void in
            let defaultImage = UIImage(named: "user-4")
            let defaultImageData = defaultImage?.pngData()
            UsersData.userDefault.set(defaultImageData, forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user")
            UsersData.userDefault.synchronize()
            self.accountImageView.image = defaultImage
            self.accountImageView.contentMode = .center
        }
        actionSheetController.addAction(deletePhotoAction)
        
        
        self.present(actionSheetController, animated: true, completion: nil)

    }
    
    @IBAction func didTappedChangeUsernameButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func didTappedLogoutButton(_ sender: UIButton) {
        
        guard let startVC = mainStoryboard.instantiateViewController(identifier: "StartVC") as? StartViewController else { return }
        
        UsersData.userDefault.set(false, forKey: "isLoggedIn")
        UsersData.userDefault.synchronize()
        
        present(startVC, animated: false, completion: nil)
        
    }
    
    
}

// MARK: ImagePickerViewDelegate, NavigationDelegate

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            let data = image.pngData()
            UsersData.userDefault.set(data, forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user")
            UsersData.userDefault.synchronize()
            
            accountImageView.image = image
            accountImageView.contentMode = .scaleAspectFill
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

