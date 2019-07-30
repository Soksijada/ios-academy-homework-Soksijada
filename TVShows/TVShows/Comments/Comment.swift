//
//  Comment.swift
//  TVShows
//
//  Created by Krešimir Baković on 28/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import Foundation

struct Comment: Decodable {
    var text: String
    var episodeId: String
    var userEmail: String
    var _id: String
}
