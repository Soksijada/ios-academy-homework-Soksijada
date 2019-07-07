//
//  LoginViewController.swift
//  TVShows
//
//  Created by Krešimir Baković on 06/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    var numberOfTaps = 0
    let buttonCornerRadius: CGFloat = 10   // *****
    let textLabelCornerRadius: CGFloat = 5 //
    let buttonBorderWidth: CGFloat = 1     // Setting values for corner radius and border width of button and label
    let textLabelBorderWidth: CGFloat = 1  //
    let timeOfActivityIndicator = 3        // *****

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.cornerRadius = buttonCornerRadius
        button.layer.borderWidth = buttonBorderWidth
        button.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = textLabelCornerRadius
        label.layer.borderWidth = textLabelBorderWidth
        label.layer.borderColor = UIColor.black.cgColor
        activityIndicator.startAnimating()  // Starting animation of activityIndicator
        Timer.scheduledTimer(timeInterval: TimeInterval(timeOfActivityIndicator), target: self, selector: #selector(stopIndicator), userInfo: nil, repeats: false) // Delaying stopIndicator function
        
    }
    
    @objc func stopIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    @IBAction func buttonTouched(_ sender: UIButton) {
        numberOfTaps += 1
        label.text = "Number of taps: \(numberOfTaps)"
        if activityIndicator.isHidden == true {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            button.setTitle("Stop", for: UIControl.State.normal)
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            button.setTitle("Start", for: UIControl.State.normal)
        }
    }
}
