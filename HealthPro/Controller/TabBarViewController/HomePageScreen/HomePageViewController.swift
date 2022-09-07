//
//  HomePageViewController.swift
//  HealthPro
//
//  Created by User on 8/25/22.
//

import CoreMotion
import RealmSwift
import UIKit
import UserNotifications

final class HomePageViewController: UIViewController {

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
    @IBOutlet weak var nearestShopsButton: UIButton!
    @IBOutlet weak var greetingsBackView: UIView!
    
    // MARK: Properties
    
    let medicalStoryboard: UIStoryboard = UIStoryboard(name: "Map", bundle: nil)

    var userName = String()
    
    private var images: [UIImage] {
        Array(1...3).compactMap { UIImage(named: "m\($0)")?.resizeImage(image: UIImage(named: "m\($0)")!, targetSize: .init(width: 600, height: 600)) }
    }
        
    private var pedometer = CMPedometer()
    private var countSteps = String()
    private var distance = String()
    private var floors = String()
    private let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    private func getPedometrInfo() -> String {
        if !CMPedometer.isStepCountingAvailable() {
            print("cant counting")
        }
        let calendar = Calendar(identifier: .gregorian)
        DispatchQueue.main.async {
            self.pedometer.queryPedometerData(from: calendar.startOfDay(for: Date()), to: Date(), withHandler: {(pedometerData, error) in
                if let pedometerData = pedometerData {
                    self.countSteps = String(pedometerData.numberOfSteps.int32Value)
                    self.distance = String(pedometerData.distance?.int32Value ?? 0)
                    self.floors = String(pedometerData.floorsAscended?.int32Value ?? 0)
                } else {
                    if let error = error {
                        print("Something wrong: \(error.localizedDescription)")
                    }
                }
                })
        }
        return self.countSteps
    }

    // MARK: Lifecirle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        
        dump(newsTableView)
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        pageControl.numberOfPages = images.count
        pageControl.hidesForSinglePage = true
                
        newsTableView.layer.cornerRadius = 13
        
        stepsView.layer.cornerRadius = 13
        distanceView.layer.cornerRadius = 13
        floorsView.layer.cornerRadius = 13
        nearestShopsButton.layer.cornerRadius = 9
                
        stepsCountLabel.text = getPedometrInfo() + " steps!"
        
        greetingLabel.text = "Hello, " + (UsersData.userDefault.string(forKey: "currentUser")!)
        
        floorsCountLabel.text = floors + " floors"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        stepsCountLabel.text = getPedometrInfo() + " steps"
        distanceCountLabel.text = distance + " meters"
        floorsCountLabel.text = floors + " floors"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stepsCountLabel.text = getPedometrInfo() + " steps"
        distanceCountLabel.text = distance + " meters"
        floorsCountLabel.text = floors + " floors"
        
        greetingLabel.text = "Hello, " + (UsersData.userDefault.string(forKey: "currentUser")!)

    }
    
    // MARK: Actions
  
    @IBAction func showDataButton(_ sender: UIButton) {
        
        guard let mapVC = medicalStoryboard.instantiateViewController(identifier: "mapVC") as? MapViewController else { return }
       
        present(mapVC, animated: true)
    }
    
    
}

// MARK: UICollectionViewDataSource

extension HomePageViewController: UICollectionViewDataSource {
    
    // swiftlint:disable force_cast
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsVCell", for: indexPath) as! NewsMainPageCollectionViewCell 
        
        collectionView.backgroundColor = #colorLiteral(red: 0.7626346361, green: 1, blue: 0.8789471334, alpha: 1)
        
        cell.newsImage.image = images[indexPath.row]
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(newsTableView.contentOffset.x / newsTableView.frame.size.width)
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout

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
