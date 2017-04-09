//
//  BusinessTableCell.swift
//  Yelp
//
//  Created by Sethi, Pinkesh on 4/7/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit

class BusinessTableCell: UITableViewCell {
   
    var business: Business!{
        didSet {
            thumbImageView.setImageWith(business.imageURL!)
            businessNameLabel.text = business.name
            distanceLabel.text = business.distance
            ratingsImageView.setImageWith(business.ratingImageURL!)
            reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            addressLabel.text = business.address
            categoryLabel.text = business.categories
            
        }
    }
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageView.layer.cornerRadius = 4
        thumbImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
