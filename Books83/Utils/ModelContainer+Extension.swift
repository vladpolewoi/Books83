//
//  ModelContainer+Extension.swift
//  Books83
//
//  Created by Quest76 on 08.08.2025.
//

import Foundation
import SwiftData

extension ModelContainer {
    static var books: ModelContainer {
        let schema = Schema([Book.self, ReadingLog.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    static var preview: ModelContainer {
        let schema = Schema([Book.self, ReadingLog.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        let container: ModelContainer
        do {
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create preview ModelContainer: \(error)")
        }
        
        DispatchQueue.main.sync {
            for book in Book.mockBooks {
                container.mainContext.insert(book)
            }
            
            for log in ReadingLog.mockLogs {
                container.mainContext.insert(log)
            }
        }
        
        return container
    }
}
