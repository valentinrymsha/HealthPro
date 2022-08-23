//
//  StartViewController.swift
//  HealthPro
//
//  Created by User on 8/4/22.
//

import UIKit

// swiftlint:disable line_length

class StartViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var startPageController: UIPageControl!
    
    @IBOutlet private weak var getStartedButton: UIButton!
    
    @IBOutlet private weak var startCollectionView: UICollectionView!
    
    // MARK: Properties
    
    private var images: [UIImage] {
        Array(3...5).compactMap { UIImage(named: "png\($0)") }
    }
    
    private let registrationStoryBoard: UIStoryboard = UIStoryboard(name: "Registration", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedButton.layer.cornerRadius = 8

        startCollectionView.delegate = self
        startCollectionView.dataSource = self
        
        startPageController.numberOfPages = images.count
        startPageController.hidesForSinglePage = true
    }

    // MARK: Actions
    
    @IBAction private func getStartedButton(_ sender: Any) {
        guard let registrationVC = registrationStoryBoard.instantiateViewController(identifier: "RegistrationVC") as? SignUpViewController else { return }
        if startPageController.currentPage == 2 {
            present(registrationVC, animated: false, completion: nil)
        }
    }
    
    @IBAction private func logInButton(_ sender: Any) {
        guard let loginVC = registrationStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController else { return }
        if startPageController.currentPage == 2 {
            present(loginVC, animated: false, completion: nil)
        }
    }

}
// MARK: - CollectionDataSource

extension StartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "startCollectionViewCell", for: indexPath) as? StartCollectionViewCell else { fatalError() }
        collectionView.tintColor = .white
        cell.startImageView.image = images[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.startPageController.currentPage = indexPath.item
    }
    
}

// MARK: CollectionDelegate

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
