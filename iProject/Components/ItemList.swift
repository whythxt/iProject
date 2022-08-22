//
//  ItemList.swift
//  iProject
//
//  Created by Yurii on 17.08.2022.
//

import SwiftUI

struct ItemList: View {
    let title: LocalizedStringKey
    let items: ArraySlice<Item>

    var body: some View {
        if items.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)

            ForEach(items) { item in
                NavigationLink {
                    EditItemView(item: item)
                } label: {
                    HStack(spacing: 20) {
                        Circle()
                            .stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
                            .frame(width: 33, height: 33)

                        VStack(alignment: .leading) {
                            Text(item.itemTitle)
                                .font(.title3)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if !item.itemDetail.isEmpty {
                                Text(item.itemDetail)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 5)
                }
            }
        }
    }
}

// struct ItemList_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemList()
//    }
// }
