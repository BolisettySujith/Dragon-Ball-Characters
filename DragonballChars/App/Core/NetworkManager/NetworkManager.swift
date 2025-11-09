//
//  NetworkManager.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 08/11/25.
//

import Foundation
import Alamofire


final class AlamofireNetworkManager : NetworkManagerProtocol {
    
    private let session : Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func request<T>(url: URL, queryItems: [URLQueryItem]?) async throws -> T where T : Decodable {
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        comps.queryItems = (comps.queryItems ?? []) + (queryItems ?? [])
        
        let urlRequest = try URLRequest(url: comps.url!, method: .get)
        
        return try await withCheckedThrowingContinuation{ cont in
            session.request(urlRequest)
                .validate()
                .responseData{ response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let decoded = try JSONDecoder().decode(T.self, from: data)
                            cont.resume(returning: decoded)
                        } catch {
                            cont.resume(throwing: NetworkError.decoding(error))
                        }
                    case .failure(let afError):
                        if let code = response.response?.statusCode {
                            cont.resume(throwing: NetworkError.server(statusCode: code))
                        } else {
                            cont.resume(throwing: NetworkError.transport(afError))
                        }
                    }
                    
                }
        }
    }
    
    
}
