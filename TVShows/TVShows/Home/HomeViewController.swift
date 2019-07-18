//
//  HomeViewController.swift
//  TVShows
//
//  Created by Krešimir Baković on 14/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var token: String!
    @IBOutlet private weak var infoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        infoLabel.text = token

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
