//
//  SimpleWidget.swift
//  iProjectWidgetExtension
//
//  Created by Yurii on 26.08.2022.
//

import SwiftUI
import WidgetKit

// Determines how data for our widget is presented.
struct iProjectWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Up next")
                .font(.title)

            if let item = entry.items.first {
                Text(item.itemTitle)
            } else {
                Text("Nothing for now")
            }
        }
    }
}

// Determines how our widget should be configured.
struct SimpleiProjectWidget: Widget {
    let kind: String = "SimpleiProjectWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            iProjectWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Up next")
        .description("Your top-priority item.")
        .supportedFamilies([.systemSmall])
    }
}

// Determines how our widget should be previewed in Xcode.
struct SimpleiProjectWidget_Previews: PreviewProvider {
    static var previews: some View {
        iProjectWidgetEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
