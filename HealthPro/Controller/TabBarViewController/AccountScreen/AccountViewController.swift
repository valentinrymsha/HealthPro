//
//  AccountViewController.swift
//  HealthPro
//
//  Created by User on 8/29/22.
//

import UIKit
import YPImagePicker
import RealmSwift

final class AccountViewController: UIViewController {
    
    // swiftlint:disable force_try
    
    // MARK: Outlets
    
    @IBOutlet private weak var accountImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var changeUserPasswordButton: UIButton!
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var faqButton: UIButton!
    @IBOutlet private weak var backHeaderView: UIView!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    // MARK: Properties
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    private let pickerController = YPImagePicker()
    
    private let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private let mainTabBarStoryboard: UIStoryboard = UIStoryboard(name: "MainTabBar", bundle: nil)
    private let changeStoryboard: UIStoryboard = UIStoryboard(name: "ChangeUsername", bundle: nil)
    private let faqStoryboard: UIStoryboard = UIStoryboard(name: "FAQ", bundle: nil)
    private let realm = try! Realm()
    
    private func buttonConfig(_ button: UIButton) {
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.3326578438, green: 0.6460694075, blue: 0.6575706601, alpha: 1).withAlphaComponent(0.8)
        button.isUserInteractionEnabled = true
        button.isEnabled = true
    }
    
    private func setupImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        accountImageView.isUserInteractionEnabled = true
        accountImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let user = realm.object(ofType: UserModel.self, forPrimaryKey: UsersData.userDefault.string(forKey: "currentUser"))
        
        let defaultImage = UIImage(named: "user-4")
        let defaultImageData = defaultImage!.pngData()
        
        if user!.userImage == defaultImageData {
            self.accountImageView.contentMode = .center
            self.accountImageView.image = UIImage(data: user!.userImage)
        } else {
            self.accountImageView.image =  UIImage(data: user!.userImage)
            self.accountImageView.contentMode = .scaleAspectFill
            
        }
        
        accountImageView.layer.cornerRadius = accountImageView.frame.width / 2
        
    }
    
    // MARK: Lifecirlce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonConfig(changeUserPasswordButton)
        buttonConfig(logoutButton)
        buttonConfig(faqButton)
        buttonConfig(deleteAccountButton)
        
        setupImageView()
        
        DispatchQueue.main.async {
            self.userNameLabel.text = UsersData.userDefault.string(forKey: "currentUser")!
        }
        
        
        self.pickerController.delegate = self
        self.userNotificationCenter.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupImageView()
        userNameLabel.text = UsersData.userDefault.string(forKey: "currentUser")!
        
    }
    
    // MARK: Actions
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ -> Void in
            actionSheetController.dismiss(animated: true, completion: nil)  }
        actionSheetController.addAction(cancelAction)
        
        let setPictureAction = UIAlertAction(title: "Set photo from gallery/camera", style: .default) { _ -> Void in
            
            var config = YPImagePickerConfiguration()
            config.preferredStatusBarStyle = .lightContent
            config.colors.progressBarTrackColor = .black
            
            
            let picker = YPImagePicker(configuration: config)
            picker.didFinishPicking { [unowned picker] items, _ in
                if let image = items.singlePhoto?.image.resizeImage(image: items.singlePhoto!.image,
                                                                    targetSize: .init(width: 500, height: 500)) {
                    let data = image.pngData()
                    let user = self.realm.object(ofType: UserModel.self, forPrimaryKey: UsersData.userDefault.string(forKey: "currentUser"))
                    
                    try! self.realm.write {
                        user!.userImage = data!
                    }
                    
                    self.accountImageView.image = image
                    self.accountImageView.contentMode = .scaleAspectFill
                    picker.dismiss(animated: true, completion: {
                        PushNotification.pushNote("You place a new profile photo!", 3)
                    })
                }
            }
            self.present(picker, animated: true, completion: nil)
        }
        actionSheetController.addAction(setPictureAction)
        
        let deletePhotoAction = UIAlertAction(title: "Delete current photo", style: .default) { _ -> Void in
            let defaultImage = UIImage(named: "user-4")
            let defaultImageData = defaultImage?.pngData()
            
            let user = self.realm.object(ofType: UserModel.self, forPrimaryKey: UsersData.userDefault.string(forKey: "currentUser"))
            
            try! self.realm.write {
                user?.userImage = defaultImageData!
            }
            
            self.accountImageView.image = defaultImage
            self.accountImageView.contentMode = .center
            PushNotification.pushNote("Your profile photo was removed :(", 3)
        }
        actionSheetController.addAction(deletePhotoAction)
        
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    @IBAction func didTappedChangeUserPasswordButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        guard let changeVC = changeStoryboard.instantiateViewController(identifier: "changeUsernameVC") as? ChangeUsernameViewController else { return }
        
        present(changeVC, animated: true)
    }
    
    @IBAction func didTappedLogoutButton(_ sender: UIButton) {
        
        guard let startVC = mainStoryboard.instantiateViewController(identifier: "StartVC") as? StartViewController else { return }
        
        let user = realm.object(ofType: UserModel.self, forPrimaryKey: UsersData.userDefault.string(forKey: "currentUser")! as String)
        
        try! realm.write {
            user?.isLoggined = false
        }
        
        present(startVC, animated: false, completion: {
            PushNotification.pushNote("You logouted!", 3)
        })
        
    }
    
    @IBAction func didTappedFAQButton(_ sender: UIButton) {
        guard let faqVC = faqStoryboard.instantiateViewController(identifier: "faqVC") as? FAQViewController else { return }
        
        present(faqVC, animated: true)
    }
    
    @IBAction func didTappedDeleteAccountButton(_ sender: UIButton) {
        guard let startVC = mainStoryboard.instantiateViewController(identifier: "StartVC") as? StartViewController else { return }
        
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            
            let user = self.realm.object(ofType: UserModel.self, forPrimaryKey: UsersData.userDefault.string(forKey: "currentUser")! as String)
            
            try! self.realm.write {
                self.realm.delete(user!)
            }
          
            self.present(startVC, animated: false, completion: {
                PushNotification.pushNote("You deleted your account :(", 3)
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {_ in
            self.dismiss(animated: true)
        }))

        present(alert, animated: true)
    }
    
    
}

// MARK: ImagePickerViewDelegate, NavigationDelegate

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
}

extension AccountViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
}

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }
}
