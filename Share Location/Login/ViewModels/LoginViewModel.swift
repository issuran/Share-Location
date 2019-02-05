//
//  LoginViewModel.swift
//  Share Location
//
//  Created by Tiago Oliveira on 05/02/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    var email: String
    var password: String
    
    init() {
        self.email = ""
        self.password = ""
    }
    
    func isReadyToPerformRequest() -> Bool {
        if email.isEmpty || password.isEmpty {
            return false
        } else {
            return true
        }
    }
    
}
