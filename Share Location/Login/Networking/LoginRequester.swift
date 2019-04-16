//
//  LoginRequester.swift
//  Share Location
//
//  Created by Tiago Oliveira on 05/02/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

class LoginRequester {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func performLogin(username: String,
                      password: String,
                      completion: @escaping (_ success: Bool,_ errormsg: String?, _ error: Error?) -> Void) {
        var request = URLRequest(url: URL(string: Constants.loginURL)!)
        request.httpMethod = Constants.HttpMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // change to a Codable struct
        request.httpBody = """
            {\"udacity\":
            {\"username\": \"\(username)\",
            \"password\": \"\(password)\"}}
            """.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false, "ERROR", error)
                return
            }
            
            let range = 5..<data!.count
            guard let newData = data?.subdata(in: range) else {
                completion(false, "ERROR \(String(data: data!, encoding: .utf8)!)", nil)
                return
            }
            
            let parsedResult = try? JSONSerialization.jsonObject(with: newData, options: .allowFragments)
            
            guard let dictionaryResult = parsedResult as? [String: Any] else {
                completion(false, "ERROR \(String(data: newData, encoding: .utf8)!)", nil)
                return
            }
            
            guard let account = dictionaryResult["account"] as? [String:Any] else {
                completion(false, "ERROR \(String(data: newData, encoding: .utf8)!)", nil)
                return
            }
            
            guard let userID = account["key"] as? String else {
                completion(false, "ERROR \(String(data: newData, encoding: .utf8)!)", nil)
                return
            }
            
            self.appDelegate.userID = userID
            completion(true, nil, nil)
        }
        task.resume()
    }
}
