//
//  ProjectsView.swift
//  iProject
//
//  Created by Yurii on 12.08.2022.
//

import SwiftUI

struct ProjectsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @EnvironmentObject var dataController: DataController

    @State private var showingSort = false
    @State private var sortOrder = Item.SortOrder.optimized

    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    let showClosedProjects: Bool

    let projects: FetchRequest<Project>

    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects

        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Project.creation, ascending: false)
        ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }

    var projectsList: some View {
        List {
            ForEach(projects.wrappedValue) { project in
                Section {
                    ForEach(project.projectItems(using: sortOrder)) { item in
                        ItemRow(project: project, item: item)
                    }
                    .onDelete { offsets in
                        delete(offsets, from: project)
                    }

                    if !showClosedProjects {
                        Button {
                            addItem(to: project)
                        } label: {
                            Label("Add New Item", systemImage: "plus")
                        }
                    }
                } header: {
                    ProjectHeader(project: project)
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSort.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }

    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if !showClosedProjects {
                Button(action: addProject) {
                    // VoiceOver has a glitch that reads the label
                    // "Add Project" as "Add" no matter what accessibility label
                    // we give this button when using a label. As a result, when
                    // VoiceOver is running we use a text view for the button instead,
                    // forcing a correct reading without losing the original layout.
                    if UIAccessibility.isVoiceOverRunning {
                        Text("Add Project")
                    } else {
                        Label("Add Project", systemImage: "plus")
                    }
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.isEmpty {
                    Text("There is nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                   projectsList
                }
            }
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                sortOrderToolbarItem
                addProjectToolbarItem
            }
            .confirmationDialog("Sort items", isPresented: $showingSort) {
                Button("Optimized") { sortOrder = .optimized }
                Button("Creation Date") { sortOrder = .creationDate }
                Button("Title") { sortOrder = .title }
            }

            SelectSomethingView()
        }
    }

    func addProject() {
        withAnimation {
            let project = Project(context: managedObjectContext)
            project.closed = false
            project.creation = Date()
            dataController.save()
        }
    }

    func addItem(to project: Project) {
        withAnimation {
            let item = Item(context: managedObjectContext)
            item.project = project
            item.creation = Date()
            dataController.save()
        }
    }

    func delete(_ offsets: IndexSet, from project: Project) {
        let allItems = project.projectItems(using: sortOrder)

        for offset in offsets {
            let item = allItems[offset]
            dataController.delete(item)
        }

        dataController.save()
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
