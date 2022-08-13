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
    
    var body: some View {
        NavigationView {
            List {
                ForEach(projects.wrappedValue) { project in
                    Section {
                        ForEach(project.projectItems) { item in
                            ItemRow(item: item)
                        }
                        .onDelete { offsets in
                            let allItems = project.projectItems
                            
                            for offset in offsets {
                                let item = allItems[offset]
                                dataController.delete(item)
                            }
                            
                            dataController.save()
                        }
                        
                        if !showClosedProjects {
                            Button {
                                withAnimation {
                                    let item = Item(context: managedObjectContext)
                                    item.project = project
                                    item.creation = Date()
                                    dataController.save()
                                }
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
            .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                if !showClosedProjects {
                    Button {
                        withAnimation {
                            let project = Project(context: managedObjectContext)
                            project.closed = false
                            project.creation = Date()
                            dataController.save()
                        }
                    } label: {
                        Label("Add Project", systemImage: "plus")
                    }
                }
            }
        }
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
