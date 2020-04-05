//
//  StorageManager.swift
//  DistContactTracing
//
//  Created by Axel Backlund on 2020-04-04.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "InteractionDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error leading store:", error.localizedDescription)
                return
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return StorageManager.shared.persistentContainer.viewContext
    }
    
    func insertInteraction(id: String, severity: Float) throws -> Interaction {
        let interaction = Interaction(context: context)
        interaction.id = id
        interaction.severity = severity
        interaction.date = Date()
        
        context.insert(interaction)
        try context.save()
        return interaction
    }
    
    func fetchInteractions() throws -> [Interaction] {
        let interactions = try context.fetch(Interaction.fetchRequest() as NSFetchRequest<Interaction>)
        return interactions
    }
    
    func update(_ interaction: Interaction, with severity: Float) throws {
        interaction.severity = severity
        try self.context.save()
    }
}
