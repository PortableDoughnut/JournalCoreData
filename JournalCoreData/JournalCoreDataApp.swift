//
//  JournalCoreDataApp.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/3/25.
//

import SwiftUI

@main
struct JournalCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            JournalsView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
