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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject var dataController: DataController
    @StateObject var unlockManager: UnlockManager

    init() {
        let dataController = DataController()
        let unlockManager = UnlockManager(dataController: dataController)

        _dataController = StateObject(wrappedValue: dataController)
        _unlockManager = StateObject(wrappedValue: unlockManager)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(unlockManager)
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
                .onAppear(perform: dataController.requestReview)
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
