//
//  TVShowTableViewCell.swift
//  TVShows
//
//  Created by Krešimir Baković on 21/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit
import Kingfisher

final class TVShowTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var thumbnail: UIImageView!
    @IBOutlet private weak var title: UILabel!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = nil
        title.text = nil
    }
}

// MARK: - Configure function

extension TVShowTableViewCell {
    func configure(with item: TVShowItem) {
        let url = URL(string: "https://api.infinum.academy" + "\(item.imageUrl)")
        thumbnail.kf.setImage(with: url)
        title.text = item.title
    }
}

// MARK: - Setting up UI

private extension TVShowTableViewCell {
    func setupUI() {
        thumbnail.layer.cornerRadius = 20
    }
}
