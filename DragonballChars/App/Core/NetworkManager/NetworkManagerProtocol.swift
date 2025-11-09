//
//  NetworkManagerProtocol.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import Foundation

enum NetworkError : Error {
    case transport(Error)
    case server(statusCode : Int)
    case decoding(Error)
    case unknown
}

protocol NetworkManagerProtocol {
    func request<T: Decodable>(url: URL, queryItems: [URLQueryItem]?) async throws -> T
}
