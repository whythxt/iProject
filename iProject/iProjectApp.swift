//
//  iProjectApp.swift
//  iProject
//
//  Created by Yurii on 12.08.2022.
//

import SwiftUI

@main
// swiftlint:disable:next type_name
struct iProjectApp: App {
    @StateObject var dataController: DataController

    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
            // Automatically save when we detect that we are
            // no longer the foreground app. Use this rather than
            // scene phase so we can port to macOS, where scene
            // phase won't detect our app losing focus.
                .onReceive(
                    NotificationCenter
                        .default
                        .publisher(for: UIApplication.willResignActiveNotification ),
                        perform: save
                )
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
