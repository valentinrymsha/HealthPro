//
//  AccountViewController.swift
//  HealthPro
//
//  Created by User on 8/29/22.
//

import UIKit
import YPImagePicker

class AccountViewController: UIViewController {
    
    // swiftlint:disable force_try
    
    // MARK: Outlets
    
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var changeUserNameButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var faqButton: UIButton!
    
    // MARK: Properties
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let mainTabBarStoryboard: UIStoryboard = UIStoryboard(name: "MainTabBar", bundle: nil)
    let changeStoryboard: UIStoryboard = UIStoryboard(name: "ChangeUsername", bundle: nil)
    let faqStoryboard: UIStoryboard = UIStoryboard(name: "FAQ", bundle: nil)
    
    private func buttonConfig(_ button: UIButton) {
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.6765247583, green: 0.8675484657, blue: 0.7702565789, alpha: 1).withAlphaComponent(1)
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
        
        DispatchQueue.main.async {
            self.userNameLabel.text = UsersData.userDefault.string(forKey: "currentUser") ?? "User"
        }
        
        userNotificationCenter.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UIImage(data: UsersData.userDefault.data(forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user") ?? Data()) == UIImage(data: Data()) {
            accountImageView.image = UIImage(named: "user-4")
        } else {
            accountImageView.image =  UIImage(data: UsersData.userDefault.data(forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user") ?? Data() )
        }
        
        userNameLabel.text = UsersData.userDefault.string(forKey: "currentUser") ?? "User"
        
    }
    
    // MARK: Actions
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSheetController.dismiss(animated: true, completion: nil)  }
        actionSheetController.addAction(cancelAction)
        
        let setPictureAction = UIAlertAction(title: "Set photo from gallery/camera", style: .default) { action -> Void in
            //            let imageVC = UIImagePickerController()
            //            imageVC.sourceType = .photoLibrary
            //            imageVC.delegate = self
            //            imageVC.allowsEditing = true
            //
            //            self.present(imageVC, animated: true)
            
            var config = YPImagePickerConfiguration()
            config.preferredStatusBarStyle = .lightContent
            config.colors.progressBarTrackColor = .black
            
            
            let picker = YPImagePicker(configuration: config)
            picker.didFinishPicking { [unowned picker] items, _ in
                if let image = items.singlePhoto?.image {
                    let data = image.pngData()
                    UsersData.userDefault.set(data, forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user")
                    UsersData.userDefault.synchronize()
                    
                    self.accountImageView.image = image
                    self.accountImageView.contentMode = .scaleAspectFill
                }
                picker.dismiss(animated: true, completion: nil)
                PushNotification.pushNote("You place a new profile photo!", 3)
            }
            self.present(picker, animated: true, completion: nil)
        }
        actionSheetController.addAction(setPictureAction)
        
        //        let setPictureFromCameraAction = UIAlertAction(title: "Set photo from camera", style: .default) { action -> Void in
        //            let imageVC = UIImagePickerController()
        //
        //            imageVC.sourceType = .camera
        //
        //            imageVC.delegate = self
        //            imageVC.allowsEditing = true
        //
        //            self.present(imageVC, animated: true)
        //        }
        //        actionSheetController.addAction(setPictureFromCameraAction)
        
        let deletePhotoAction = UIAlertAction(title: "Delete current photo", style: .default) { action -> Void in
            let defaultImage = UIImage(named: "user-4")
            let defaultImageData = defaultImage?.pngData()
            UsersData.userDefault.set(defaultImageData, forKey: UsersData.userDefault.string(forKey: "currentUser")! + " user")
            UsersData.userDefault.synchronize()
            self.accountImageView.image = defaultImage
            self.accountImageView.contentMode = .center
            PushNotification.pushNote("Your profile photo was removed :(",3)
        }
        actionSheetController.addAction(deletePhotoAction)
        
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    @IBAction func didTappedChangeUsernameButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        guard let changeVC = changeStoryboard.instantiateViewController(identifier: "changeUsernameVC") as? ChangeUsernameViewController else { return }
        
        present(changeVC, animated: true)
    }
    
    @IBAction func didTappedLogoutButton(_ sender: UIButton) {
        
        guard let startVC = mainStoryboard.instantiateViewController(identifier: "StartVC") as? StartViewController else { return }
        
        UsersData.userDefault.set(false, forKey: "isLoggedIn")
        UsersData.userDefault.synchronize()
        
        PushNotification.pushNote("You logouted!", 3)
        present(startVC, animated: false, completion: nil)
        
    }
    
    @IBAction func didTappedFAQButton(_ sender: UIButton) {
        guard let faqVC = faqStoryboard.instantiateViewController(identifier: "faqVC") as? FAQViewController else { return }
        
        present(faqVC, animated: true)
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

extension AccountViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
   
}
