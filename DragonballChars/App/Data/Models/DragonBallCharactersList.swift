//
//  DragonBallCharactersList.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import Foundation

import Foundation

struct CharactersResponseDTO: Codable {
    let items: [CharacterDTO]
    let meta: PaginationDTO
    let links: LinksDTO
}

struct CharacterDTO: Codable {
    let id: Int
    let name: String
    let ki: String?
    let maxKi: String?
    let race: String?
    let gender: String?
    let description: String?
    let image: URL?
    let affiliation: String?
    let deletedAt: String?
}

struct PaginationDTO: Codable {
    let totalItems: Int
    let itemCount: Int
    let itemsPerPage: Int
    let totalPages: Int
    let currentPage: Int
}

struct LinksDTO: Codable {
    let first: String?
    let previous: String?
    let next: String?
    let last: String?
}
