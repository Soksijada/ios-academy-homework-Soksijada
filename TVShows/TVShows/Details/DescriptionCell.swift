//
//  DescriptionCell.swift
//  TVShows
//
//  Created by Krešimir Baković on 23/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit

final class DescriptionCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet private weak var showTitleLabel: UILabel!
    @IBOutlet private weak var showDescriptionLabel: UILabel!
    @IBOutlet private weak var episodesLabel: UILabel!
    @IBOutlet weak var episodeImage: UIImageView!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showTitleLabel.text = nil
        showDescriptionLabel.text = nil
    }
}

// MARK: - Configure function

extension DescriptionCell {
    func configure(with item: ShowInfo, episodes: Int) {
        showTitleLabel.text = item.title
        showDescriptionLabel.text = item.description
        let url = URL(string: "https://api.infinum.academy" + "\(item.imageUrl)")
        episodeImage.kf.setImage(with: url)
        episodesLabel.text = "Episodes: \(episodes)"
    }
}
