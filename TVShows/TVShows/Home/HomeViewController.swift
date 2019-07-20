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

    
    // MARK: - Properties
    
    var token: String?
    var listOfShows = [Show]()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var infoLabel: UILabel!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _getShowsList()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    
    
    // MARK: - Private functions
    
}



    // MARK: - ShowList fetching and saving in listOfShows

    private extension HomeViewController {
        func _getShowsList() {
            SVProgressHUD.show()
            let headers = ["Authorization": token]
            
            Alamofire
                .request(
                    "https://api.infinum.academy/api/shows",
                    method: .get,
                    encoding: JSONEncoding.default,
                    headers: headers as? HTTPHeaders
                ).validate().responseDecodableObject(keyPath: "data") {
                    (response: DataResponse<[Show]>) in
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success(let shows):
                        print("Success \(shows)")
                        for show in shows {
                            self.listOfShows.append(show)
                        }
                    case .failure(let error):
                        print("API failure: \(error)")
                    }
                }
            }
        }


