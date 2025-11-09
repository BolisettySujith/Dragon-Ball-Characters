//
//  CharacterRowView.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import SwiftUI
import Kingfisher

struct CharacterRowView: View {
    
    let character: Character
    
    
    var body: some View {
        HStack(spacing : 12) {
            KFImage(character.imageURL)
                .resizable()
                .placeholder {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(character.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(character.affiliation ?? "Unknown affiliation")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
        }
        .padding(.vertical, 4)
    }
}

//#Preview {
//    CharacterRowView()
//}
