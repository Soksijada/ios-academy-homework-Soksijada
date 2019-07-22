//
//  TVShowTableViewCell.swift
//  TVShows
//
//  Created by Krešimir Baković on 21/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit

// Same as with our UIViewController subclass, if we want to customize our UITableViewCell we need custom subclass.
final class TVShowTableViewCell: UITableViewCell {
    
    // MARK: - Private UI
    @IBOutlet private weak var thumbnail: UIImageView!
    @IBOutlet private weak var title: UILabel!
    
    // MARK: - Lifecycle
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

    // MARK: - Configure

    extension TVShowTableViewCell {
        func configure(with item: TVShowItem) {
            thumbnail.image = item.image ?? UIImage(named: "icImagePlaceholder")
            title.text = item.title
        }
    }

    // MARK: - Private

    private extension TVShowTableViewCell {
        func setupUI() {
            thumbnail.layer.cornerRadius = 20
        }
    }
