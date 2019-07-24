//
//  NewEpisodeViewController.swift
//  TVShows
//
//  Created by Krešimir Baković on 24/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit

class NewEpisodeViewController: UIViewController {
    
    // MARK: - Properties
    
    var token: String?
    var showID: String = "No ID"
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didSelectAddShow)
        )
        wrapInNavigationController()
        if let token = token{
            print("This is token on NewEpisode: \(token)")
            print("This is showID on NewEpisode: \(showID)")
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private functions
    
    @objc func didSelectAddShow() {
        
    }
    
    private func wrapInNavigationController() {
        let navigationController = UINavigationController(rootViewController: ShowDetailsViewController())
        present(navigationController, animated: true)
    }
}
