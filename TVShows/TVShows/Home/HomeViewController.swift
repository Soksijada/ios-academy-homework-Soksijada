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

final class HomeViewController: UIViewController {

    
    // MARK: - Properties
    
    var token: String?
    private var listOfShows = [Show]()
    private var listOfTVShowItems = [TVShowItem]()
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Shows"
        self.navigationItem.hidesBackButton = true
        _getShowsList()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    
    
    // MARK: - Private functions
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            listOfTVShowItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
  
}



    // MARK: - ShowList fetching and saving in listOfTVShowsItems

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
                        print("Success this is your show list:")
                        for show in shows {
                            self.listOfShows.append(show)
                            print(show.title)
                            var showItem = TVShowItem(image: UIImage(named: "icImagePlaceholder"), title: "No title")
                            showItem.image = UIImage(named: "icImagePlaceholder")
                            showItem.title = show.title
                            self.listOfTVShowItems.append(showItem)
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print("API failure: \(error)")
                    }
                }
            }
        }

    // MARK: - Setting up table view

        private extension HomeViewController {
            func setupTableView() {
                tableView.estimatedRowHeight = 110
                tableView.rowHeight = UITableView.automaticDimension
                tableView.tableFooterView = UIView()
                tableView.delegate = self
                tableView.dataSource = self
            }
        }

    extension HomeViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let item = listOfTVShowItems[indexPath.row]
            print("Selected Item: \(item)")
        }
    }

    extension HomeViewController: UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // We need to tell the table view, how many rows we have in each section, because we only have one section now, we can just return our items count.
            return listOfTVShowItems.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TVShowTableViewCell.self), for: indexPath) as! TVShowTableViewCell
            cell.configure(with: listOfTVShowItems[indexPath.row])
            return cell
        }
    }
