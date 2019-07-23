//
//  Episode.swift
//  TVShows
//
//  Created by Krešimir Baković on 23/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import Foundation

struct Episode: Decodable {
    let _id: String
    let title: String
    let description: String
    let imageUrl: String
    let episodeNumber: String
    let season: String
}