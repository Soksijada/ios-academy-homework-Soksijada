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
import Kingfisher

final class HomeViewController: UIViewController {

    // MARK: - Properties
    
    var token: String?
    var showID: String?
    private var listOfTVShowItems = [TVShowItem]()
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getShowsList()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Private functions
    
    private func navigateToDetails(token: String, id: String) {
        let storyboard = UIStoryboard(name: "Details", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
        viewController.token = token
        viewController.showID = id
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - TableView deleting row
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            listOfTVShowItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
        }
    }

// MARK: - ShowList fetching and saving in listOfTVShowsItems

private extension HomeViewController {
    func getShowsList() {
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
                    self.listOfTVShowItems = shows.map { show in
                        var showItem = TVShowItem(image: UIImageView(image: UIImage(named: "icImagePlaceholder")), title: "No title", id: "No ID", imageUrl: "No url")
                        showItem.title = show.title
                        showItem.id = show.id
                        showItem.imageUrl = show.imageUrl
                        return showItem
                    }
                    print(shows)
                    self.tableView.reloadData()
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
        showID = item.id
        if let token = token, let id = showID {
            navigateToDetails(token: token, id: id)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfTVShowItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TVShowTableViewCell.self), for: indexPath) as! TVShowTableViewCell
        cell.configure(with: listOfTVShowItems[indexPath.row])
        return cell
    }
}
