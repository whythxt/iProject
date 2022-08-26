//
//  HomeViewModel.swift
//  iProject
//
//  Created by Yurii on 22.08.2022.
//

import CoreData
import CoreSpotlight
import Foundation

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        @Published var projects = [Project]()
        @Published var items = [Item]()
        @Published var selectedItem: Item?

        @Published var upNext = ArraySlice<Item>()
        @Published var moreToExplore = ArraySlice<Item>()

        private let projectsController: NSFetchedResultsController<Project>
        private let itemsController: NSFetchedResultsController<Item>

        var dataController: DataController

        init(dataController: DataController) {
            self.dataController = dataController

            // Construct a fetch request to show all open projects.
            let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
            projectRequest.predicate = NSPredicate(format: "closed = false")
            projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]

            projectsController = NSFetchedResultsController(
                fetchRequest: projectRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            let itemRequest = dataController.fetchRequestForTopItems(count: 10)

            itemsController = NSFetchedResultsController(
                fetchRequest: itemRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()

            projectsController.delegate = self
            itemsController.delegate = self

            do {
                try projectsController.performFetch()
                try itemsController.performFetch()

                projects = projectsController.fetchedObjects ?? []
                items = itemsController.fetchedObjects ?? []

                upNext = items.prefix(3)
                moreToExplore = items.dropFirst(3)
            } catch {
                print("Failed to fetch initial data.")
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            items = itemsController.fetchedObjects ?? []

            upNext = items.prefix(3)
            moreToExplore = items.dropFirst(3)

            projects = projectsController.fetchedObjects ?? []
        }

        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }

        func selectItem(with id: String) {
            selectedItem = dataController.item(with: id)
        }

        func loadSpotlightItem(_ userActivity: NSUserActivity) {
            if let uniqueID = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                selectItem(with: uniqueID)
            }
        }
    }
}
