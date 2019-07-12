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

    @IBOutlet weak var logInButton: UIButton!
    
    
    // MARK: - Proporties
    
    
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    // MARK: - Actions
    
    private func configureUI() {
        logInButton.layer.cornerRadius = 10
    }
    
    
    

}
