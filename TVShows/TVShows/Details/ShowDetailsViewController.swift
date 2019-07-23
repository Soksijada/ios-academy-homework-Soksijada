//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Krešimir Baković on 22/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class ShowDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roundButton: UIButton!
    
    // MARK: - Properties
    
    var token: String?
    var showID: String = "No ID"
    private var episodes: [Episode] = []
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        print("This is your showID: \(showID)")
        configureUI()
        getShowsTitleAndDescription()
        getListOfEpisodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Private functions
    
    public func configureUI() {
        roundButton.layer.cornerRadius = 25
        backButton.layer.cornerRadius = 20
    }
    
    // MARK: - Actions
    
    @IBAction private func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

    private extension ShowDetailsViewController {
        func setTableView() {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    extension ShowDetailsViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.row == 0 {
                return UITableView.automaticDimension
            } else {
                return 50
            }
        }
    }

    extension ShowDetailsViewController: UITableViewDataSource {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return episodes.count + 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DescriptionCell.self), for: indexPath) as! DescriptionCell
                    return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TVShowTableViewCell.self), for: indexPath) as!   TVShowTableViewCell
                return cell
                    }
                }
            }

    private extension ShowDetailsViewController {
        func getShowsTitleAndDescription() {
            SVProgressHUD.show()
            
            Alamofire
                .request(
                    "https://api.infinum.academy/api/shows/\(showID)",
                    method: .get,
                    encoding: JSONEncoding.default
                ).validate()
                .responseDecodableObject(keyPath: "data") {
                    (response: DataResponse<ShowInfo>) in
                    SVProgressHUD.dismiss()
                    switch response.result {
                    case .success(let showInfo):
                        print("This is your show info: \(showInfo)")
                    case .failure(let error):
                        print("API failure: \(error)")
                    }
                }
            }
        }

private extension ShowDetailsViewController {
    func getListOfEpisodes() {
        SVProgressHUD.show()
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows/\(showID)/episodes",
                method: .get,
                encoding: JSONEncoding.default
            ).validate()
            .responseDecodableObject(keyPath: "data") {
                (response: DataResponse<[Episode]>) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let episodes):
                    print("This is your show info: \(episodes)")
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
}
