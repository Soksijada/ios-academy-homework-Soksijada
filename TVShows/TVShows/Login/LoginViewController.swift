//
//  LoginViewController.swift
//  TVShows
//
//  Created by Krešimir Baković on 06/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet private weak var logInButton: UIButton!
    
    // MARK: - Proporties
    
    
    
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
    
    
    // MARK: - Private functions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func configureUI() {
        logInButton.layer.cornerRadius = 10
    }
}
