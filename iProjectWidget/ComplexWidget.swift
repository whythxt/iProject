//
//  ComplexWidget.swift
//  iProjectWidgetExtension
//
//  Created by Yurii on 26.08.2022.
//

import SwiftUI
import WidgetKit

struct iProjectWidgetMultipleEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.sizeCategory) var sizeCategory

    var entry: Provider.Entry

    var items: ArraySlice<Item> {
        let itemCount: Int

        switch widgetFamily {
            case .systemSmall:
                itemCount = 1
            case .systemMedium:
                if sizeCategory < .extraLarge {
                    itemCount = 3
                } else {
                    itemCount = 2
                }
            default:
                if sizeCategory < .extraExtraLarge {
                    itemCount = 5
                } else {
                    itemCount = 4
                }
        }

        return entry.items.prefix(itemCount)
    }

    var body: some View {
        VStack(spacing: 5) {
            ForEach(items) { item in
                HStack {
                    Color(item.project?.color ?? "Light Blue")
                        .frame(width: 5)
                        .clipShape(Capsule())

                    VStack(alignment: .leading) {
                        Text(item.itemTitle)
                            .font(.headline)
                            .layoutPriority(1)

                        if let projectTitle = item.project?.title {
                            Text(projectTitle)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()
                }
            }
        }
        .padding(20)
    }
}

struct ComplexiProjectWidget: Widget {
    let kind: String = "ComplexiProjectWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            iProjectWidgetMultipleEntryView(entry: entry)
        }
        .configurationDisplayName("Up next")
        .description("Your most important items.")
    }
}

// Determines how our widget should be previewed in Xcode.
struct ComplexiProjectWidget_Previews: PreviewProvider {
    static var previews: some View {
        iProjectWidgetMultipleEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
