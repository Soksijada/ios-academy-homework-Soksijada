//
//  Photo.swift
//  TVShows
//
//  Created by Krešimir Baković on 29/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import Foundation

struct Media: Codable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
}
