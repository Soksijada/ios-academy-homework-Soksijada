//
//  NewEpisodeViewController.swift
//  TVShows
//
//  Created by Krešimir Baković on 24/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

final class NewEpisodeViewController: UIViewController {
    
    // MARK: - Properties
    
    var token: String?
    var showID: String = "No ID"
    
    // MARK: - Outlets
    
    @IBOutlet private weak var episodeTitleTextField: UITextField!
    @IBOutlet private weak var seasonNumberTextField: UITextField!
    @IBOutlet private weak var episodeNumberTextField: UITextField!
    @IBOutlet private weak var episodeDescriptionTextField: UITextField!
    
    // MARK: - Actions
    
    @IBAction func cancleAddingShow() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addShow() {
        guard let episodeTitle = episodeTitleTextField.text, let seasonNumber = seasonNumberTextField.text, let episodeNumber = episodeNumberTextField.text, let episodeDescription = episodeDescriptionTextField.text, !episodeTitle.isEmpty, !seasonNumber.isEmpty, !episodeNumber.isEmpty, !episodeDescription.isEmpty  else {
            missingInputAlert()
            return
        }
        makeNewEpisode(showId: showID, title: episodeTitle, description: episodeDescription, episodeNumber: episodeNumber, season: seasonNumber)
    }
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private functions
    
    private func missingInputAlert() {
        let alert = UIAlertController(title: "Some fields are empty", message: "Please fill all the fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func episodeAddingAlert() {
        let alert = UIAlertController(title: "Episode could not be added", message: "Error occurred", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

// MARK: - Making new episode + Automatic JSON parsing

private extension NewEpisodeViewController {
    
    func makeNewEpisode(showId: String, title: String, description: String, episodeNumber: String, season: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "showId": showId,
            "title": title,
            "description": description,
            "episodeNumber": episodeNumber,
            "season": season
        ]
        let headers = ["Authorization": token]
        
        Alamofire.request("https://api.infinum.academy/api/episodes", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers as? HTTPHeaders)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                [weak self]
            (response: DataResponse<NewEpisode>) in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(let newepisode):
                print("New episode: \(newepisode)")
                self?.dismiss(animated: true, completion: nil)
                let storyboard = UIStoryboard(name: "Details", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
                let episode = Episode(_id: newepisode.showId, title: newepisode.title, description: newepisode.description, imageUrl: "no url", episodeNumber: newepisode.episodeNumber, season: newepisode.season)
                viewController.episodes.append(episode)
            case .failure(let error):
                print("API failure: \(error)")
                self?.episodeAddingAlert()
            }
        }
    }
}
