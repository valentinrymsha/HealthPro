//
//  HomePageViewController.swift
//  HealthPro
//
//  Created by User on 8/25/22.
//

import UIKit
import CoreMotion

class HomePageViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var newsTableView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var stepsView: UIView!
    @IBOutlet weak var stepsIconImage: UIImageView!
    @IBOutlet weak var stepsCountLabel: UILabel!
    @IBOutlet weak var distanceCountLabel: UILabel!
    @IBOutlet weak var floorsCountLabel: UILabel!
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var floorsView: UIView!
    
    // MARK: Properties
    
    var nameOfUser = String()
    
    private var images: [UIImage] {
        Array(1...3).compactMap { UIImage(named: "home\($0)")  }
    }
        
    var pedometer = CMPedometer()
    var countSteps = String()
    var distance = String()
    var floors = String()
    
    private func getCountOfSteps() -> String {
        if (!CMPedometer.isStepCountingAvailable()) {
            print("cant counting")
        }
        let from = Date(timeIntervalSinceNow: -10000)
        let to = Date()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard let destination = segue.destination as? LoginViewController else { return }
            destination.delegate = self
        }
    
    // MARK: Lifecirle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dump(newsTableView)
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        pageControl.numberOfPages = images.count
        pageControl.hidesForSinglePage = true
        
        greetingLabel.text = nameOfUser
        
        newsTableView.layer.cornerRadius = 13
        
        stepsView.layer.cornerRadius = 13
        distanceView.layer.cornerRadius = 13
        floorsView.layer.cornerRadius = 13
        
        stepsCountLabel.text = getCountOfSteps() + " steps!"
        distanceCountLabel.text = distance
        floorsCountLabel.text = floors + " floors"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        greetingLabel.text = nameOfUser

        stepsCountLabel.text = getCountOfSteps() + " steps"
        distanceCountLabel.text = distance + " meters"
        floorsCountLabel.text = floors + " floors"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        greetingLabel.text = nameOfUser

        stepsCountLabel.text = getCountOfSteps() + " steps"
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

extension HomePageViewController: UserName {
    func update(text: String) {
        nameOfUser = "Hello " + text
    }
}
