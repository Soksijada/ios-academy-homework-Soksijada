//
//  ShowInfo.swift
//  TVShows
//
//  Created by Krešimir Baković on 23/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import Foundation

struct ShowInfo: Decodable {
    let type: String
    let title: String
    let description: String
    let _id: String
    let likesCount: Int
    let imageUrl: String
}
