//
//  JournalCoreDataApp.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/3/25.
//

import SwiftUI
import SwiftData

@main
struct JournalCoreDataApp: App {
	let modelContainer: ModelContainer
	let modelContext: ModelContext
	
	init() {
		do {
			modelContainer = try .init(for: Journal.self, Entry.self)
		} catch {
			fatalError("Failed to initialize SwiftData container: \(error)")
		}
		modelContext = .init(modelContainer)
	}

    var body: some Scene {
        WindowGroup {
			JournalsView()
				.modelContainer(modelContainer)
        }
    }
}
