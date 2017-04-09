//
//  FilterSwitchCell.swift
//  Yelp
//
//  Created by Sethi, Pinkesh on 4/8/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit
import SevenSwitch

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(switchCell: FilterSwitchCell, didChangeValue value:Bool)
}
class FilterSwitchCell: UITableViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    var categorySwitch = SevenSwitch()
    var switchDelegate: SwitchCellDelegate?
    
    @IBOutlet weak var switchContainerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.switchContainerView.addSubview(categorySwitch)
        categorySwitch.addTarget(self, action: #selector(onSwitchCellChanged1(_:)), for: UIControlEvents.valueChanged)
//        categorySwitch.thumbTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        categorySwitch.activeColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        categorySwitch.inactiveColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        categorySwitch.onTintColor =  UIColor(red: 0.45, green: 0.58, blue: 0.67, alpha: 1)
//        categorySwitch.borderColor = UIColor.clear
//        categorySwitch.shadowColor = UIColor.black
        categorySwitch.offLabel.text = "Off"
        categorySwitch.onLabel.text = "On"
        categorySwitch.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        // Initialization code
    }

    @IBAction func onSwitchCellChanged1(_ sender: UISwitch) {
        print("Switchvalue changed")
        
        if(sender.isOn){
            categorySwitch.onImage = UIImage(contentsOfFile: "checkbox_ic.png")
            categorySwitch.thumbImage = UIImage(named: "checkbox_sel_ic")
        }
        switchDelegate?.switchCell?(switchCell: self, didChangeValue: categorySwitch.isOn())
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
