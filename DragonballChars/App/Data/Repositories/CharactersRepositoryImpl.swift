//
//  CharactersRepositoryImpl.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import Foundation

final class CharactersRepositoryImpl : CharactersRepositoryProtocol {
    
    private let remote : RemoteDataSourceProtocol
    private let local: LocalDataSourceProtocol
    
    init(remote: RemoteDataSourceProtocol, local: LocalDataSourceProtocol) {
        self.remote = remote
        self.local = local
    }
    
    func getCharacters(page: Int, limit: Int, shouldRefresh : Bool = false) async throws -> [Character] {
        print("Getting character for page :\(page) of limit :\(limit)")
        // Step 1: check if page exists locally
        print("Step 1")
        if try await local.hasPage(page: page, limit: limit) && !shouldRefresh {
            print("Getting the characters from the local")
            return try await local.fetchCharacters(page: page, limit: limit)
        }

        print("Performing Step 2")
        print("Getting the characters from the remote")
        // Step 2: otherwise fetch from remote
        do {
            let dtoResponse = try await remote.fetchCharacters(page: page, limit: limit)
            print("Items count")
            print(dtoResponse.items.count)
            print("Saving the characters")
            try await local.save(characters: dtoResponse.items, page: page)
            
            return dtoResponse.items.map{ dto in
                Character(
                    id: dto.id,
                    name: dto.name,
                    description: dto.description,
                    imageURL: dto.image,
                    affiliation: dto.affiliation
                )
            }
        } catch {
            print("Failed due to :\(error)")
            // fallback to local (in case of network failure)
            return try await local.fetchCharacters(page: page, limit: limit)
        }
    }
    
    func refreshCharacters(limit: Int) async throws -> [Character] {
        // Clear local and refetch first page
        try await local.clearAll()
        return try await getCharacters(page: 1, limit: limit, shouldRefresh: true)
    }
    
    
}
