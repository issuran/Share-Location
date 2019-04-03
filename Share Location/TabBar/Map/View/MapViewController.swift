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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //loadMapView()
        indicator.loadingView(true)
    }
    
    func loadMapView() {
        
    }
}
