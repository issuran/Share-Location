//
//  AppDelegate.swift
//  Share Location
//
//  Created by Tiago Oliveira on 05/02/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userID: String?

    var firstName: String = ""
    var lastName: String = ""
    var objectId: String = ""
    var uniqueKey: String = ""
    
    var willOverwrite: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        userID = ""
        return true
    }
}

