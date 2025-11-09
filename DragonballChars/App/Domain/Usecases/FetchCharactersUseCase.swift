//
//  FetchCharactersUseCase.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import Foundation

protocol FetchCharactersUseCaseProtocol {
    func callAsFunction(page: Int, limit: Int) async throws -> [Character]
}

final class FetchCharactersUseCase : FetchCharactersUseCaseProtocol {
    private let repository : CharactersRepositoryProtocol
    
    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }
    
    func callAsFunction(page: Int, limit: Int) async throws -> [Character] {
        print("From usecase Calling repository")
        return try await repository.getCharacters(page: page, limit: limit, shouldRefresh: false)
    }
}
