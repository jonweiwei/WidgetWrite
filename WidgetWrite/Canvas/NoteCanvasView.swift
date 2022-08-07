//
//  NoteCanvasView.swift
//  WidgetWrite
//
//  Created by Jonathan Wei on 2022-08-05.
//

import SwiftUI
import CoreData
import PencilKit

struct NoteCanvasView: UIViewControllerRepresentable {
    @Environment(\.managedObjectContext) private var viewContext
    
    func updateUIViewController(_ uiViewController: NoteCanvasViewController, context: Context) {
        uiViewController.noteData = data
    }
    typealias UIViewControllerType = NoteCanvasViewController
    
    var data: Data
    var id: UUID
    
    func makeUIViewController(context: Context) -> NoteCanvasViewController {
        let viewController = NoteCanvasViewController()
        viewController.noteData = data
        viewController.noteChanged = {data in
            let request: NSFetchRequest<Drawing> = Drawing.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.predicate = predicate
            do {
                let result = try viewContext.fetch(request)
                let obj = result.first
                obj?.setValue(data, forKey: "canvasData")
                do {
                    try viewContext.save()
                }
                catch {
                    print(error)
                }
            }
            catch {
                print(error)
            }
        }
        return viewController
    }
}
