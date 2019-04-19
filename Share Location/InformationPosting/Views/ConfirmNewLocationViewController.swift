//
//  ConfirmNewLocationViewController.swift
//  Share Location
//
//  Created by Tiago Oliveira on 14/04/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ConfirmNewLocationViewController: BaseViewController {
    
    var location: String = ""
    var appDelegate: AppDelegate!
    var mediaURL: String = ""
    
    var pointAnnotation = MKPointAnnotation()
    var latitude: Double = 0.00
    var longitude: Double = 0.00
    let requester = ShareLocationRequester()
    
    let pinnator = Pinnator()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinnator.center = self.view.center
        self.view.addSubview(pinnator)
        appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: pointAnnotation.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.centerCoordinate = pointAnnotation.coordinate
        self.mapView.addAnnotation(pinAnnotationView.annotation!)
        self.mapView.delegate = self as? MKMapViewDelegate
    }
    
    @IBAction func finishAction(_ sender: Any) {
        let userData = UsersInfo(dictionary: ["firstName" : appDelegate.firstName as AnyObject, "lastName": appDelegate.lastName as AnyObject, "mediaURL": mediaURL as AnyObject, "latitude": latitude as AnyObject, "longitude": longitude as AnyObject, "objectId": appDelegate.objectId as AnyObject, "uniqueKey": appDelegate.uniqueKey as AnyObject])
        
        if mediaURL == "" {
            self.alert(message: "Please, type your current location!")
        } else {
            if checkURL(mediaURL) {
                self.pinnator.loadingView(true)
                if appDelegate.willOverwrite {
                    requester.updateUserData(student: userData!, location: location) { success, result in
                        DispatchQueue.main.async{
                            self.pinnator.loadingView(false)
                            if success {
                                self.navigateTabBar(self)
                            } else {
                                self.alert(message: result!)
                            }
                        }
                    }
                    
                } else {
                    requester.postNew(student: userData!, location: location) {success, result in
                        DispatchQueue.main.async{
                            self.pinnator.loadingView(false)
                            if success {
                                if let tabbar = (self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController) {
                                    self.present(tabbar, animated: true, completion: nil)
                                }
                            } else {
                                self.alert(message: result!)
                            }
                        }
                    }
                }
            } else {
                self.alert(message: "Could not open your URL!\nPlease try again!")
            }
        }
    }
    
    @IBAction func dismissConfirmAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func checkURL(_ url: String) -> Bool {
        if let url = URL(string: url) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func navigateTabBar(_ controller: UIViewController) {
        if let tabbar = (self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController) {
            self.present(tabbar, animated: true, completion: nil)
        }
    }
}
