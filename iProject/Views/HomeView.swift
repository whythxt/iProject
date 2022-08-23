//
//  HomeView.swift
//  iProject
//
//  Created by Yurii on 12.08.2022.
//

import CoreData
import CoreSpotlight
import SwiftUI

struct HomeView: View {
    @StateObject var vm: ViewModel

    static let tag: String? = "Home"

    var projectRows: [GridItem] {
        [GridItem(.fixed(100))]
    }

    init(dataController: DataController) {
        let vm = ViewModel(dataController: dataController)
        _vm = StateObject(wrappedValue: vm)

    }

    var body: some View {
        NavigationView {
            ScrollView {
                if let item = vm.selectedItem {
                    NavigationLink(tag: item, selection: $vm.selectedItem) {
                        EditItemView(item: item)
                    } label: {
                        EmptyView()
                    }
                    .id(item)
                }
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
                            ForEach(vm.projects, content: ProjectSummary.init)
                        }
                        .padding([.horizontal, .top], 10)
                    }

                    VStack(alignment: .leading) {
                        ItemList(title: "Up next", items: $vm.upNext)
                        ItemList(title: "More to explore", items: $vm.moreToExplore)
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
            .onContinueUserActivity(CSSearchableItemActionType, perform: vm.loadSpotlightItem)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(dataController: .preview)
    }
}
