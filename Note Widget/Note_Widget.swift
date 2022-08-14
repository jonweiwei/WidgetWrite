//
//  Note_Widget.swift
//  Note Widget
//
//  Created by Jonathan Wei on 2022-08-07.
//

import WidgetKit
import SwiftUI
import Intents

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
        WidgetView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
