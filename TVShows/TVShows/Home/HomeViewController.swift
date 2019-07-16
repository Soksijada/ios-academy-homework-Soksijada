//
//  HomeViewController.swift
//  TVShows
//
//  Created by Krešimir Baković on 14/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var email: String = "empty"
    var userID: String = "empty"
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let objekt = LoginViewController()
        email = objekt.email
        userID = objekt.userID
        userEmailLabel.text = "User Email: \(email)"
        userIDLabel.text = "User ID: \(userID)"

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
