//
//  NoteCanvasView.swift
//  WidgetWrite
//
//  Created by Jonathan Wei on 2022-08-05.
//

import SwiftUI
import CoreData
import PencilKit
import WidgetKit
import UIKit

struct NoteCanvasView: UIViewControllerRepresentable {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: LatestDrawing.entity(), sortDescriptors: []) var latestDrawing: FetchedResults<LatestDrawing>
    
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
                latestDrawing.first?.title = result.first?.title
                latestDrawing.first?.canvasData = data
                
                let userDefaults = UserDefaults(suiteName: "group.com.widgetwrite")
                userDefaults?.setValue(result.first?.title, forKey: "text")
                userDefaults?.setValue(data, forKey: "drawing")
                
                let canvasImage: UIImage = viewController.saveCanvasImage() ?? UIImage()

                guard let imageData = canvasImage.jpegData(compressionQuality: 0.5) else { return }
                let encoded = try! PropertyListEncoder().encode(imageData)
                userDefaults?.set(encoded, forKey: "drawingImage")
                
                WidgetCenter.shared.reloadAllTimelines()
                
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
