//
//  WidgetView.swift
//  Note WidgetExtension
//
//  Created by Jonathan Wei on 2022-08-09.
//

import WidgetKit
import SwiftUI

struct WidgetView: View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        VStack {
            switch widgetFamily {
                case .systemSmall:
                    SmallSizeView(entry: entry)
                case .systemMedium:
                    MediumSizeView(entry: entry)
                case .systemLarge:
                    LargeSizeView(entry: entry)
                case .systemExtraLarge:
                    ExtraLargeSizeView(entry: entry)
                default:
                    Text("")
            }
        }
    }
}
