//
//  File.swift
//  TVShows
//
//  Created by Krešimir Baković on 16/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}



