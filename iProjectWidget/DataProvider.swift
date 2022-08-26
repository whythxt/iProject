//
//  DataProvider.swift
//  iProjectWidgetExtension
//
//  Created by Yurii on 26.08.2022.
//

import SwiftUI
import WidgetKit

// Determines how data for our widget is fetched.
struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry

    // Give the user idea of what your widget might look like.
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), items: [Item.example])
    }

    // Get current state of our widget.
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), items: loadItems())
        completion(entry)
    }

    // Called when iOS wants to know all future statuses of the widget.
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date(), items: loadItems())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    func loadItems() -> [Item] {
        let dataController = DataController()
        let itemRequest = dataController.fetchRequestForTopItems(count: 5)
        return dataController.results(for: itemRequest)
    }
}

// Determines how data for our widget is stored.
struct SimpleEntry: TimelineEntry {
    let date: Date
    let items: [Item]
}
