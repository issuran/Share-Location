//
//  ViewController.swift
//  Share Location
//
//  Created by Tiago Oliveira on 05/02/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.viewModel = LoginViewModel()
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        guard let url = URL(string: Constants.signUpURL) else { return }
        let udacitySignUp = SFSafariViewController(url: url)
        present(udacitySignUp, animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if viewModel.isReadyToPerformRequest() {
            print("ready")
        } else {
            print("NOT ready")
        }
    }
}
