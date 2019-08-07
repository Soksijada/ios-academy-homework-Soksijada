//
//  Episode.swift
//  TVShows
//
//  Created by Krešimir Baković on 23/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import Foundation

struct Episode: Codable {
    var id: String
    var title: String
    var description: String
    var imageUrl: String
    var episodeNumber: String
    var season: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case imageUrl
        case episodeNumber
        case season
    }
}
