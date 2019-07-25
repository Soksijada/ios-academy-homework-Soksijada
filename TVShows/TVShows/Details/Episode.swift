//
//  Episode.swift
//  TVShows
//
//  Created by Krešimir Baković on 23/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import Foundation

struct Episode: Decodable {
    var _id: String
    var title: String
    var description: String
    var imageUrl: String
    var episodeNumber: String
    var season: String
}
