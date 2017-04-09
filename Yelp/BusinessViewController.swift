//
//  BusinessViewController.swift
//  Yelp
//
//  Created by Sethi, Pinkesh on 4/7/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessViewController: UIViewController, FilterViewControllerDelegate {

    
    @IBOutlet weak var businessTableView: UITableView!
    var businesses: [Business]!
    var filterdBusinessList = [Business]()
    var isMoreDataToLoad = false
    var offset = 10;
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
        MBProgressHUD.showAdded(to: self.view, animated: true)
//        self.navigationController?.navigationBar.barTintColor = UIColor.red
//        self.navigationController.navigationBar.tintColor = UIColor .red
//        self.navigationController?.navigationBar.isTranslucent = false
        
        // Do any additional setup after loading the view, typically from a nib.

        Business.searchWithTerm(term: "Restaurents",offset:offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            if(error == nil){
                self.businesses = businesses
            
                self.filterdBusinessList = self.businesses
                self.businessTableView.reloadData()
                if let businesses = businesses {
                    for business in businesses {
                        print(business.name!)
                        print(business.address!)
                    }
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }else{
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "filterSegue"){
            let navigationController = segue.destination as! UINavigationController
            let filterViewControler = navigationController.topViewController as! FiltersViewController
            filterViewControler.deleagte = self;
        }
        if(segue.identifier == "detailsSegue"){
            let businessDetailControler = segue.destination as! BusinessDetailViewController
            let cell = sender as! UITableViewCell
            let indexPath = businessTableView.indexPath(for: cell)
            businessDetailControler.business = filterdBusinessList[(indexPath?.row)!]
        }
        if(segue.identifier == "mapSegue"){
            let businessMapControler = segue.destination as! BusinessMapViewController
            businessMapControler.businesses = filterdBusinessList
        }
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
        
        Business.searchWithTerm(term: "Restaurents", offset:offset, sort: sort, radius: radius, categories: categories, deals: deals, completion: { (businesses: [Business]?, error: Error?) -> Void in
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
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
extension BusinessViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isMoreDataToLoad){
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = businessTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - businessTableView.bounds.size.height
        
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && businessTableView.isDragging) {
                isMoreDataToLoad = true
                loadMoreData()
            // ... Code to load more results ...
            }
        }
        
    }
    
    func loadMoreData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        offset += 10
        Business.searchWithTerm(term: "Restaurents",offset:offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.filterdBusinessList = self.businesses
            self.businessTableView.reloadData()
            self.isMoreDataToLoad = false
            MBProgressHUD.hide(for: self.view, animated: true)

        })
    }
}
