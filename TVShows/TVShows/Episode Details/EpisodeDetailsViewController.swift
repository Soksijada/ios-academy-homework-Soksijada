//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Krešimir Baković on 28/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit

final class EpisodeDetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var backButton: UIButton!
    
    // MARK: - Properties
    
    var episode: Episode?
    var token: String?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction private func navigateToShowDetails() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private functions
    
    private func configureUI() {
        backButton.layer.cornerRadius = 20
    }
}

// MARK: - Setting tableView

private extension EpisodeDetailsViewController {
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension EpisodeDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "Comments", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
            viewController.token = token
            viewController.episode = episode
            navigationController?.pushViewController(viewController, animated: true)
        }
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

extension EpisodeDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EpisodeDescriptionTableViewCell.self), for: indexPath) as! EpisodeDescriptionTableViewCell
            cell.configure(with: episode ?? Episode(id: "No id", title: "No title", description: "No description", imageUrl: "No url", episodeNumber: "No episode number", season: "No season"))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentTableViewCell.self), for: indexPath) as! CommentTableViewCell
            return cell
        }
    }
}
