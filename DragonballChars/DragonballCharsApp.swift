//
//  DragonballCharsApp.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 08/11/25.
//

import SwiftUI

@main
struct DragonballCharsApp: App {

    let container = AppContainer.shared.container
    @StateObject private var listViewModel: CharactersListViewModel

    init() {
        let fetchCharacterUsecase = container.resolve(FetchCharactersUseCaseProtocol.self)!
        let refreshCharacterUsecase = container.resolve(RefreshCharactersUseCaseProtocol.self)!
        _listViewModel = StateObject(
            wrappedValue: CharactersListViewModel(
                fetchCharactersUseCase: fetchCharacterUsecase,
                refreshCharactersUseCase: refreshCharacterUsecase
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            CharactersListView()
                .environmentObject(listViewModel)
        }
    }
}
