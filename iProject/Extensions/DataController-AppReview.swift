//
//  DataController-AppReview.swift
//  iProject
//
//  Created by Yurii on 25.08.2022.
//

import StoreKit

extension DataController {
    func requestReview() {
        guard count(for: Project.fetchRequest()) >= 5 else { return }

        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first { $0.activationState == .foregroundActive }

        if let windowScene = scene as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
