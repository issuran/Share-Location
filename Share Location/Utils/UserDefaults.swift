//
//  UserDefaults.swift
//  Share Location
//
//  Created by Tiago Oliveira on 01/04/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit

class UserDefaults {
    func getUsersData(completionHandlerForData: @escaping (_ success: Bool, _ error: NSError?) -> Void) -> Void {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt&limit=100")! as URL)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForData(false, NSError(domain: "getStudentData", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError(error: "There Was An Error With Your Request: \(error.debugDescription)")
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
                if let resultSet = results["results"] as? [[String: Any]] {                    
                    UsersInfo.UsersArray = UsersInfo.UsersDataResults(resultSet)
                    completionHandlerForData(true, nil)
                }
            } else {
                sendError(error: "Sorry! Edit!")
            }
            
        }
        task.resume()
    }
}
