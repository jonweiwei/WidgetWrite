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
import UIKit
import PencilKit

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "Your Note", data: Data(), uiimage: UIImage(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), text: "Your Note", data: Data(), uiimage: UIImage(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.com.widgetwrite")
        let text = userDefaults?.value(forKey: "text") as? String ?? "No Text"
        let drawing = userDefaults?.value(forKey: "drawing") as? Data ?? Data()
        
        guard let imageData = userDefaults?.data(forKey: "drawingImage") else { return }
        let decoded = try! PropertyListDecoder().decode(Data.self, from: imageData)
        guard let image = UIImage(data: decoded) else { return }
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, text: text, data: drawing, uiimage: image, configuration: configuration)
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
    let data: Data
    let uiimage: UIImage
    let configuration: ConfigurationIntent
}

struct WidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        Image(uiImage: entry.uiimage)
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
