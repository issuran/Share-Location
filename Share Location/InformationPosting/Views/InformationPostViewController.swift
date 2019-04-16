//
//  InformationPostViewController.swift
//  Share Location
//
//  Created by Tiago Oliveira on 14/04/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationPostViewController: BaseViewController {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    var pinnator = Pinnator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinnator.center = self.view.center
        self.view.addSubview(pinnator)
    }
    
    @IBAction func cancelAddAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationAction(_ sender: Any) {
        self.pinnator.loadingView(true)
        
        let localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = addressTextField.text
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            if localSearchResponse == nil {
                print("Error")
                self.pinnator.loadingView(false)
                return
            }
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = self.addressTextField.text!
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            let latitude = localSearchResponse!.boundingRegion.center.latitude
            let longitude = localSearchResponse!.boundingRegion.center.longitude
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "ConfirmNewLocationViewController") as! ConfirmNewLocationViewController
            controller.location = self.addressTextField.text ?? ""
            controller.mediaURL = self.linkTextField.text ?? ""
            controller.pointAnnotation = pointAnnotation
            controller.latitude = latitude
            controller.longitude = longitude
            self.pinnator.loadingView(false)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}
