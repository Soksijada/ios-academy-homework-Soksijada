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

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var button: UIButton!
    
    // MARK: - Proporties
    
    private var numberOfTaps = 0
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        activityIndicator.startAnimating()  // Starting animation of activityIndicator
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.activityIndicator.stopAnimating()
        }  // Delaying stopIndicator function
    }
    
    // MARK: - Actions
    
    private func configureUI() {
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction private func buttonTouched() {
        numberOfTaps += 1
        label.text = "Number of taps: \(numberOfTaps)"
        if activityIndicator.isHidden {
            activityIndicator.startAnimating()
            button.setTitle("Stop", for: UIControl.State.normal)
        } else {
            activityIndicator.stopAnimating()
            button.setTitle("Start", for: UIControl.State.normal)
        }
    }
}
