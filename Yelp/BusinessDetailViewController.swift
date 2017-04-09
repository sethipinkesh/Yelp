//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Sethi, Pinkesh on 4/10/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailViewController: UIViewController {
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessThumbImageView: UIImageView!

    @IBOutlet weak var addressLabelView: UILabel!
    @IBOutlet weak var businessDescriptionLabel: UILabel!
    @IBOutlet weak var currentMapView: MKMapView!
    var business :Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(location: centerLocation)
//        addAnnotationAtCoordinate()
        addAnnotationAtAddress()
        businessNameLabel.text = business.name
        businessThumbImageView.setImageWith(business.imageURL!)
        businessDescriptionLabel.text = business.categories
        addressLabelView.text = business.address
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        currentMapView.setRegion(region, animated: false)
    }

    // add an Annotation with a coordinate: CLLocationCoordinate2D
    func addAnnotationAtCoordinate() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = business.coordinate!
        annotation.title = business.name
        currentMapView.addAnnotation(annotation)
    }

    // add an annotation with an address: String
    func addAnnotationAtAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(business.address!) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let coordinate = placemarks.first!.location!
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate.coordinate
                    annotation.title = self.business.name   
                    self.currentMapView.addAnnotation(annotation)
                }
            }
        }
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
