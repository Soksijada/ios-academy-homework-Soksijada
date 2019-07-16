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
    @IBOutlet weak var createAnAccountButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Proporties
    
    var email: String = "emptyString"
    var userID: String = "emptyID"
    
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
    
    @IBAction func createAnAccountTouched(_ sender: UIButton) {
        _almofireCodableRegisterUserWith(email: userNameTextField.text!, password: passwordTextField.text!)
    }
    
    
    @IBAction func logInTouched(_ sender: UIButton) {
        _loginUserWith(email: userNameTextField.text!, password: passwordTextField.text!)
        
    }
    
    // MARK: - Private functions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configureUI() {
        logInButton.layer.cornerRadius = 10
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
                case .failure( _):
                    SVProgressHUD.showError(withStatus: "Failture")
                }
            }
        }
    }


