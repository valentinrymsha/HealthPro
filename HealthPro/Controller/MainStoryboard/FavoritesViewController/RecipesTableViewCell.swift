//
//  TableViewCell.swift
//  HealthPro
//
//  Created by User on 8/16/22.
//

import UIKit

class RecipesTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
