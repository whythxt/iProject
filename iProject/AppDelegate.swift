//
//  AppDelegate.swift
//  iProject
//
//  Created by Yurii on 25.08.2022.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    // Let the app know that creating a new scene can be done
    // by creating SceneDelegate instance.
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Create a scene configuration and tell iOS to use SceneDelegate class.
        let sceneConfiguration = UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self

        return sceneConfiguration
    }
}
