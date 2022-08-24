//
//  SKProduct-LocalizedPrice.swift
//  iProject
//
//  Created by Yurii on 25.08.2022.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
