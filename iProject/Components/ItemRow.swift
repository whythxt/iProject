//
//  ItemRow.swift
//  iProject
//
//  Created by Yurii on 13.08.2022.
//

import SwiftUI

struct ItemRow: View {
    @ObservedObject var item: Item
    
    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Text(item.itemTitle)
        }
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemRow(item: Item.example)
    }
}
