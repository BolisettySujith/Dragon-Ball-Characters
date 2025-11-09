//
//  AppContainer.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import Swinject

final class AppContainer {
    static let shared = AppContainer()
    let container : Container
    
    private init() {
        self.container = Container()
        register()
    }
    
    private func register() {
        // Core
        container.register(CoreDataStack.self) { _ in CoreDataStack.shared}.inObjectScope(.container)
        
        // Network
        container.register(NetworkManagerProtocol.self){_ in
            AlamofireNetworkManager()
        }.inObjectScope(.container)
        
        // Data Sources
        container.register(RemoteDataSourceProtocol.self) {r in
            RemoteDataSource(network: r.resolve(NetworkManagerProtocol.self)!)
        }
        container.register(LocalDataSourceProtocol.self) {r in
            LocalDataSource(core: r.resolve(CoreDataStack.self)!)
        }
        
        // Repository
        container.register(CharactersRepositoryProtocol.self) { r in
            CharactersRepositoryImpl(
                remote: r.resolve(RemoteDataSourceProtocol.self)!,
                local: r.resolve(LocalDataSourceProtocol.self)!
            )
        }
        
        // UseCases
        container.register(FetchCharactersUseCaseProtocol.self) { r in
            FetchCharactersUseCase(
                repository: r.resolve(CharactersRepositoryProtocol.self)!
            )
        }
        container.register(RefreshCharactersUseCaseProtocol.self) { r in
            RefreshCharactersUseCase(
                repository: r.resolve(CharactersRepositoryProtocol.self)!
            )
        }

    }
}
