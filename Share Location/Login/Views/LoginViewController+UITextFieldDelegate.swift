//
//  LoginViewController+UITextFieldDelegate.swift
//  Share Location
//
//  Created by Tiago Oliveira on 05/02/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var text = textField.text else {
            return false
        }
        
        text.append(string)
        
        if range.length == text.count {
            text = ""
        }
        
        if textField == emailTextField {
            viewModel.email = text
        } else {
            viewModel.password = text
        }
        return true
    }
}
