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
    @State private var order: SortOrder = .forward
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(drawings) { drawing in
                        NavigationLink(destination: NoteView(id: drawing.id, data: drawing.canvasData, title: drawing.title), label: {
                            VStack(alignment: .leading) {
                                Text(drawing.title ?? "Untitled").font(.system(size: 19, weight: .medium, design: .default))
                                let timestamp = drawing.timestamp
                                if timestamp != nil {
                                    Text(drawing.timestamp?.formatted() ?? "").font(.system(size: 15, weight: .light, design: .default))
                                }
                            }
                        })
                    }
                    .onDelete(perform: deleteItem)
                
                    Button(action: {
                        self.showSheet.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("New Note")
                        }
                    })
                    .foregroundColor(.blue)
                    .sheet(isPresented: $showSheet, content: {
                        AddNewNoteView().environment(\.managedObjectContext, viewContext).environmentObject(appInfo)
                    })
                }
                .navigationTitle(Text("Notes"))
                .toolbar {
                    Button(action: toggleSortOrder) {
                        Label("Sort Oder", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            VStack {
                Image(systemName: "scribble.variable").font(.largeTitle)
                Text("No note selected").font(.title)
            }
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
//        .preferredColorScheme(.light)
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
    
    func toggleSortOrder() {
        order = order == .reverse ? .forward : .reverse
        drawings.sortDescriptors = [SortDescriptor(\.timestamp, order: order)]
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
