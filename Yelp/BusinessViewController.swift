//
//  BusinessViewController.swift
//  Yelp
//
//  Created by Sethi, Pinkesh on 4/7/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit

class BusinessViewController: UIViewController, FilterViewControllerDelegate {

    
    @IBOutlet weak var businessTableView: UITableView!
    var businesses: [Business]!
    var filterdBusinessList = [Business]()
    
    var searchBar = UISearchBar(frame: CGRect(x:0, y:0, width:180, height:20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessTableView.dataSource = self
        businessTableView.delegate = self
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = 100
        
        navigationItem.titleView = searchBar
        navigationItem.title = "Yelp"
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.resignFirstResponder()
        searchBar.keyboardType = UIKeyboardType.alphabet
        
        
        // Do any additional setup after loading the view, typically from a nib.
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            
            self.filterdBusinessList = self.businesses
            self.businessTableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
        }
        )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filterViewControler = navigationController.topViewController as! FiltersViewController
        filterViewControler.deleagte = self;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilter filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        let deals = filters["deals"] as? Bool
        let radius = filters["radius"] as? Int
        let sort = filters["sort"] as? YelpSortMode
        
        Business.searchWithTerm(term: "Restaurents", sort: sort, radius: radius, categories: categories, deals: deals, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.filterdBusinessList = self.businesses
            self.businessTableView.reloadData()
        })
    }

}

extension BusinessViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdBusinessList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableCell", for: indexPath) as! BusinessTableCell
        cell.business = filterdBusinessList[indexPath.row]
        return cell
    }
}

extension BusinessViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterdBusinessList = []
        for business in businesses{
            if((business.name?.contains(searchText))! || (business.categories?.contains(searchText))!){
                filterdBusinessList.append(business)
            }
        }
        if(searchText == ""){
            perform(#selector(hideKeyboardWithSearchBar(searchBar:)), with:searchBar, afterDelay:0)
            filterdBusinessList = businesses
        }
        businessTableView.reloadData()
    }
    
    func hideKeyboardWithSearchBar(searchBar:UISearchBar) {
        searchBar.resignFirstResponder()
    }

}
