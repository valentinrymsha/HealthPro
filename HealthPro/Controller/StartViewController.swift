//
//  StartViewController.swift
//  HealthPro
//
//  Created by User on 8/4/22.
//

import UIKit

// swiftlint:disable line_length
class StartViewController: UIViewController {
    
    @IBOutlet weak var startPageController: UIPageControl!
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBOutlet weak var startCollectionView: UICollectionView!
    
    private var images: [UIImage] {
        Array(0...2).compactMap { UIImage(named: "png\($0)") }
    }
    
    
    @IBAction func getStartedButton(_ sender: Any) {
    }
    
    @IBAction func logInButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedButton.layer.cornerRadius = 8

        startCollectionView.delegate = self
        startCollectionView.dataSource = self
        
        startPageController.numberOfPages = images.count
        startPageController.hidesForSinglePage = true
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.startPageController.currentPage = indexPath.item
    }

}
// MARK: - Cell description

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
    
    
}

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
