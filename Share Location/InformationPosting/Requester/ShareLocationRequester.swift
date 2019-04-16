//
//  ShareLocationRequester.swift
//  Share Location
//
//  Created by Tiago Oliveira on 14/04/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit

class ShareLocationRequester {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func postNew(student: UsersInfo, location: String, completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {

        var request = URLRequest(url: URL(string: Constants.studentLocationURL)!)
        request.httpMethod = Constants.HttpMethod.post.rawValue
        request.addValue(Constants.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = """
            {\"uniqueKey\": \"\(student.uniqueKey)\",
            \"firstName\": \"\(student.firstName)\",
            \"lastName\": \"\(student.lastName)\",
            \"mapString\": \"\(location)\",
            \"mediaURL\": \"\(student.mediaURL)\",
            \"latitude\": \(student.lat),
            \"longitude\": \(student.long)}
            """.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil, data != nil else { return }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Error Status Code Not a 2xx!")
                return
            }
            
            completion(true, nil)
        }
        task.resume()
    }
    
    func updateUserData(student: UsersInfo, location: String, completion: @escaping (_ success: Bool, _ error: NSError?)->Void) {
        let url = "\(Constants.studentLocationURL)/\(student.objectId)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = Constants.HttpMethod.put.rawValue
        request.addValue(Constants.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = """
            {\"uniqueKey\": \"\(student.uniqueKey)\",
            \"firstName\": \"\(student.firstName)\",
            \"lastName\": \"\(student.lastName)\",
            \"mapString\": \"\(location)\",
            \"mediaURL\": \"\(student.mediaURL)\",
            \"latitude\": \(student.lat),
            \"longitude\": \(student.long)}
            """.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard error == nil, data != nil else { return }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your Request Returned A Status Code Other Than 2xx!")
                return
            }
            
            completion(true, nil)
        }
        task.resume()
    }
}
