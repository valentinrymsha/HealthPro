//
//  FavoritesViewController.swift
//  HealthPro
//
//  Created by User on 8/16/22.
//
import Alamofire
import SwiftyJSON
import AlamofireImage
import BetterSegmentedControl
import UIKit


class FavoritesViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var favoriteSegmentedControl: BetterSegmentedControl!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var foodsTableView: UICollectionView!
    @IBOutlet private weak var recipesTableView: UITableView!
    
    // MARK: Properties
    
    private var recipesArray: Root?
    private var recipes: [Recipe]?
    
    private var imagesOfFood: [UIImage] {
        Array(0...2).compactMap { UIImage(named: "png\($0)") }
    }
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Manager.checkUserOnServer { root in
            self.recipesArray = root
            DispatchQueue.main.async {
                self.recipesTableView.reloadData()
                self.recipes = self.recipesArray?.recipes
            }
        }
    
        searchButton.layer.cornerRadius = 13
        
        recipesTableView.delegate = self
        recipesTableView.dataSource = self
        
        foodsTableView.delegate = self
        foodsTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.recipesTableView.reloadData()
        }
    }
    
    // MARK: Actions
    
    @IBAction private func searchRecipesButton(_ sender: Any) {
        DispatchQueue.main.async {
            Manager.checkUserOnServer { (root) in
                self.recipesArray = root
                self.recipes = self.recipesArray?.recipes
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.recipesTableView.reloadData()
        }
    }
    
    @IBAction private func favoritesSegmentedControl(_ sender: Any) {
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
}

// MARK: CollectionDataSource

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

// MARK: CollectionDelegate

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

// MARK: TableDataSource

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return recipes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipesTableViewCell") as? RecipesTableViewCell else { fatalError() }
        let recipe = recipes?[indexPath.row]
        
        if let imageUrl = recipe?.image {
        Alamofire.request(imageUrl).responseImage { response in
            if let image = response.result.value {
                DispatchQueue.main.async {
                    cell.recipeImageView.image = image
                }
            }
        }
        }
        
        cell.recipeTitileLabel.text = recipe?.title
    
        cell.layer.cornerRadius = 13
        
        return cell
        
    }
}

// MARK: TableDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 10
        let maskLayer = CALayer()
        
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}
