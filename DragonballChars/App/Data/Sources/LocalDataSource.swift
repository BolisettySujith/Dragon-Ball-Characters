//
//  LocalDataSource.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 09/11/25.
//

import Foundation
import CoreData

protocol LocalDataSourceProtocol {
    func save(characters dtos: [CharacterDTO], page: Int) async throws
    
    func fetchCharacters(page: Int, limit: Int) async throws -> [Character]
    
    func clearAll() async throws
    
    func hasPage(page: Int, limit: Int) async throws -> Bool
}

final class LocalDataSource: LocalDataSourceProtocol {
    private let core: CoreDataStack
    
    init(core: CoreDataStack = .shared) {
        self.core = core
    }
    
    func save(characters dtos: [CharacterDTO], page: Int) async throws {
        core.performBackgroundTask{ ctx in
            for dto in dtos {
                print("Saving : \(dto.name)")
                
                let fetch : NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
                
                fetch.predicate = NSPredicate(format: "id == %d", dto.id)
                
                if let existing = (try? ctx.fetch(fetch))?.first {
                    existing.name = dto.name
                    existing.desc = dto.description
                    existing.imageURL = dto.image?.absoluteString
                    existing.affiliation = dto.affiliation
                } else {
                    let entity = CharacterEntity(context: ctx)
                    entity.id = Int64(dto.id)
                    entity.name = dto.name
                    entity.desc = dto.description
                    entity.imageURL = dto.image?.absoluteString
                    entity.affiliation = dto.affiliation
                }
            }
            
            do {
                try ctx.save()
            } catch {
                print("Core Data Save error: \(error)")
            }
            
        }
    }
    
    func fetchCharacters(page: Int = 1, limit: Int = 20) async throws -> [Character] {
        try await withCheckedThrowingContinuation{ continuation in
            core.performBackgroundTask{ ctx in
                do {
                    
                    let req : NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
                    req.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
                    req.fetchLimit = limit
                    req.fetchOffset = (page - 1) * limit
                    req.fetchBatchSize = limit
                    
                    let entities = try ctx.fetch(req)
                    
                    let mappedData = entities.map{ entity in
                        Character(
                            id: Int(entity.id),
                            name: entity.name ?? "Unknown",
                            description: entity.desc ,
                            imageURL: URL(string: entity.imageURL ?? ""),
                            affiliation: entity.affiliation
                        )
                        
                    }
                    print("Mapping data length")
                    print(mappedData.count)
                    continuation.resume(returning: mappedData)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func clearAll() async throws {
        core.performBackgroundTask{ ctx in
            let del = NSBatchDeleteRequest(fetchRequest: CharacterEntity.fetchRequest())
            
            _ = try? ctx.execute(del)
            try? ctx.save()
        }
    }
    
    func hasPage(page: Int, limit: Int) async throws -> Bool {
        let ctx = core.viewContext
        let fetch: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        fetch.fetchLimit = 1
        fetch.fetchOffset = (page - 1) * limit
        let count = try ctx.count(for: fetch)
        return count > 0
    }
    
}
