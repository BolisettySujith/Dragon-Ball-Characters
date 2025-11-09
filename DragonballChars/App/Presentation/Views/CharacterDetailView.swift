//
//  CharacterDetailView.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import SwiftUI
import Kingfisher

struct CharacterDetailView: View {
    @StateObject var viewModel: CharacterDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                KFImage(viewModel.character.imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 500)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 5)
                    .padding(.bottom, 8)

                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.character.name)
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 4)

                    if let affiliation = viewModel.character.affiliation {
                        Text("Affiliation: \(affiliation)")
                            .font(.headline)
                    }

                    Divider()

                    if let desc = viewModel.character.description {
                        Text(desc)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 4)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle(viewModel.character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
