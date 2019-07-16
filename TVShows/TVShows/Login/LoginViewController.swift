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
    @IBOutlet private weak var createAnAccountButton: UIButton!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    // MARK: - Proporties
    
    var email1: String = "emptyString"
    var userID1: String = "emptyID"
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    
    @IBAction private func rememberMeBoxTouched(_ sender: UIButton) {
        let image: UIImage? = sender.image(for: .normal)
        if image == UIImage(named: "ic-checkbox-empty") {
            sender.setImage(UIImage(named: "ic-checkbox-filled"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "ic-checkbox-empty"), for: .normal)
        }
    }
    
    @IBAction private func createAnAccountTouched(_ sender: UIButton) {
        if userNameTextField.text != "" && passwordTextField.text != "" {
            _almofireCodableRegisterUserWith(email: userNameTextField.text!, password: passwordTextField.text!)
        } else {
            missingInputAlert()
        }
    }
    
    
    @IBAction private func logInTouched(_ sender: UIButton) {
        if userNameTextField.text != "" && passwordTextField.text != "" {
            _loginUserWith(email: userNameTextField.text!, password: passwordTextField.text!)
        } else {
            missingInputAlert()
        }
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
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - Navigation
    
    @IBAction func navigateToHome(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
    // MARK: - Register + Automatic JSON parsing
    
    private extension LoginViewController {
        
        func _almofireCodableRegisterUserWith(email: String, password: String) {
            SVProgressHUD.show()
            
            let parameters: [String: String] = [
                "email": email,
                "password": password
            ]
            
            Alamofire.request("https://api.infinum.academy/api/users", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                    [weak self]
                    (response: DataResponse<User>) in
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success(let user):
                        print("Success: \(user)")
                        self?._loginUserWith(email: self!.userNameTextField.text!, password: self!.passwordTextField.text!)
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
            
        Alamofire.request("https://api.infinum.academy/api/users/sessions", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON {
                 dataResponse in
                SVProgressHUD.dismiss()
                switch dataResponse.result {
                case .success( _):
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(viewController, animated: true)
                case .failure( _):
                    SVProgressHUD.showError(withStatus: "Failture")
                    
                }
            }
        }
    }


