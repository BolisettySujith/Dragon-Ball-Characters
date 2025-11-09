//
//  DragonBallCharacter.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import Foundation

struct Character : Hashable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let imageURL: URL?
    let affiliation: String?
    
    var uniqueID: String { "\(id)-\(name)" }

}
