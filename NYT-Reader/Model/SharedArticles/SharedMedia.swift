//
//  SharedMedia.swift
//  NYT-Reader
//
//  Created by Jeremy Yarley on 6/17/20.
//  Copyright © 2020 Jeremy Yarley. All rights reserved.
//

import Foundation

struct SharedMedia: Codable {
    var mediaMetaData: [SharedMediaMetaData]
    
    enum CodingKeys: String, CodingKey {
        case mediaMetaData = "media-metadata"
    }
}
