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
    @StateObject var appInfo = AppInformation()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext).environmentObject(appInfo).environment(\.managedObjectContext, CoreDataStack.shared.managedObjectContext)
        }
    }
}
