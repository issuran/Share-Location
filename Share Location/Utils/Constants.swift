//
//  Constants.swift
//  Share Location
//
//  Created by Tiago Oliveira on 05/02/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

struct Constants {
    static let signUpURL = "https://auth.udacity.com/sign-up"
    static let loginURL = "https://onthemap-api.udacity.com/v1/session"
    static let studentLocationURL = "https://parse.udacity.com/parse/classes/StudentLocation"
    static let udacityDataURL = "https://www.udacity.com/api/session"
    
    static let parseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
    enum HttpMethod: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
    }
}
