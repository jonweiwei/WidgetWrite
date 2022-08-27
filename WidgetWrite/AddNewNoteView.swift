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
    @Environment(\.managedObjectContext) var managedObject
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
            .navigationTitle(Text("Add New Note"))
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
            }), trailing: Button(action: {
                if !noteTitle.isEmpty {
                    let drawing = Drawing(context: viewContext)
                    drawing.title = noteTitle
                    drawing.id = UUID()
                    
                    let drawingContext = CoreDataStack.shared.workingContext
                    let latestNote = LatestDrawing(context: drawingContext)
                    latestNote.title = noteTitle
//                    if(latestDrawing.count == 0) {
//                        let latestNote = LatestDrawing(context: context)
//                        latestNote.title = noteTitle
//                    } else {
//                        latestDrawing.first?.title = noteTitle
//                    }
                    CoreDataStack.shared.saveWorkingContext(context: drawingContext)
                    WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.coreData)
                    
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
    }
}

struct AddNewNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewNoteView()
    }
}
