//
//  Requester.swift
//  Share Location
//
//  Created by Tiago Oliveira on 07/04/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit
import Foundation

class Requester {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getUdacityData(username: String,
                        password: String,
                        completion: @escaping (_ success: Bool,_ errormsg: String?, _ error: NSError?) -> Void) {
        
        var request = URLRequest(url: URL(string: Constants.udacityDataURL)!)
        request.httpMethod = Constants.HttpMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = """
            {\"udacity\":
            {\"username\":\"\(username)\",
            \"password\": \"\(password)\"}}
            """.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Error Status Code Not a 2xx!")
                return
            }
            
            guard let data = data else {
                print("No Data Available!")
                return
            }
            
            let newData = data.subdata(in: Range(uncheckedBounds: (5, data.count)))
            
            let parsedResult = try? JSONSerialization.jsonObject(with: newData, options: .allowFragments)
            
            guard let dictionary = parsedResult as? [String: Any] else {
                return
            }
            
            guard let account = dictionary["account"] as? [String:Any] else {
                return
            }
            
            guard let userID = account["key"] as? String else {
                return
            }
            
            self.appDelegate.userID = userID
            
            completion(true, nil, nil)
        }
        
        task.resume()
        
    }
    
    func getUserData(userID: String,
                     completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let url = "\(Constants.udacityUserDataURL)/\(userID)"
        let request = URLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Error Status Code Not a 2xx!")
                return
            }
            
            guard let data = data else {
                print("No Data Available!")
                return
            }
            
            let newData = data.subdata(in: Range(uncheckedBounds: (5, data.count)))
            
            let parsedResult: Any!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments)
            } catch {
                print("Couldnt Parse: '\(data.debugDescription)'")
                return
            }
            
            guard let dictionary = parsedResult as? [String: Any] else {
                print("Couldnt Parse: \(parsedResult.debugDescription)")
                return
            }
            
            guard let user = dictionary["user"] as? [String: Any] else {
                return
            }
            
            guard let firstName = user["first_name"] as? String, let lastName = user["last_name"] as? String else {
                print("Error")
                return
            }
            
            self.appDelegate.lastName = lastName
            self.appDelegate.firstName = firstName
            completion(true, nil)
        }
        task.resume()
    }
    
    func getUsersData(completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> Void {
        
        let url = "\(Constants.udacityUserDataURL)?order=-updatedAt&limit=100"
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(Constants.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            guard (error == nil) else {
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Error Status Code Not a 2xx!")
                return
            }
            
            guard let data = data else {
                print("No Data Available!")
                return
            }
            
            let parsedResult: Any!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } catch {
                print("Couldnt Parse: '\(data)'")
                return
            }
            
            if let results = parsedResult as? [String: Any] {
                if let resultSet = results["results"] as? [[String: Any]]{
                    UsersInfo.UsersArray = UsersInfo.UsersDataResults(resultSet)
                    completion(true, nil)
                }
            } else {
                print("Error")
            }            
        }
        task.resume()
    }
}
