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

final class ShowDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var roundButton: UIButton!
    
    // MARK: - Properties
    
    var token: String?
    var showID: String = "No ID"
    var episodes: [Episode] = []
    private var showInformation: ShowInfo?
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        print("This is your showID: \(showID)")
        setTableView()
        configureUI()
        getShowsTitleAndDescription()
        getListOfEpisodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        getListOfEpisodes()
        self.tableView.reloadData()
    }
    
    // MARK: - Private functions
    
    private func configureUI() {
        roundButton.layer.cornerRadius = 25
        backButton.layer.cornerRadius = 20
    }
    
    // MARK: - Actions
    
    @IBAction private func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func goToNewEpisodeScreen() {
        let storyboard = UIStoryboard(name: "NewEpisode", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewEpisodeViewController") as! NewEpisodeViewController
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.token = token
        viewController.showID = showID
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - Setting tableView

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
            cell.configure(with: showInformation ?? ShowInfo(type: "", title: "No title", description: "No description", _id: "No ID", likesCount: 0, imageUrl: ""))
                return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EpisodeTableViewCell.self), for: indexPath) as!   EpisodeTableViewCell
            cell.configure(with: episodes[indexPath.row - 1])
            return cell
                }
            }
        }

// MARK: - getShowsTitleAndDescription + Automatic JSON parsing

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
                    self.showInformation = showInfo
                    print("This is your show info: \(showInfo)")
                case .failure(let error):
                    print("API failure: \(error)")
                }
            }
        }
    }

// MARK: - GetListOfEpisodes + Automatic JSON parsing

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
                    self.episodes = episodes.map { episode in
                        var episodeItem = Episode(_id: "No ID", title: "No title", description: "No description", imageUrl: "No URL", episodeNumber: "No episode number", season: "No season ")
                        episodeItem._id = episode._id
                        episodeItem.title = episode.title
                        episodeItem.description = episode.description
                        episodeItem.imageUrl = episode.imageUrl
                        episodeItem.episodeNumber = episode.episodeNumber
                        episodeItem.season = episode.season
                        return episodeItem
                    }
                    self.tableView.reloadData()
                    print("These are your show episodes: \(episodes)")
                case .failure(let error):
                    print("API failure: \(error)")
                }
            }
        }
    }
