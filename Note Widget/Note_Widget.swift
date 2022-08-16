//
//  Note_Widget.swift
//  Note Widget
//
//  Created by Jonathan Wei on 2022-08-07.
//

import CoreData
import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let midnight = Calendar.current.startOfDay(for: Date())
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        let entries = [SimpleEntry(date: midnight)]
        let timeline = Timeline<Entry>(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

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
    
    var itemsCount: String {
        let moc = CoreDataStack.shared.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LatestDrawing")
        request.predicate = NSPredicate(format: "title == %@", "test")
        do {
            let result = try moc.fetch(request)
            return String(result.count)
        } catch {
            print(error)
            return ""
        }
//        do {
//            return try CoreDataStack.shared.managedObjectContext.count(for: request)
//        } catch {
//            print(error.localizedDescription)
//            return 0
//        }
    }
}

@main
struct Note_Widget: Widget {
    let kind: String = "Note_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
        .configurationDisplayName("My Note")
        .description("View your saved notes.")
    }
}

struct Note_Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
