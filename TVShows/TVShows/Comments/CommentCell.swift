//
//  CommentCell.swift
//  TVShows
//
//  Created by Krešimir Baković on 28/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit
import Kingfisher

final class CommentCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet private weak var commentImage: UIImageView!
    @IBOutlet private weak var commentSenderLabel: UILabel!
    @IBOutlet private weak var commentTextLabel: UILabel!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commentTextLabel.text = nil
        commentSenderLabel.text = nil
    }
}

// MARK: - Configure function

extension CommentCell {
    func configure(with item: Comment) {
        commentSenderLabel.text = item.userEmail
        commentTextLabel.text = item.text
    }
}
