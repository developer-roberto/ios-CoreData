//
//  ConsolesManager.swift
//  MyGames
//
//  Created by Roberto Oliveira on 03/04/18.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import Foundation
import CoreData

class ConsolesManager {
    
    static let shared:ConsolesManager = ConsolesManager()
    
    
    // MARK: - Properties
    var consoles:[Console] = []
    
    
    
    
    // MARK: - Methods
    func loadConsoles(with context: NSManagedObjectContext) {
        let fetchRequest:NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            self.consoles = try context.fetch(fetchRequest)
        } catch {
            print("Something went wrong: ", error.localizedDescription)
        }
    }
    
    func deleteConsole(index:Int, context:NSManagedObjectContext) {
        let console = self.consoles[index]
        context.delete(console)
        do {
            try context.save()
            self.consoles.remove(at: index)
        } catch {
            print("Something went wrong: ", error.localizedDescription)
        }
    }
    
    
    
    private init() {
        // Private init makes sure that instances will be not created besides SHARED
    }
    
}







