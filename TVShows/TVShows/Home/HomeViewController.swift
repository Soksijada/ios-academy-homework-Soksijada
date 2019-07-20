//
//  HomeViewController.swift
//  TVShows
//
//  Created by Krešimir Baković on 14/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class HomeViewController: UIViewController {
    
    @IBAction func buttonTaped(_ sender: UIButton) {
        _getShowsList()
    }
    // MARK: - Properties
    
    var token: String?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var infoLabel: UILabel!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let thereIsToken = token {
            infoLabel.text = "Your token: \(thereIsToken)"
        } else {
            infoLabel.text = "There is no token."
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}



// MARK: - Login + Automatic JSON parsing

private extension HomeViewController {
    func _getShowsList() {
        
        let headers = ["Authorization": token]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers as? HTTPHeaders
            ).validate().responseDecodableObject(keyPath: "data") {
                (response: DataResponse<Show>) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let user):
                    print("Success: \(user)")
                case .failure(let error):
                    print("API failure: \(error)")
                }
            }
        }
    }


