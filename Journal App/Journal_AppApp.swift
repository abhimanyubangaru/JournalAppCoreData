//
//  Journal_AppApp.swift
//  Journal App
//
//  Created by Abhi B on 6/14/22.
//

import SwiftUI

@main
struct Journal_AppApp: App {
    @StateObject var vm = EntriesViewModel()

    var body: some Scene {
        WindowGroup {
            EntriesView()
                .environmentObject(vm)
                .environment(\.managedObjectContext, vm.container.viewContext)
        }
    }
}
