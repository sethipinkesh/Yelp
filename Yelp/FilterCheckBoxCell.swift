//
//

//  Yelp
//
//  Created by Sethi, Pinkesh on 4/8/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit

class FilterCheckBoxCell: UITableViewCell {

    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    @IBOutlet weak var checkBoxLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
