//
//  HomePageViewController.swift
//  HealthPro
//
//  Created by User on 8/25/22.
//

import UIKit

class HomePageViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var newsTableView: UICollectionView!
    
    // MARK: Properties
    
    private var images: [UIImage] {
        Array(1...3).compactMap { UIImage(named: "home\($0)")  }
    }
    
    // MARK: Lifecirle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        newsTableView.layer.cornerRadius = 13
    }

}

// MARK: Extensions

extension HomePageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsVCell", for: indexPath) as? NewsMainPageCollectionViewCell else { fatalError() }
        
        collectionView.tintColor = #colorLiteral(red: 0.7626346361, green: 1, blue: 0.8789471334, alpha: 1)
        
        cell.newsImage.image = images[indexPath.row]
        
        return cell
    }
    
    
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    
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