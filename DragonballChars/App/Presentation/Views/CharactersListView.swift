//
//  CharactersListView.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import SwiftUI

struct CharactersListView: View {
    @EnvironmentObject var viewModel: CharactersListViewModel

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Dragon Ball Characters")
                .task {
                    if viewModel.characters.isEmpty {
                        await viewModel.loadInitialData()
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.characters.isEmpty {
            loadingView
        } else if let error = viewModel.errorMessage {
            errorView(error)
        } else {
            charactersList
        }
    }

    private var loadingView: some View {
        ProgressView("Loading characters…")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(_ error: String) -> some View {
        VStack {
            Text("⚠️ \(error)")
                .font(.headline)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()

            Button("Retry") {
                Task { await viewModel.loadInitialData() }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var charactersList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.characters, id: \.uniqueID) { character in
                    NavigationLink(value: character) {
                        CharacterRowView(character: character)
                    }
                    .onAppear {
                        Task {
                            await viewModel.loadNextPageIfNeeded(
                                currentItem: character
                            )
                        }
                    }
                }

                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .padding(.horizontal)
        }
        .refreshable {
            guard !viewModel.isRefreshing else { return }
            await viewModel.refresh()
        }
        .navigationDestination(for: Character.self) { character in
            CharacterDetailView(
                viewModel: CharacterDetailViewModel(character: character)
            )
        }
    }
}
