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
    
    func postNew(student: UsersInfo, location: String, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {

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
            
            if let error = error {
                completion(false, "Sorry, I was unable to process your request due to \(error.localizedDescription)")
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(false, "Not success posting new location! Please, try again!")
                return
            }
            
            completion(true, nil)
        }
        task.resume()
    }
    
    func updateUserData(student: UsersInfo, location: String, completion: @escaping (_ success: Bool, _ error: String?)->Void) {
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
            
            if let error = error {
                completion(false, "Sorry, I was unable to process your request due to \(error.localizedDescription)")
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(false, "Not success posting new location! Please, try again!")
                return
            }
            
            completion(true, nil)
        }
        task.resume()
    }
    
    func getUsersData(completion: @escaping (_ success: Bool, _ error: String?) -> Void) -> Void {
        
        let url = "\(Constants.studentLocationURL)?order=-updatedAt&limit=100"
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(Constants.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if let error = error {
                completion(false, "Sorry, I had a problem due to \(error.localizedDescription)")
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(false, "Not success posting new location! Please, try again!")
                return
            }
            
            guard let data = data else {
                completion(false, "No Data Available!")
                return
            }
            
            let parsedResult: Any!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } catch {
                completion(false, "Couldnt Parse: '\(data)'")
                return
            }
            
            if let results = parsedResult as? [String: Any] {
                if let resultSet = results["results"] as? [[String: Any]]{
                    UsersInfo.UsersArray = UsersInfo.UsersDataResults(resultSet)
                    completion(true, nil)
                }
            } else {
                completion(false, "No success on handling your results!")
            }
        }
        task.resume()
    }
}
