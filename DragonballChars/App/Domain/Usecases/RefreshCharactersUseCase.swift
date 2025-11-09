//
//  RefreshCharactersUseCase.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import Foundation

protocol RefreshCharactersUseCaseProtocol {
    func callAsFunction(limit: Int) async throws -> [Character]
}

final class RefreshCharactersUseCase: RefreshCharactersUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func callAsFunction(limit: Int) async throws -> [Character] {
        print("Refreshing the characters with new :\(limit)")
        return try await repository.refreshCharacters(limit: limit)
    }
}
