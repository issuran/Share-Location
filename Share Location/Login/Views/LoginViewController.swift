//
//  ViewController.swift
//  Share Location
//
//  Created by Tiago Oliveira on 05/02/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        getUserEntered()
        if viewModel.isReadyToPerformRequest() {
            let login = LoginRequester()
            login.performLogin(username: viewModel.email, password: viewModel.password) { (success, message, error) in
                
                if success {
                    DispatchQueue.main.async {
                        if let tabbar = (self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController) {
                            self.present(tabbar, animated: true, completion: nil)
                        }
                    }
                } else {
                    self.alert(message: message!)
                }
            }
        } else {
            self.alert(message: "Fill all the fields before trying to login!")
        }
    }
    
    func getUserEntered() {
        viewModel.email = emailTextField.text ?? ""
        viewModel.password = passwordTextField.text ?? ""
    }
}
