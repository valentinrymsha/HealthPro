//
//  RecipeViewController.swift
//  HealthPro
//
//  Created by User on 8/23/22.
//
import Alamofire
import AlamofireImage
import SwiftyJSON
import UIKit

final class RecipeViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet var presentView: UIView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeTextLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var mainView: UIView!
    
    // MARK: Properties
    
    var text: String?
    var imageURL: String?
    var image: UIImage?
    var recipeText: String?
    
    
    
    private func img() -> UIImage {
        if let imageUrl = imageURL {
        Alamofire.request(imageUrl).responseImage { response in
            if let imag = response.result.value {
                DispatchQueue.main.async {
                    self.image = imag
                }
            }
        }
        }
        return image ?? UIImage()
    }
    // MARK: Lifestyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        recipeTitleLabel.text = text
        recipeTextLabel.text = recipeText
        recipeImage.image = img()
        mainView.layer.cornerRadius = 13
        recipeImage.layer.cornerRadius = 13
        presentView.layer.cornerRadius = 13
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.presentView.layer.cornerRadius = 13

        self.recipeImage.layer.cornerRadius = 8
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.recipeImage.image = self.img()
           
        }
        
        
    }
}
