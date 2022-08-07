//
//  NoteView.swift
//  WidgetWrite
//
//  Created by Jonathan Wei on 2022-08-06.
//

import SwiftUI

struct NoteView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @State var id:UUID?
    @State var data:Data?
    @State var title:String?
    
    var body: some View {
        VStack {
            NoteCanvasView(data: data ?? Data(), id: id ?? UUID())
                .environment(\.managedObjectContext, viewContext)
                .navigationBarTitle(title ?? "Untitled", displayMode: .inline)
        }
    }
}
