//
//  MostViewed.swift
//  NYT-Reader
//
//  Created by Jeremy Yarley on 6/16/20.
//  Copyright © 2020 Jeremy Yarley. All rights reserved.
//

import Foundation

struct Shared: Codable {
    var id: Int
    var asset_id: Int
    var title: String
    var published_date: String
    var source: String
    var abstract: String
    var media: [SharedMedia]
    
    enum CodingKeys: String, CodingKey {
        case id
        case asset_id
        case title = "title"
        case published_date = "published_date"
        case source = "source"
        case abstract = "abstract"
        case media = "media"
    }
}

