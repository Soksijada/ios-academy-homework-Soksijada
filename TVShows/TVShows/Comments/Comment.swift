//
//  Comment.swift
//  TVShows
//
//  Created by Krešimir Baković on 28/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import Foundation

struct Comment: Codable {
    var text: String
    var episodeId: String
    var userEmail: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case episodeId
        case userEmail
        case id = "_id"
    }
}
