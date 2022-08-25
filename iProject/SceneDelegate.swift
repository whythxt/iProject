//
//  SceneDelegate.swift
//  iProject
//
//  Created by Yurii on 25.08.2022.
//

import SwiftUI

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    @Environment(\.openURL) var openURL

    /// Handle cold start, called when the scene is being created.
    ///
    /// It’s a will connect method, meaning that it happens before the actual UI connection has taken place,
    /// meaning that SwiftUI might have finished its work by the time this is called, or it might not.
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let shortcutItem = connectionOptions.shortcutItem {
            guard let url = URL(string: shortcutItem.type) else { return }
            openURL(url)
        }
    }

    // Handle the app shortcut that has been triggered.
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        guard let url = URL(string: shortcutItem.type) else {
            completionHandler(false)
            return
        }

        openURL(url, completion: completionHandler)
    }
}
