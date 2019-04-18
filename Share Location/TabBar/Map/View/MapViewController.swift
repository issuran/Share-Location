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
    var pinnator = Pinnator()
    let viewModel = MapViewModel()
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func logoutButton(_ sender: Any) {
        self.viewModel.logout(self)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        pinnator.loadingView(true)
        loadMapView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinnator.center = self.view.center
        self.view.addSubview(pinnator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMapView()
        pinnator.loadingView(true)
    }
    
    func loadMapView() {
        let requester = ShareLocationRequester()
        requester.getUsersData() {(success, error) in
            if success {
                DispatchQueue.main.async {
                    self.loadMap()
                    self.pinnator.loadingView(false)
                }
            } else {
                self.pinnator.stopAnimating()
            }
        }
    }
    
    func loadMap() {
        self.mapView.removeAnnotations(annotations)
        annotations = viewModel.parseAnnotations()
        self.mapView.addAnnotations(annotations)
    }
}
