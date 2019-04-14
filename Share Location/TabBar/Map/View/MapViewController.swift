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
    let viewModel = MapViewModel()
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func logoutButton(_ sender: Any) {
        self.viewModel.logout(self)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        indicator.loadingView(true)
        loadMapView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMapView()
        indicator.loadingView(true)
    }
    
    func loadMapView() {
        let requester = Requester()
        requester.getUsersData() {(success, error) in
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
        annotations = viewModel.parseAnnotations()
        self.mapView.addAnnotations(annotations)
    }
}
