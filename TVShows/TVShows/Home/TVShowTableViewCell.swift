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
        
        // One of THE MOST important function in UITableViewCell
        // This method will be called before your cell gets dequeued
        // So this will give you time to "reset" the data you have in this cell
        // Failure to do so can result in wrong data in the wrong cell
        // Imageine that one cell is missing its thumbnail image,
        // and you reuse cell and you don't clean the thumbnail, you will have that same thumbnail once cell is reused.
        
        thumbnail.image = nil
        title.text = nil
    }
    
}

// MARK: - Configure
extension TVShowTableViewCell {
    func configure(with item: TVShowItem) {
        // Here we are using conditional unwrap, meaning if we have the image, use that, if not, fallback to placeholder image.
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
