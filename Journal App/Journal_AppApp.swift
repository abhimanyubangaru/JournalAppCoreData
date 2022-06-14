//
//  Journal_AppApp.swift
//  Journal App
//
//  Created by Abhi B on 6/14/22.
//

import SwiftUI

@main
struct Journal_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
