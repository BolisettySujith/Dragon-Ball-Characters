//
//  CharactersListViewModel.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import Foundation
import Combine

@MainActor
final class CharactersListViewModel : ObservableObject {
    //MARK: Published UI States
    @Published var characters : [Character] = []
    @Published var isLoading: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var errorMessage: String?
    @Published var hasMorePages: Bool = true
    
    // MARK: Private Properties
    private let fetchCharactersUseCase: FetchCharactersUseCaseProtocol
    private let refreshCharactersUseCase: RefreshCharactersUseCaseProtocol
    private var currentPage : Int = 1
    private let pageSize : Int = 20
    
    // MARK: Init
    init(
        fetchCharactersUseCase: FetchCharactersUseCaseProtocol,
        refreshCharactersUseCase: RefreshCharactersUseCaseProtocol
    ) {
        self.fetchCharactersUseCase = fetchCharactersUseCase
        self.refreshCharactersUseCase = refreshCharactersUseCase
        
    }
    // MARK: - Public Methods
    func loadInitialData() async {
        guard !isLoading else { return }
        
        print("🔄 Loading initial data…")
        
        isLoading = true
        errorMessage = nil
        currentPage = 1
        
        do {
            let results = try await fetchCharactersUseCase(page: currentPage, limit: pageSize)
            print("✅ Received \(results.count) characters")

            self.characters = results
            self.hasMorePages = !results.isEmpty
        } catch {
            print("❌ Failed to load characters: \(error)")

            self.errorMessage = "Failed to load characters: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func loadNextPageIfNeeded(currentItem item: Character?) async {
        guard let item = item, !isLoading, hasMorePages else { return }
        
        let thresholdIndex = characters.index(characters.endIndex, offsetBy: -5)
        if characters.firstIndex(where: {$0.id == item.id}) == thresholdIndex {
            await loadNextPage()
        }
    }
    
    func loadNextPage() async {
        guard !isLoading && hasMorePages else { return }
        isLoading = true
        
        do {
            let nextPage = currentPage + 1
            let results = try await fetchCharactersUseCase(page: nextPage, limit: pageSize)
            
            if results.isEmpty {
                hasMorePages = false
            } else {
                self.characters.append(contentsOf: results)
                currentPage = nextPage
            }
        } catch {
            self.errorMessage = "Failed to load more: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func refresh() async {
        guard !isRefreshing, !isLoading else { return }
        
        isRefreshing = true
        errorMessage = nil
        currentPage = 1
        
        do {
            print("🌀 Starting refresh")
            self.characters.removeAll()
            let results = try await refreshCharactersUseCase(limit: pageSize)
            self.characters = results
            self.hasMorePages = !results.isEmpty
            print("✅ Refresh done: \(results.count) items")
        } catch {
            print("error during refresh : \(error.localizedDescription)")
            self.errorMessage = "Failed to refresh: \(error.localizedDescription)"
        }
        
        isRefreshing = false
    }
    
}
