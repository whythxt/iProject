//
//  Item-CoreDataHelpers.swift
//  iProject
//
//  Created by Yurii on 13.08.2022.
//

import Foundation

extension Item {
    enum SortOrder {
        case optimized, creationDate, title
    }

    var itemTitle: String {
        title ?? NSLocalizedString("New Item", comment: "Create a new item")
    }

    var itemDetail: String {
        detail ?? ""
    }

    var itemCreation: Date {
        creation ?? Date()
    }

    static var example: Item {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let item = Item(context: viewContext)

        item.title = "Example Item"
        item.detail = "This is an example item"
        item.priority = 3
        item.creation = Date()

        return item
    }
}
