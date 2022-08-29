//
//  HomePageViewController.swift
//  HealthPro
//
//  Created by User on 8/25/22.
//

import UIKit
import CoreMotion
import RealmSwift

class HomePageViewController: UIViewController {

    
    // swiftlint:disable force_try

    // MARK: Outlets
    
    @IBOutlet private weak var greetingLabel: UILabel!
    @IBOutlet private weak var newsTableView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var stepsView: UIView!
    @IBOutlet private weak var stepsIconImage: UIImageView!
    @IBOutlet private weak var stepsCountLabel: UILabel!
    @IBOutlet private weak var distanceCountLabel: UILabel!
    @IBOutlet private weak var floorsCountLabel: UILabel!
    @IBOutlet private weak var distanceView: UIView!
    @IBOutlet private weak var floorsView: UIView!
    
    // MARK: Properties
    
    var userName = String()
    
    private var images: [UIImage] {
        Array(1...3).compactMap { UIImage(named: "home\($0)")  }
    }
        
    private var pedometer = CMPedometer()
    private var countSteps = String()
    private var distance = String()
    private var floors = String()
    private let mainStoryboard: UIStoryboard = UIStoryboard(name: "Registration", bundle: nil)
    private let realm = try! Realm()
    
    private func getPedometrInfo() -> String {
        if (!CMPedometer.isStepCountingAvailable()) {
            print("cant counting")
        }
        let calendar = Calendar(identifier: .gregorian)
        DispatchQueue.main.async {
            self.pedometer.queryPedometerData(from: calendar.startOfDay(for: Date()), to: Date(), withHandler: {(pedometerData, error) in
                self.countSteps = String(pedometerData?.numberOfSteps.int32Value ?? 0)
                self.distance = String(pedometerData?.distance?.int32Value ?? 0)
                self.floors = String(pedometerData?.floorsAscended?.int32Value ?? 0)
            })
        }
        return self.countSteps
    }

    // MARK: Lifecirle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dump(newsTableView)
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        pageControl.numberOfPages = images.count
        pageControl.hidesForSinglePage = true
                
        newsTableView.layer.cornerRadius = 13
        
        stepsView.layer.cornerRadius = 13
        distanceView.layer.cornerRadius = 13
        floorsView.layer.cornerRadius = 13
        
        stepsCountLabel.text = getPedometrInfo() + " steps!"
        
        greetingLabel.text = "Hello, " + userName
        
        floorsCountLabel.text = floors + " floors"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stepsCountLabel.text = getPedometrInfo() + " steps"
        distanceCountLabel.text = distance + " meters"
        floorsCountLabel.text = floors + " floors"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stepsCountLabel.text = getPedometrInfo() + " steps"
        distanceCountLabel.text = distance + " meters"
        floorsCountLabel.text = floors + " floors"

    }
    
}

// MARK: Extensions

extension HomePageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsVCell", for: indexPath) as? NewsMainPageCollectionViewCell else { fatalError() }
        
        collectionView.backgroundColor = #colorLiteral(red: 0.7626346361, green: 1, blue: 0.8789471334, alpha: 1)
        
        cell.newsImage.image = images[indexPath.row]
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(newsTableView.contentOffset.x / newsTableView.frame.size.width)
    }
    
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: collectionView.frame.height)
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
