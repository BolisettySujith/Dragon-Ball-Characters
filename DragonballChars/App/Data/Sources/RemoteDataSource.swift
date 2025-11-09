//
//  RemoteDataSource.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import Foundation

protocol RemoteDataSourceProtocol {
    func fetchCharacters(page: Int, limit: Int) async throws -> CharactersResponseDTO
}


final class RemoteDataSource : RemoteDataSourceProtocol {
    
    private let network: NetworkManagerProtocol
    private let baseUrl = URL(string: "https://dragonball-api.com/api/characters")!
    
    init(network: NetworkManagerProtocol) {
        self.network = network
    }
    
    func fetchCharacters(page: Int, limit: Int) async throws -> CharactersResponseDTO {
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        return try await network.request(url: baseUrl, queryItems: queryItems)
    }
    
    
}
