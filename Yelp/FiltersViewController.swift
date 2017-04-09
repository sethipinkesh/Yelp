//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Sethi, Pinkesh on 4/8/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit
@objc protocol FilterViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilter filters: [String:AnyObject] )
}

class FiltersViewController: UIViewController {

    let filterSectionTitles = ["", "Distance", "Sort By", "Category"]
//    let distanceSectionItems = ["Auto", "0.3 Miles", "1 Miles", "5 Miles", "20 Miles"]
    let sortBySectionItems = ["Best match", "Highest rated", "Distance"]
    let sortBySectionEnumValue: [YelpSortMode] = [.bestMatched, .distance, .highestRated]
    let featureSectionItem = ["Offering a deal"]
    
    var distanceSectionExpanded = false
    var sortBySectionExpanded = false
    var categorySectionExapanded = false
    
    var currentSelectedDistanceIndex = 0
    var currentSelectedSortMode : YelpSortMode = .bestMatched
    
    
    var categories: [[String:String]]!
    var distanceSectionItems: [[String:String]]!
    
    var categorySwitchStates = [IndexPath:Bool] ()
    
    var deleagte: FilterViewControllerDelegate?
    
    @IBOutlet weak var filtersTableView: UITableView!
    
    @IBAction func onSearchClick(_ sender: Any) {
        var filter = [String : AnyObject]()
        var featureSelectionValue = false
        
        var selectedCategories  = [String] ()
        
        for(indexPath, isSelected) in categorySwitchStates{
            if isSelected{
                if(indexPath.section == 0){
                    featureSelectionValue = true
                }
                if(indexPath.section == 3){
                 selectedCategories.append(categories[indexPath.row]["code"]!)
                }
            }
            if selectedCategories.count>0 {
                filter["categories"] = selectedCategories as AnyObject?
            }
        }
        let radius = distanceSectionItems[currentSelectedDistanceIndex]["meterValue"]! as String
        
        if let radius = Int(radius){
            filter["radius"] = radius as AnyObject?
        }
        
        filter["deals"] = featureSelectionValue as AnyObject?
        filter["sort"] = currentSelectedSortMode as AnyObject?
        
        deleagte?.filtersViewController?(filtersViewController: self, didUpdateFilter: filter)
        dismiss(animated: true,completion: nil)
        
    }
    @IBAction func onCancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        filtersTableView.dataSource = self
        filtersTableView.delegate = self
        
        categories = self.yelpCategories()
        distanceSectionItems = self.yelpRadiusMapping()
        self.automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return featureSectionItem.count
        
        case 1:
            return self.distanceSectionExpanded ? distanceSectionItems.count : 1
         
        case 2:
            return self.sortBySectionExpanded ? sortBySectionItems.count : 1
            
        default:
            return self.categorySectionExapanded ? categories.count : 5
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSwitchCell") as! FilterSwitchCell
            cell.categoryNameLabel.text = featureSectionItem[indexPath.row]
            cell.categorySwitch.setOn(categorySwitchStates[indexPath] ??  false, animated: false)
            cell.switchDelegate = self
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCheckBoxCell") as! FilterCheckBoxCell
            
