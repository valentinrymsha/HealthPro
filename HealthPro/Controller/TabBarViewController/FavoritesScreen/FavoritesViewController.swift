//
//  FavoritesViewController.swift
//  HealthPro
//
//  Created by User on 8/16/22.
//
import Alamofire
import AlamofireImage
import BetterSegmentedControl
import SwiftyJSON
import UIKit


final class FavoritesViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private weak var favoriteSegmentedControl: BetterSegmentedControl!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var foodsTableView: UICollectionView!
    @IBOutlet private weak var recipesTableView: UITableView!
    
    // MARK: Properties
    
    private let recipeStoryboard: UIStoryboard = UIStoryboard(name: "Recipe", bundle: nil)
    
    private var recipesArray: Root?
    private var recipes: [Recipe]?
    private var imagesForColletion: [UIImage]?
    
    private var imagesOfFood: [UIImage] {
        Array(0...2).compactMap { UIImage(named: "png\($0)") }
    }
    
    private let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    // MARK: Lifecircle
    
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
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.recipesTableView.reloadData()
            self.foodsTableView.reloadData()
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.recipesTableView.reloadData()
            self.foodsTableView.reloadData()
        }
    }
    
    @IBAction private func favoritesSegmentedControl(_ sender: Any) {
        switch favoriteSegmentedControl.index {
        case 1:
            foodsTableView.isHidden = true
            recipesTableView.isHidden = false
        default:
            foodsTableView.isHidden = false
            recipesTableView.isHidden = true
        }
    }
    
}

// MARK: CollectionDataSource

extension FavoritesViewController: UICollectionViewDataSource {
    
    // swiftlint:disable force_cast
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        recipes?.count ?? 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodsCollectionVC",
                                                            for: indexPath) as! FoodsCollectionViewCell

        let recipe = recipes?[indexPath.row]
        
        if let imageUrl = recipe?.image {
        Alamofire.request(imageUrl).responseImage { response in
            if let image = response.result.value {
                DispatchQueue.main.async {
                    cell.foodImageView.image = image
                }
            }
        }
        }
        
        cell.layer.cornerRadius = 13
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let foodVC = UIStoryboard(name: "Food", bundle: nil).instantiateViewController(identifier: "foodVC") as? FoodViewController {
            let recipe = recipes?[indexPath.row]
            foodVC.imageURL = recipe?.image
            present(foodVC, animated: true, completion: nil)
            
//            recipeVC.recipeTitleLabel.text = recipe?.title
        }
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
            
            let width = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            let height = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            
            if indexPath.item % 5 == 0 {
            sizeCG = CGSize(width: width * 2, height: height)
            } else {
                sizeCG = CGSize(width: width, height: height)

            }
        }
      
        return sizeCG
            
    }
}
// MARK: TableDataSource

extension FavoritesViewController: UITableViewDataSource {
    
    // swiftlint:disable force_cast

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return recipes?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipesTableViewCell") as! RecipesTableViewCell
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let recipeVC = recipeStoryboard.instantiateViewController(identifier: "recipeVC") as? RecipeViewController {
            let recipe = recipes?[indexPath.row]
            recipeVC.imageURL = recipe?.image
            recipeVC.text = recipe?.title
            var string = String()
            recipe?.extendedIngredients.forEach {
                string.append("\($0.name), ")
            }
            recipeVC.recipeText = String("Ingredients:\n" + string.dropLast(2))
            present(recipeVC, animated: true, completion: nil)
            
//            recipeVC.recipeTitleLabel.text = recipe?.title
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
