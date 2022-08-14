//
//  Provider.swift
//  Note WidgetExtension
//
//  Created by Jonathan Wei on 2022-08-09.
//

import WidgetKit

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let midnight = Calendar.current.startOfDay(for: Date())
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        let entries = [SimpleEntry(date: midnight, configuration: ConfigurationIntent())]
        let timeline = Timeline<Entry>(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}
