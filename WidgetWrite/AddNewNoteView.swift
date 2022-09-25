//
//  AddNewNoteView.swift
//  WidgetWrite
//
//  Created by Jonathan Wei on 2022-08-04.
//

import SwiftUI
import WidgetKit
import CoreData

struct AddNewNoteView: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var appInfo: AppInformation
    @Environment (\.presentationMode) var presentationMode
    
    @FetchRequest(entity: LatestDrawing.entity(), sortDescriptors: []) var latestDrawing: FetchedResults<LatestDrawing>
    
    @State private var noteTitle = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Note Title", text: $noteTitle)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle(Text("New Note"))
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
            }), trailing: Button(action: {
                if !noteTitle.isEmpty {
                    let drawing = Drawing(context: viewContext)
                    drawing.title = noteTitle
                    drawing.id = UUID()
                    drawing.timestamp = Date.now
                    
                    let userDefaults = UserDefaults(suiteName: "group.com.widgetwrite")
                    userDefaults?.setValue(drawing.title, forKey: "text")
                    WidgetCenter.shared.reloadAllTimelines()
                    
                    do {
                        try viewContext.save()
                        appInfo.drawingCount += 1
                    }
                    catch {
                        print(error)
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()
                }
            }, label: {
                Text("Save")
            }))
        }
//        .preferredColorScheme(.light)
    }
}

struct AddNewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewNoteView()
    }
}
