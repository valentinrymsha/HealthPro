//
//  AccountViewController.swift
//  HealthPro
//
//  Created by User on 8/29/22.
//
import Alamofire
import AlamofireImage
import SwiftyJSON
import RealmSwift
import UIKit
import YPImagePicker

final class AccountViewController: UIViewController {
    
    // swiftlint:disable force_try
    
    // MARK: Outlets
    
    @IBOutlet private weak var accountImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var changeUserPasswordButton: UIButton!
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var faqButton: UIButton!
    @IBOutlet private weak var backHeaderView: UIView!
    @IBOutlet private weak var deleteAccountButton: UIButton!
    @IBOutlet private weak var weatherIconImage: UIImageView!
    @IBOutlet private weak var weatherLabel: UILabel!
    @IBOutlet private weak var bonusButton: UIButton!
    
    // MARK: Properties
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    private let pickerController = YPImagePicker()
    
    private let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private let mainTabBarStoryboard: UIStoryboard = UIStoryboard(name: "MainTabBar", bundle: nil)
    private let changeStoryboard: UIStoryboard = UIStoryboard(name: "ChangeUsername", bundle: nil)
    private let faqStoryboard: UIStoryboard = UIStoryboard(name: "FAQ", bundle: nil)
    private let bonusStoryboard: UIStoryboard = UIStoryboard(name: "Bonus", bundle: nil)
    private let gameStoryboard: UIStoryboard = UIStoryboard(name: "Game", bundle: nil)
    
    private let realm = try! Realm()
    
    private var rootWeatherInfo: RootInfo?
    private var currentWeather: Current?
    private var conditionWeather: Condition?
    
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
    
    private func setupWrongAlert() {
        let alert = UIAlertController(title: "Some troubles with servers :(", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func setupWeatherData() {
        WeatherManager.checkUserOnServer { root in
            self.rootWeatherInfo = root
            DispatchQueue.main.async { [self] in
                self.currentWeather = self.rootWeatherInfo?.current
                self.conditionWeather = self.currentWeather?.condition
                self.weatherLabel.text = (currentWeather?.temp_c.description ?? "0") + "℃"
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            if let image = self.conditionWeather?.icon {
                let imageUrl = "https:" + image
                Alamofire.request(imageUrl).responseImage { response in
                    if let image = response.result.value {
                        self.weatherIconImage.image = image
                    }
                }
            }
        })
    }
    
    // MARK: Lifecirlce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonConfig(changeUserPasswordButton)
        buttonConfig(logoutButton)
        buttonConfig(faqButton)
        buttonConfig(deleteAccountButton)
        buttonConfig(bonusButton)
        
        setupImageView()
        setupWeatherData()
        
        DispatchQueue.main.async {
            self.userNameLabel.text = UsersData.userDefault.string(forKey: "currentUser")!
        }
        
        self.pickerController.delegate = self
        self.userNotificationCenter.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupImageView()
        setupWeatherData()
    }
    
    // MARK: Actions
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
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
    
    @IBAction private func didTappedChangeUserPasswordButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        guard let changeVC = changeStoryboard.instantiateViewController(identifier: "changeUsernameVC") as? ChangeUsernameViewController else { return }
        
        present(changeVC, animated: true)
    }
    
    @IBAction private func didTappedLogoutButton(_ sender: UIButton) {
        
        guard let startVC = mainStoryboard.instantiateViewController(identifier: "StartVC") as? StartViewController else { return }
        
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [self] _ in
            
            let user = realm.object(ofType: UserModel.self, forPrimaryKey: UsersData.userDefault.string(forKey: "currentUser")! as String)
            
            try! realm.write {
                user?.isLoggined = false
            }
            
            present(startVC, animated: false, completion: {
                PushNotification.pushNote("You logouted!", 3)
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true)
    }
    
    @IBAction private func didTappedFAQButton(_ sender: UIButton) {
        guard let faqVC = faqStoryboard.instantiateViewController(identifier: "faqVC") as? FAQViewController else { return }
        
        present(faqVC, animated: true)
    }
    
    @IBAction private func didTappedDeleteAccountButton(_ sender: UIButton) {
        guard let startVC = mainStoryboard.instantiateViewController(identifier: "StartVC") as? StartViewController else { return }
        
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            
            let user = self.realm.object(ofType: UserModel.self, forPrimaryKey: UsersData.userDefault.string(forKey: "currentUser")! as String)
            
            try! self.realm.write {
                self.realm.delete(user!)
            }
          
            self.present(startVC, animated: false, completion: {
                PushNotification.pushNote("You deleted your account :(", 3)
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true)
    }
    
    @IBAction func didTappedBonusButton(_ sender: UIButton) {
        guard let bonusVC = bonusStoryboard.instantiateViewController(withIdentifier: "bonusVC") as? BonusViewController else { return }
       
        present(bonusVC, animated: true)
    }
    
    @IBAction private func didTappedTwitterButton(_ sender: UIButton) {
        
        if let url = URL(string: "https://twitter.com") {
            UIApplication.shared.open(url)
        } else {
            setupWrongAlert()
        }
    }
    
    @IBAction private func didTappedInstButton(_ sender: UIButton) {
        if let url = URL(string: "https://instagram.com/valentinrymsha") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction private func didTappedTelegramButton(_ sender: UIButton) {
        if let url = URL(string: "https://telegram.org") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func didTappedMinigameButton(_ sender: UIButton) {
        guard let gameVC = gameStoryboard.instantiateViewController(withIdentifier: "gameVC") as? GameViewController else { return }
       
        present(gameVC, animated: true)
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
