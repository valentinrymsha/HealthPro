//
//  CollectionViewCell.swift
//  HealthPro
//
//  Created by User on 8/25/22.
//

import UIKit

final class NewsMainPageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsImage.layer.cornerRadius = 13
    }
}
