//
//  EpisodeTableViewCell.swift
//  TVShows
//
//  Created by Krešimir Baković on 25/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit

final class EpisodeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet private weak var seasonLabel: UILabel!
    @IBOutlet private weak var episodeNumberLabel: UILabel!
    @IBOutlet private weak var episodeTitleLabel: UILabel!
    
    // MARK: - Lifecycle methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        seasonLabel.text = nil
        episodeTitleLabel.text = nil
        episodeNumberLabel.text = nil
    }
}

// MARK: - Configure function

extension EpisodeTableViewCell {
    func configure(with item: Episode) {
        seasonLabel.text = item.season
        episodeNumberLabel.text = item.episodeNumber
        episodeTitleLabel.text = item.title
    }
}
