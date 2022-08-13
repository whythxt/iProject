//
//  Item-CoreDataHelpers.swift
//  iProject
//
//  Created by Yurii on 13.08.2022.
//

import Foundation

extension Item {
    var itemTitle: String {
        title ?? "New Item"
    }

    var itemDetail: String {
        detail ?? ""
    }

    var itemCreation: Date {
        creation ?? Date()
    }
    
    static var example: Item {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let item = Item(context: viewContext)
        
        item.title = "Example Item"
        item.detail = "This is an example item"
        item.priority = 3
        item.creation = Date()
        
        return item
    }
}
