//
//  FavoritesViewController.swift
//  HealthPro
//
//  Created by User on 8/16/22.
//
import BetterSegmentedControl
import UIKit


class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoriteSegmentedControl: BetterSegmentedControl!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var foodsTableView: UICollectionView!
    
    @IBOutlet weak var recipesTableView: UITableView!
    
    private var imagesOfFood: [UIImage] {
        Array(0...2).compactMap { UIImage(named: "png\($0)") }
    }
    
    @IBAction func searchRecipesButton(_ sender: Any) {
    }
    
    @IBAction func favoritesSegmentedControl(_ sender: Any) {
        switch favoriteSegmentedControl.index {
        case 1:
            foodsTableView.isHidden = true
            searchButton.isHidden = false
            recipesTableView.isHidden = false
        default:
            foodsTableView.isHidden = false
            searchButton.isHidden = true
            recipesTableView.isHidden = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchButton.layer.cornerRadius = 13
        
        recipesTableView.delegate = self
        recipesTableView.dataSource = self
        
        foodsTableView.delegate = self
        foodsTableView.dataSource = self
        
    }
    

}

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesOfFood.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodsCollectionVC", for: indexPath) as? FoodsCollectionViewCell else { fatalError() }
//        collectionView.tintColor = .white
        cell.foodImageView.image = imagesOfFood[indexPath.row]
        cell.layer.cornerRadius = 13
        
        return cell
    }
    
    
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3
        var sizeCG = CGSize()
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

            sizeCG = CGSize(width: size, height: size)
        }

        return sizeCG
    }
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.imagesOfFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipesTableViewCell") as? RecipesTableViewCell else { fatalError() }
//        collectionView.tintColor = .white
        cell.recipeImageView.image = imagesOfFood[indexPath.row]
        cell.layer.cornerRadius = 13
        
        return cell
    }
    
    
        

    
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 8
        let maskLayer = CALayer()
        
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
}
