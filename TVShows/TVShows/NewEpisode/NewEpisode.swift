//
//  NewEpisode.swift
//  TVShows
//
//  Created by Krešimir Baković on 24/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import Foundation

struct NewEpisode: Codable {
    let showId: String
    let title: String
    let description: String
    let episodeNumber: String
    let season: String
}
