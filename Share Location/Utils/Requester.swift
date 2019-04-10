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
    
    func getUdacityData(username: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool,_ errormsg: String?, _ error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL)
        request.httpMethod = Constants.HttpMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func handleError(error: String, errormsg: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForAuth(false, errormsg, NSError(domain: "getUdacityData", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            //Parse Data
            
            let stringData = String(data: data, encoding: String.Encoding.utf8)
            print(stringData ?? "Done!")
            
            let newData = data.subdata(in: Range(uncheckedBounds: (5, data.count)))
            let stringnewData = String(data: newData, encoding: String.Encoding.utf8)
            print(stringnewData ?? "Done!")
            
            let parsedResult = try? JSONSerialization.jsonObject(with: newData, options: .allowFragments)
            
            guard let dictionary = parsedResult as? [String: Any] else {
                return
            }
            
            guard let account = dictionary["account"] as? [String:Any] else {
                return
            }
            
            //Utilize Data
            
            guard let userID = account["key"] as? String else {
                return
            }
            
            self.appDelegate.userID = userID
            
            completionHandlerForAuth(true, nil, nil)
        }
        
        task.resume()
        
    }
    
    func getUserData(userID: String, completionHandlerForAuth: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/users/\(userID)")! as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForAuth(false, NSError(domain: "getUserData", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Your Request Returned A Status Code Other Than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError(error: "No Data Was Returned By The Request!")
                return
            }
            
            let newData = data.subdata(in: Range(uncheckedBounds: (5, data.count)))
            
            let parsedResult: Any!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments)
            } catch {
                sendError(error: "Could Not Parse The Data As JSON: '\(data)'")
                return
            }
            
            guard let dictionary = parsedResult as? [String: Any] else {
                sendError(error: "Cannot Parse")
                return
            }
            
            guard let user = dictionary["user"] as? [String: Any] else {
                return
            }
            
            guard let lastName = user["last_name"] as? String else {
                sendError(error: "Cannot Find Key 'key' In \(user)")
                return
            }
            
            guard let firstName = user["first_name"] as? String else {
                sendError(error: "Cannot Find Key 'key' In \(user)")
                return
            }
            self.appDelegate.lastName = lastName
            self.appDelegate.firstName = firstName
            completionHandlerForAuth(true, nil)
        }
        task.resume()
    }
    
    func getUsersData(completionHandlerForData: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> Void {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt&limit=100")! as URL)
        request.addValue(Constants.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForData(false, NSError(domain: "getStudentData", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Your Request Returned A Status Code Other Than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError(error: "No Data Was Returned By The Request!")
                return
            }
            
            //Parse Data
            let parsedResult: Any!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } catch {
                sendError(error: "Could Not Parse The Data As JSON: '\(data)'")
                return
            }
            
            if let results = parsedResult as? [String: Any] {
                if let resultSet = results["results"] as? [[String: Any]]{
                    UsersInfo.UsersArray = UsersInfo.UsersDataResults(resultSet)
                    print("yehey? \(UsersInfo.UsersArray)")
                    completionHandlerForData(true, nil)
                }
            } else {
                sendError(error: "Sorry! Edit!")
            }
            
        }
        task.resume()
    }
}
