//
//  AppleItem.swift
//  AppleSearch
//
//  Created by Madison Kaori Shino on 6/27/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import Foundation

//FIRST LEVEL
struct ResultsJson: Decodable {
    
    let results: [AppleItem]
}

//SECOND LEVEL
struct AppleItem: Decodable {
    
    let songName: String
    let artistName: String
    let albumName: String
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        
        case songName = "trackName"
        case artistName
        case albumName = "collectionName"
        case imageURL = "artworkUrl30"
    }
}

