//
//  WidgetView.swift
//  Note WidgetExtension
//
//  Created by Jonathan Wei on 2022-08-09.
//

import WidgetKit
import SwiftUI

struct WidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("The time is")
            Text(entry.date, style: .time)
        }
    }
}