            if(distanceSectionExpanded){
                cell.checkBoxLabel.text = distanceSectionItems[indexPath.row]["distanceValue"]
                if currentSelectedDistanceIndex == indexPath.row{
                    cell.checkBoxImageView.image = #imageLiteral(resourceName: "checkbox_sel_ic")
                }else{
                    cell.checkBoxImageView.image = #imageLiteral(resourceName: "checkbox_ic")
                }
            }else{
                cell.checkBoxLabel.text = distanceSectionItems[currentSelectedDistanceIndex]["distanceValue"]
                cell.checkBoxImageView.image = #imageLiteral(resourceName: "dropdwon_ic")
            }
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCheckBoxCell") as! FilterCheckBoxCell
            if(sortBySectionExpanded){
                cell.checkBoxLabel.text = sortBySectionItems[indexPath.row]
                if currentSelectedSortMode.rawValue == indexPath.row{
                    cell.checkBoxImageView.image = #imageLiteral(resourceName: "checkbox_sel_ic")
                }else{
                    cell.checkBoxImageView.image = #imageLiteral(resourceName: "checkbox_ic")
                }
            }else{
                cell.checkBoxLabel.text = sortBySectionItems[currentSelectedSortMode.rawValue]
                cell.checkBoxImageView.image = #imageLiteral(resourceName: "dropdwon_ic")
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterSwitchCell") as! FilterSwitchCell
            if(!categorySectionExapanded && indexPath.row == 4){
                cell.categoryNameLabel.text = "Tap for more"
                cell.categorySwitch.isHidden = true
            }else{
                cell.categoryNameLabel.text = categories[indexPath.row]["name"]
                cell.categorySwitch.setOn(categorySwitchStates[indexPath] ??  false, animated: false)
                cell.categorySwitch.isHidden = false
            }
            cell.switchDelegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section{
        case 1:
            if(distanceSectionExpanded){
                currentSelectedDistanceIndex = indexPath.row
            }
            distanceSectionExpanded = !distanceSectionExpanded
            tableView.reloadSections(IndexSet([indexPath.section]), with: .automatic)
            
        case 2:
            if(sortBySectionExpanded){
                currentSelectedSortMode = sortBySectionEnumValue[indexPath.row]
            }
            sortBySectionExpanded = !sortBySectionExpanded
            tableView.reloadSections(IndexSet([indexPath.section]), with: .automatic)
            
        case 3:
            if(indexPath.row == 4 && !categorySectionExapanded){
                categorySectionExapanded = !categorySectionExapanded
                tableView.reloadSections(IndexSet([indexPath.section]), with: .automatic)
            }
        default:
            return
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return nil
        }else{
            return filterSectionTitles[section]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0.0
        }else{
            return 10
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

}

extension FiltersViewController: SwitchCellDelegate{

    func switchCell(switchCell: FilterSwitchCell, didChangeValue value: Bool) {
        let index = filtersTableView.indexPath(for: switchCell)!
        categorySwitchStates[index] = value
    }
    func yelpRadiusMapping() -> [[String: String]]{
        return   [["distanceValue" : "Auto", "meterValue": "-1"],
                        ["distanceValue" : "0.3 Miles", "meterValue": "483"],
                        ["distanceValue" : "1 Miles", "meterValue": "1609"],
                        ["distanceValue" : "5 Miles", "meterValue": "8047"],
                        ["distanceValue" : "20 Miles", "meterValue": "32187"]]
    }
    func yelpCategories() ->[[String:String]] {
        return [["name" : "Afghan", "code": "afghani"],
                ["name" : "African", "code": "african"],
                ["name" : "American, New", "code": "newamerican"],
                ["name" : "American, Traditional", "code": "tradamerican"],
                ["name" : "Arabian", "code": "arabian"],
                ["name" : "Argentine", "code": "argentine"],
                ["name" : "Armenian", "code": "armenian"],
                ["name" : "Asian Fusion", "code": "asianfusion"],
                ["name" : "Asturian", "code": "asturian"],
                ["name" : "Australian", "code": "australian"],
                ["name" : "Austrian", "code": "austrian"],
                ["name" : "Baguettes", "code": "baguettes"],
                ["name" : "Bangladeshi", "code": "bangladeshi"],
                ["name" : "Barbeque", "code": "bbq"],
                ["name" : "Basque", "code": "basque"],
                ["name" : "Bavarian", "code": "bavarian"],
                ["name" : "Beer Garden", "code": "beergarden"],
                ["name" : "Beer Hall", "code": "beerhall"],
                ["name" : "Beisl", "code": "beisl"],
                ["name" : "Belgian", "code": "belgian"],
                ["name" : "Bistros", "code": "bistros"],
                ["name" : "Black Sea", "code": "blacksea"],
                ["name" : "Brasseries", "code": "brasseries"],
                ["name" : "Brazilian", "code": "brazilian"],
                ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                ["name" : "British", "code": "british"],
                ["name" : "Buffets", "code": "buffets"],
                ["name" : "Bulgarian", "code": "bulgarian"],
                ["name" : "Burgers", "code": "burgers"],
                ["name" : "Burmese", "code": "burmese"],
                ["name" : "Cafes", "code": "cafes"],
                ["name" : "Cafeteria", "code": "cafeteria"],
                ["name" : "Cajun/Creole", "code": "cajun"],
                ["name" : "Cambodian", "code": "cambodian"],
                ["name" : "Canadian", "code": "New)"],
                ["name" : "Canteen", "code": "canteen"],
                ["name" : "Caribbean", "code": "caribbean"],
                ["name" : "Catalan", "code": "catalan"],
                ["name" : "Chech", "code": "chech"],
                ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                ["name" : "Chicken Shop", "code": "chickenshop"],
                ["name" : "Chicken Wings", "code": "chicken_wings"],
                ["name" : "Chilean", "code": "chilean"],
                ["name" : "Chinese", "code": "chinese"],
                ["name" : "Comfort Food", "code": "comfortfood"],
                ["name" : "Corsican", "code": "corsican"],
                ["name" : "Creperies", "code": "creperies"],
                ["name" : "Cuban", "code": "cuban"],
                ["name" : "Curry Sausage", "code": "currysausage"],
                ["name" : "Cypriot", "code": "cypriot"],
                ["name" : "Czech", "code": "czech"],
                ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                ["name" : "Danish", "code": "danish"],
                ["name" : "Delis", "code": "delis"],
                ["name" : "Diners", "code": "diners"],
                ["name" : "Dumplings", "code": "dumplings"],
                ["name" : "Eastern European", "code": "eastern_european"],
                ["name" : "Ethiopian", "code": "ethiopian"],
                ["name" : "Fast Food", "code": "hotdogs"],
                ["name" : "Filipino", "code": "filipino"],
                ["name" : "Fish & Chips", "code": "fishnchips"],
                ["name" : "Fondue", "code": "fondue"],
                ["name" : "Food Court", "code": "food_court"],
                ["name" : "Food Stands", "code": "foodstands"],
                ["name" : "French", "code": "french"],
                ["name" : "French Southwest", "code": "sud_ouest"],
                ["name" : "Galician", "code": "galician"],
                ["name" : "Gastropubs", "code": "gastropubs"],
                ["name" : "Georgian", "code": "georgian"],
                ["name" : "German", "code": "german"],
                ["name" : "Giblets", "code": "giblets"],
                ["name" : "Gluten-Free", "code": "gluten_free"],
                ["name" : "Greek", "code": "greek"],
                ["name" : "Halal", "code": "halal"],
                ["name" : "Hawaiian", "code": "hawaiian"],
                ["name" : "Heuriger", "code": "heuriger"],
                ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                ["name" : "Hot Dogs", "code": "hotdog"],
                ["name" : "Hot Pot", "code": "hotpot"],
                ["name" : "Hungarian", "code": "hungarian"],
                ["name" : "Iberian", "code": "iberian"],
                ["name" : "Indian", "code": "indpak"],
                ["name" : "Indonesian", "code": "indonesian"],
                ["name" : "International", "code": "international"],
                ["name" : "Irish", "code": "irish"],
                ["name" : "Island Pub", "code": "island_pub"],
                ["name" : "Israeli", "code": "israeli"],
                ["name" : "Italian", "code": "italian"],
                ["name" : "Japanese", "code": "japanese"],
                ["name" : "Jewish", "code": "jewish"],
                ["name" : "Kebab", "code": "kebab"],
                ["name" : "Korean", "code": "korean"],
                ["name" : "Kosher", "code": "kosher"],
                ["name" : "Kurdish", "code": "kurdish"],
                ["name" : "Laos", "code": "laos"],
                ["name" : "Laotian", "code": "laotian"],
                ["name" : "Latin American", "code": "latin"],
                ["name" : "Live/Raw Food", "code": "raw_food"],
                ["name" : "Lyonnais", "code": "lyonnais"],
                ["name" : "Malaysian", "code": "malaysian"],
                ["name" : "Meatballs", "code": "meatballs"],
                ["name" : "Mediterranean", "code": "mediterranean"],
                ["name" : "Mexican", "code": "mexican"],
                ["name" : "Middle Eastern", "code": "mideastern"],
                ["name" : "Milk Bars", "code": "milkbars"],
                ["name" : "Modern Australian", "code": "modern_australian"],
                ["name" : "Modern European", "code": "modern_european"],
                ["name" : "Mongolian", "code": "mongolian"],
                ["name" : "Moroccan", "code": "moroccan"],
                ["name" : "New Zealand", "code": "newzealand"],
                ["name" : "Night Food", "code": "nightfood"],
                ["name" : "Norcinerie", "code": "norcinerie"],
                ["name" : "Open Sandwiches", "code": "opensandwiches"],
                ["name" : "Oriental", "code": "oriental"],
                ["name" : "Pakistani", "code": "pakistani"],
                ["name" : "Parent Cafes", "code": "eltern_cafes"],
                ["name" : "Parma", "code": "parma"],
                ["name" : "Persian/Iranian", "code": "persian"],
                ["name" : "Peruvian", "code": "peruvian"],
                ["name" : "Pita", "code": "pita"],
                ["name" : "Pizza", "code": "pizza"],
                ["name" : "Polish", "code": "polish"],
                ["name" : "Portuguese", "code": "portuguese"],
                ["name" : "Potatoes", "code": "potatoes"],
                ["name" : "Poutineries", "code": "poutineries"],
                ["name" : "Pub Food", "code": "pubfood"],
                ["name" : "Rice", "code": "riceshop"],
                ["name" : "Romanian", "code": "romanian"],
                ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                ["name" : "Rumanian", "code": "rumanian"],
                ["name" : "Russian", "code": "russian"],
                ["name" : "Salad", "code": "salad"],
                ["name" : "Sandwiches", "code": "sandwiches"],
                ["name" : "Scandinavian", "code": "scandinavian"],
                ["name" : "Scottish", "code": "scottish"],
                ["name" : "Seafood", "code": "seafood"],
                ["name" : "Serbo Croatian", "code": "serbocroatian"],
                ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                ["name" : "Singaporean", "code": "singaporean"],
                ["name" : "Slovakian", "code": "slovakian"],
                ["name" : "Soul Food", "code": "soulfood"],
                ["name" : "Soup", "code": "soup"],
                ["name" : "Southern", "code": "southern"],
                ["name" : "Spanish", "code": "spanish"],
                ["name" : "Steakhouses", "code": "steak"],
                ["name" : "Sushi Bars", "code": "sushi"],
                ["name" : "Swabian", "code": "swabian"],
                ["name" : "Swedish", "code": "swedish"],
                ["name" : "Swiss Food", "code": "swissfood"],
                ["name" : "Tabernas", "code": "tabernas"],
                ["name" : "Taiwanese", "code": "taiwanese"],
                ["name" : "Tapas Bars", "code": "tapas"],
                ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                ["name" : "Tex-Mex", "code": "tex-mex"],
                ["name" : "Thai", "code": "thai"],
                ["name" : "Traditional Norwegian", "code": "norwegian"],
                ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                ["name" : "Trattorie", "code": "trattorie"],
                ["name" : "Turkish", "code": "turkish"],
                ["name" : "Ukrainian", "code": "ukrainian"],
                ["name" : "Uzbek", "code": "uzbek"],
                ["name" : "Vegan", "code": "vegan"],
                ["name" : "Vegetarian", "code": "vegetarian"],
                ["name" : "Venison", "code": "venison"],
                ["name" : "Vietnamese", "code": "vietnamese"],
                ["name" : "Wok", "code": "wok"],
                ["name" : "Wraps", "code": "wraps"],
                ["name" : "Yugoslav", "code": "yugoslav"]]
    }
}
