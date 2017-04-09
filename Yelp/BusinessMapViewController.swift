//
//  BusinessMapViewController.swift
//  Yelp
//
//  Created by Sethi, Pinkesh on 4/10/17.
//  Copyright © 2017 Sethi, Pinkesh. All rights reserved.
//

import UIKit
import MapKit
class BusinessMapViewController: UIViewController {

    var businesses :[Business]!
   
    @IBOutlet weak var businessResultMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(location: centerLocation)
        addAnnotationAtCoordinate()

        // Do any additional setup after loading the view.
    }

    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        businessResultMapView.setRegion(region, animated: false)
    }
    
    // add an Annotation with a coordinate: CLLocationCoordinate2D
    func addAnnotationAtCoordinate() {
        var annotations = [MKPointAnnotation]()
        for business in businesses{
            let annotation = MKPointAnnotation()
            annotation.coordinate = business.coordinate!
            annotation.title = business.name
            annotations.append(annotation)
        }
        businessResultMapView.addAnnotations(annotations)
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
