//
//  WidgetView.swift
//  Note WidgetExtension
//
//  Created by Jonathan Wei on 2022-08-09.
//

import CoreData
import WidgetKit
import SwiftUI

struct WidgetView: View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        return Text("Drawings: \(itemsCount)")
//        VStack {
//            switch widgetFamily {
//                case .systemSmall:
//                    SmallSizeView(entry: entry)
//                case .systemMedium:
//                    MediumSizeView(entry: entry)
//                case .systemLarge:
//                    LargeSizeView(entry: entry)
//                case .systemExtraLarge:
//                    ExtraLargeSizeView(entry: entry)
//                default:
//                    Text("")
//            }
//        }
    }
    
    var itemsCount: Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Drawing")
        do {
            return try CoreDataStack.shared.managedObjectContext.count(for: request)
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
}
