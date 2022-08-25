//
//  ProjectsViewModel.swift
//  iProject
//
//  Created by Yurii on 22.08.2022.
//

import CoreData
import Foundation

extension ProjectsView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        @Published var projects = [Project]()

        @Published var showingUnlockView = false

        let dataController: DataController
        let showClosedProjects: Bool

        private let projectsController: NSFetchedResultsController<Project>

        var sortOrder = Item.SortOrder.optimized

        init(dataController: DataController, showClosedProjects: Bool) {
            self.dataController = dataController
            self.showClosedProjects = showClosedProjects

            // Construct a fetch request to show all projects.
            let request: NSFetchRequest<Project> = Project.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.creation, ascending: false)]
            request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)

            projectsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            projectsController.delegate = self

            do {
                try projectsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch projects.")
            }
        }

        func addProject() {
            if dataController.addProject() == false {
                showingUnlockView.toggle()
            }
        }

        func addItem(to project: Project) {
            let item = Item(context: dataController.container.viewContext)
            item.project = project
            item.priority = 2
            item.completed = false
            item.creation = Date()
            dataController.save()
        }

        func delete(_ offsets: IndexSet, from project: Project) {
            let allItems = project.projectItems(using: sortOrder)

            for offset in offsets {
                let item = allItems[offset]
                dataController.delete(item)
            }

            dataController.save()
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
        }
    }
}
