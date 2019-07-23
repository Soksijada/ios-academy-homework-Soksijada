//
//  LoginViewController.swift
//  TVShows
//
//  Created by Krešimir Baković on 06/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Actions
    
    @IBAction private func rememberMeBoxTouched(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction private func createAnAccountTouched() {
        guard let email = userNameTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            missingInputAlert()
            return
        }
        RegisterUserWith(email: email, password: password)
    }
    
    @IBAction private func logInTouched() {
        guard let email = userNameTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            missingInputAlert()
            return
        }
        _loginUserWith(email: email, password: password)
    }
    
    // MARK: - Private functions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configureUI() {
        logInButton.layer.cornerRadius = 10
    }
    
    private func missingInputAlert() {
        let alert = UIAlertController(title: "Missing user name or password", message: "Please check your username and password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    private func loginFailureAlert() {
        let alert = UIAlertController(title: "Wrong user name or password", message: "Please check your username and password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func navigateToHome(token: String) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
         viewController.token = token
        navigationController?.pushViewController(viewController, animated: true)
    }
}

    // MARK: - Register + Automatic JSON parsing
    
    private extension LoginViewController {
        
        func RegisterUserWith(email: String, password: String) {
            SVProgressHUD.show()
            
            let parameters: [String: String] = [
                "email": email,
                "password": password
            ]
            
            Alamofire.request("https://api.infinum.academy/api/users", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    [weak self]
                    (response: DataResponse<User>) in
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success(let user):
                        print("Success: \(user)")
                        guard let self = self else {
                            return
                        }
                        self._loginUserWith(email: self.userNameTextField.text!, password: self.passwordTextField.text!)
                    case .failure(let error):
                        print("API failure: \(error)")
                    }
                }
            }
        }

    // MARK: - Login + Automatic JSON parsing

    private extension LoginViewController {
        
        func _loginUserWith(email: String, password: String){
            SVProgressHUD.show()
            
            let parameters: [String: String] = [
                "email": email,
                "password": password
            ]
            
            Alamofire.request("https://api.infinum.academy/api/users/sessions", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data") {
                [weak self]
                (response: DataResponse<LoginData>) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let user):
                    print("Success: \(user)")
                    guard let self = self else {
                        return
                    }
                    self.navigateToHome(token: user.token)
                    SVProgressHUD.showSuccess(withStatus: "Success")
                case .failure(let error):
                    print("API failure: \(error)")
                    self?.loginFailureAlert()
                }
            }
        }
    }
