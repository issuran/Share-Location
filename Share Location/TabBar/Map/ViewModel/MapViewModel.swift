//
//  MapViewModel.swift
//  Share Location
//
//  Created by Tiago Oliveira on 11/04/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewModel {
    func logout(_ controller: UIViewController) {
        controller.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func parseAnnotations() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for dictionary in UsersInfo.UsersArray {
            let lat = dictionary.lat
            let long = dictionary.long
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
        
        return annotations
    }
}
