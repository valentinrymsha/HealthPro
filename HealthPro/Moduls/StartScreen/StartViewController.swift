//
//  StartViewController.swift
//  HealthPro
//
//  Created by User on 8/4/22.
//

import UIKit

final class StartViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var startPageControl: UIPageControl!
    @IBOutlet private weak var getStartedButton: UIButton!
    @IBOutlet private weak var startCollectionView: UICollectionView!
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: Properties
    
    private var images: [UIImage] {
        Array(1...3).compactMap { UIImage(named: "png\($0)")  }
    }
    private var lastIndex: Int {
        images.count - 1
    }
    
    private let registrationStoryBoard: UIStoryboard = UIStoryboard(name: "Registration", bundle: nil)
    private let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    
    private func isGetStartedButtonEnabled(_ isEnabled: Bool = true) {
        getStartedButton.alpha = isEnabled ? 1 : 0.5
        getStartedButton.isUserInteractionEnabled = isEnabled
    }
    
    private func isLoginButtonEnabled(_ isEnabled: Bool = true) {
        loginButton.alpha = isEnabled ? 1 : 0.5
        loginButton.isUserInteractionEnabled = isEnabled
    }
    
    // MARK: lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        dump(startCollectionView)
        
        getStartedButton.layer.cornerRadius = 8
        isGetStartedButtonEnabled(false)
        isLoginButtonEnabled(false)
        
        startCollectionView.delegate = self
        startCollectionView.dataSource = self
        
        startPageControl.numberOfPages = images.count
        startPageControl.hidesForSinglePage = true
    }

    // MARK: Actions
    
    @IBAction private func getStartedButton(_ sender: Any) {
        guard let registrationVC = registrationStoryBoard.instantiateViewController(identifier: "RegistrationVC") as? SignUpViewController else { return }
        
        if startPageControl.currentPage == lastIndex {
            present(registrationVC, animated: false, completion: nil)
        }
    }
    
    @IBAction private func logInButton(_ sender: Any) {
        guard let loginVC = loginStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController else { return }
        if startPageControl.currentPage == lastIndex {
            
            present(loginVC, animated: false, completion: nil)
        }
    }

}

// MARK: - CollectionDataSource

extension StartViewController: UICollectionViewDataSource {
    
    // swiftlint:disable force_cast
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "startCollectionViewCell", for: indexPath) as! StartCollectionViewCell
        
        collectionView.tintColor = .white
        
        let image = images[indexPath.row]
        let newImage = image.resizeImage(image: image, targetSize: .init(width: 750, height: 750))
        cell.startImageView.image = newImage
        
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        startPageControl.currentPage = Int(startCollectionView.contentOffset.x / startCollectionView.frame.size.width)
        isGetStartedButtonEnabled(startPageControl.currentPage == lastIndex)
        isLoginButtonEnabled(startPageControl.currentPage == lastIndex)
    }
}

// MARK: CollectionDelegateFlowLayout

extension StartViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 0
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
