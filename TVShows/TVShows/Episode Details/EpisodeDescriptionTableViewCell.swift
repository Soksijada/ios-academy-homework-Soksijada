//
//  EpisodeDescriptionTableViewCell.swift
//  TVShows
//
//  Created by Krešimir Baković on 28/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit

final class EpisodeDescriptionTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var episodeTitleLabel: UILabel!
    @IBOutlet private weak var seasonNumber: UILabel!
    @IBOutlet private weak var episodeNumber: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var episodeImage: UIImageView!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        episodeTitleLabel.text = nil
        descriptionLabel.text = nil
        seasonNumber.text = nil
        episodeNumber.text = nil
    }
}

// MARK: - Configure function
    
extension EpisodeDescriptionTableViewCell {
    func configure(with item: Episode) {
        episodeTitleLabel.text = item.title
        descriptionLabel.text = item.description
        seasonNumber.text = item.season
        episodeNumber.text = item.episodeNumber
        let url = URL(string: "https://api.infinum.academy" + "\(item.imageUrl)")
        episodeImage.kf.setImage(with: url)
    }
}
