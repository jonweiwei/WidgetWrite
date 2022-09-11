//
//  NoteCanvasViewController.swift
//  WidgetWrite
//
//  Created by Jonathan Wei on 2022-08-05.
//

import SwiftUI
import PencilKit

class NoteCanvasViewController: UIViewController {
    lazy var canvas: PKCanvasView = {
        let view = PKCanvasView()
        view.drawingPolicy = .anyInput
        view.minimumZoomScale = 1
        view.maximumZoomScale = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var toolPicker: PKToolPicker = {
        let toolPicker = PKToolPicker()
        toolPicker.addObserver(self)
        return toolPicker
    }()
    
    var noteData = Data()
    var noteChanged: (Data) -> Void = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(canvas)
        NSLayoutConstraint.activate([
            canvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            canvas.topAnchor.constraint(equalTo: view.topAnchor),
            canvas.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.delegate = self
        canvas.becomeFirstResponder()
        if let note = try? PKDrawing(data: noteData) {
            canvas.drawing = note
        }
    }
    
    func saveCanvasImage() -> UIImage? {
        let drawing = canvas.drawing.image(from: canvas.bounds, scale: 0)
        let image = autoreleasepool { () -> UIImage in
            UIGraphicsBeginImageContextWithOptions(canvas.frame.size, false, 0.0)
            drawing.draw(in: CGRect(origin: CGPoint.zero, size: canvas.frame.size))
            let createdImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return createdImage!
        }
        return image
    }
}

extension NoteCanvasViewController:PKToolPickerObserver, PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        noteChanged(canvasView.drawing.dataRepresentation())
    }
}
