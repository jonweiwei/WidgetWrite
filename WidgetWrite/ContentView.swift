//
//  ContentView.swift
//  WidgetWrite
//
//  Created by Jonathan Wei on 2022-07-18.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var appInfo: AppInformation
    
    @FetchRequest(entity: Drawing.entity(), sortDescriptors: []) var drawings: FetchedResults<Drawing>
    @FetchRequest(entity: LatestDrawing.entity(), sortDescriptors: []) var latestDrawing: FetchedResults<LatestDrawing>
    
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(drawings) { drawing in
                        NavigationLink(destination: NoteView(id: drawing.id, data: drawing.canvasData, title: drawing.title), label: {
                            Text(drawing.title ?? "Untitled")
                        })
                    }
                    .onDelete(perform: deleteItem)
                
                    Button(action: {
                        self.showSheet.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Note")
                        }
                    })
                    .foregroundColor(.blue)
                    .sheet(isPresented: $showSheet, content: {
                        AddNewNoteView().environment(\.managedObjectContext, viewContext)
                    })
                }
                //.navigationTitle(Text(String((drawings.first?.title)! )))
                //.navigationTitle(Text("Notes"))
                .navigationTitle(Text(String((latestDrawing.first?.title)! )))
                //.navigationTitle(Text("Drawings: \(appInfo.drawingCount)"))
            }
            VStack {
                Image(systemName: "scribble.variable").font(.largeTitle)
                Text("No note selected").font(.title)
            }
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
//        .onChange(of: appInfo.drawingCount) { _ in
//            let url = FileManager.appGroupContainerURL.appendingPathComponent(FileManager.drawingFileName)
//            try? String(appInfo.drawingCount).write(to: url, atomically: false, encoding: .utf8)
//        }
    }
    
    func deleteItem(at offset: IndexSet) {
        for index in offset {
            let itemToDelete = drawings[index]
            viewContext.delete(itemToDelete)
            do {
                try viewContext.save()
                appInfo.drawingCount -= 1
            }
            catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}

class AppInformation: ObservableObject {
    @Published var drawingCount = 0
}
