//
//  iProjectWidget.swift
//  iProjectWidget
//
//  Created by Yurii on 25.08.2022.
//

import WidgetKit
import SwiftUI

@main
// Lets us return several widgets.
struct PortfolioWidgets: WidgetBundle {
    var body: some Widget {
        SimpleiProjectWidget()
        ComplexiProjectWidget()
    }
}
