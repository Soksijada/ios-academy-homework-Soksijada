//
//  DescriptionCell.swift
//  TVShows
//
//  Created by Krešimir Baković on 23/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit

final class DescriptionCell: UITableViewCell {
    
    // MARK: - Properties
    
    var episodesCount = 54
    
    // MARK: - Outlets

    @IBOutlet private weak var showTitleLabel: UILabel!
    @IBOutlet private weak var showDescriptionLabel: UILabel!
    @IBOutlet private weak var episodesLabel: UILabel!
    
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

extension DescriptionCell {
    func configure(with item: ShowInfo) {
        showTitleLabel.text = item.title
        showDescriptionLabel.text = item.description
        episodesLabel.text = "Episodes: \(episodesCount)"
    }
}
