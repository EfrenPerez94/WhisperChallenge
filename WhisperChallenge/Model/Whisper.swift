//
//  PopularWhisper.swift
//  WhisperChallenge
//
//  Created by Efrén Pérez Bernabe on 6/10/19.
//  Copyright © 2019 Efrén Pérez Bernabe. All rights reserved.
//

import Foundation

/// Model to store popular whispers
struct PopularWhispers: Codable {
    let popular: [Whisper]
}

struct WhisperReplies: Codable {
    var replies: [Whisper]
}

/// Model for whispers
struct Whisper: Codable {
    let urlImage: String
    let wid: String
    let replies: Int
    let me2: Int
    
    enum CodingKeys: String, CodingKey {
        case urlImage = "url"
        case wid
        case replies
        case me2
    }
}
