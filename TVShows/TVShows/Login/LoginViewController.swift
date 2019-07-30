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
        let username = UserDefaults.standard.string(forKey: "username")
        let password = UserDefaults.standard.string(forKey: "password")
        guard let username1 = username, let password1 = password else {
            return
        }
        _loginUserWith(email: username1, password: password1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        passwordTextField.text = nil
        userNameTextField.text = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissKeyboard()
    }
    
    // MARK: - Actions
    
    @IBAction private func rememberMeBoxTouched(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            UserDefaults.standard.set(userNameTextField.text, forKey: "username")
            UserDefaults.standard.set(passwordTextField.text, forKey: "password")
        }
    }
    
    @IBAction private func createAnAccountTouched() {
        guard let email = userNameTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            missingInputAlert()
            return
        }
        _almofireCodableRegisterUserWith(email: email, password: password)
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
        shakeAnimation(objectToShake: passwordTextField)
        shakeAnimation(objectToShake: userNameTextField)
        shakeAnimation(objectToShake: logInButton)
    }
    
    private func navigateToHome(token: String) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        viewController.token = token
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK - Animations
    
    private func shakeAnimation(objectToShake: UIControl) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        objectToShake.layer.add(animation, forKey: "shake")
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
        
        Alamofire.request("https://api.infinum.academy/api/users/sessions", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseDecodableObject(keyPath: "data") {
            [weak self]
            (response: DataResponse<LoginData>) in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(let user):
                print("Success: \(user)")
                self?.navigateToHome(token: user.token)
                SVProgressHUD.showSuccess(withStatus: "Success")
            case .failure(let error):
                print("API failure: \(error)")
                self?.loginFailureAlert()
            }
        }
    }
}
