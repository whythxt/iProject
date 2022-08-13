//
//  Binding-onChange.swift
//  iProject
//
//  Created by Yurii on 13.08.2022.
//

import SwiftUI

extension Binding {
    func onChange(_ completion: @escaping () -> Void) -> Binding<Value> {
        Binding {
            self.wrappedValue
        } set: { newValue in
            self.wrappedValue = newValue
            completion()
        }
    }
}
