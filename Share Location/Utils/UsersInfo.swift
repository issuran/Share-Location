//
//  UsersInfo.swift
//  Share Location
//
//  Created by Tiago Oliveira on 01/04/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import MapKit

struct UsersInfo {
    
    //Users Data
    
    let firstName: String
    let lastName: String
    let mediaURL: String
    let lat: Double
    let long: Double
    let objectId: String
    let uniqueKey: String
        
    static var UsersArray : [UsersInfo] = []
    
    init?(dictionary: [String:Any]) {
        guard let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String,
            let mediaURL = dictionary["mediaURL"] as? String,
            let lat = dictionary["latitude"] as? Double,
            let long = dictionary["longitude"] as? Double,
            let objectId = dictionary["objectId"] as? String,
            let uniqueKey = dictionary["uniqueKey"] as? String else {
                return nil
        }
        self.firstName = firstName
        self.lastName = lastName
        self.mediaURL = mediaURL
        self.lat = lat
        self.long = long
        self.objectId = objectId
        self.uniqueKey = uniqueKey
    }
    
    static func UsersDataResults(_ results: [[String:Any]]) -> [UsersInfo] {
        var usersList = [UsersInfo]()
        
        //Users Data Results
        
        for result in results {
            if let UsersInfo = UsersInfo(dictionary: result) {
                usersList.append(UsersInfo)
            }
        }
        return usersList
    }
}
