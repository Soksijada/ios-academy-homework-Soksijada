//
//  Show.swift
//  TVShows
//
//  Created by Krešimir Baković on 20/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import Foundation

struct Show: Decodable {
    let _id: String
    let title: String
    let imageUrl: String
    let likesCount: Int
}

