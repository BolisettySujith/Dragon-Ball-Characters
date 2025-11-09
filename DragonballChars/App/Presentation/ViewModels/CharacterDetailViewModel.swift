//
//  CharacterDetailViewModel.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import Foundation

@MainActor
final class CharacterDetailViewModel : ObservableObject {
    @Published var character : Character
    
    init(character: Character) {
        self.character = character
    }
}
