//
//  CharactersRepository.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import Foundation


protocol CharactersRepositoryProtocol {
    func getCharacters(page: Int, limit: Int, shouldRefresh : Bool) async throws -> [Character]
    func refreshCharacters(limit: Int) async throws -> [Character]
}
