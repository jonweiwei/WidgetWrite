//
//  WidgetWriteApp.swift
//  WidgetWrite
//
//  Created by Jonathan Wei on 2022-08-06.
//

import SwiftUI

@main
struct WidgetWriteApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
