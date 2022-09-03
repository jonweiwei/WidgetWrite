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

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), text: "", configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.com.widgetwrite")
        let text = userDefaults?.value(forKey: "text") as? String ?? "No Text"
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, text: text, configuration: configuration)
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
    let configuration: ConfigurationIntent
}

struct WidgetView: View {
    // @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
//        return Text("Drawings: \(drawingID)")
        return Text(entry.text)
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
    
    var drawingID: Int {
//        let moc = CoreDataStack.shared.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LatestDrawing")
//        request.predicate = NSPredicate(format: "title == %@", "test")
//        do {
//            let result = try moc.fetch(request)
//            return String(result.count)
//        } catch {
//            print(error)
//            return ""
//        }
        do {
            return try CoreDataStack.shared.managedObjectContext.count(for: request)
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
}

@main
struct Note_Widget: Widget {
    let kind: String = "Note_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
        .configurationDisplayName("My Note")
        .description("View your saved notes.")
    }
}

struct Note_Widget_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(entry: SimpleEntry(date: Date(), text: "", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
