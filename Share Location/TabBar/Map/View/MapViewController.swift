//
//  MapViewController.swift
//  Share Location
//
//  Created by Tiago Oliveira on 31/03/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: BaseViewController, MKMapViewDelegate {
    var annotations = [MKPointAnnotation]()
    var indicator = Indicator()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let reuseId = "pin"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func logoutButton(_ sender: Any) {
    }
    
    @IBAction func refreshButton(_ sender: Any) {
    }
    
    @IBAction func addButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.fra
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMapView()
        indicator.loadingView(true)
    }
    
    func loadMapView() {
        let mapRequester = MapRequester()
        mapRequester.getUsersData() {(success, error) in
            if success {
                DispatchQueue.main.async {
                    self.loadMap()
                    self.indicator.loadingView(false)
                }
            } else {
                self.indicator.stopAnimating()
            }
        }
    }
    
    func loadMap() {
        self.mapView.removeAnnotations(annotations)
        annotations = [MKPointAnnotation]()
        for dictionary in UsersInfo.UsersArray {
            let lat = dictionary.lat
            let long = dictionary.long
            //unwrap?
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
}
