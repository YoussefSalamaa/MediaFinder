//
//  ITunes.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 8/13/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import Foundation

struct MediaResponse: Codable {
    var resultCount: Int
    var results: [Media]
}

struct Media: Codable {
    var artistName: String?
    var trackName: String?
    var longDescription: String?
    var artworkUrl: String!
    var previewUrl: String!
    
    enum CodingKeys: String, CodingKey {
        case artistName, trackName, longDescription, previewUrl
        case artworkUrl = "artworkUrl100"
    }
}

struct MediaData: Codable {
    var mediaType: String!
    var mediaData: [Media]
}
