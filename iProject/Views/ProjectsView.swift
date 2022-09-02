//
//  ProjectsView.swift
//  iProject
//
//  Created by Yurii on 12.08.2022.
//

import SwiftUI

struct ProjectsView: View {
    @StateObject var vm: ViewModel

    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    @State private var showingSort = false

    init(dataController: DataController, showClosedProjects: Bool) {
        let vm = ViewModel(dataController: dataController, showClosedProjects: showClosedProjects)
        _vm = StateObject(wrappedValue: vm)
    }

    var projectsList: some View {
        List {
            ForEach(vm.projects) { project in
                Section {
                    ForEach(project.projectItems(using: vm.sortOrder)) { item in
                        ItemRow(project: project, item: item)
                    }
                    .onDelete { offsets in
                        vm.delete(offsets, from: project)
                    }

                    if !vm.showClosedProjects {
                        Button {
                            withAnimation {
                                vm.addItem(to: project)
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
            if !vm.showClosedProjects {
                Button {
                    withAnimation {
                        vm.addProject()
                    }
                } label: {
                    Label("Add Project", systemImage: "plus")
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if vm.projects.isEmpty {
                    Text("There's nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    projectsList
                }
            }
            .navigationTitle(vm.showClosedProjects ? "Closed Projects" : "Open Projects")
            .toolbar {
                sortOrderToolbarItem
                addProjectToolbarItem
            }
            .confirmationDialog("Sort items", isPresented: $showingSort) {
                Button("Optimized") { vm.sortOrder = .optimized }
                Button("Creation Date") { vm.sortOrder = .creationDate }
                Button("Title") { vm.sortOrder = .title }
            }
            .sheet(isPresented: $vm.showingUnlockView) {
                UnlockView()
            }

            SelectSomethingView()
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(dataController: .preview, showClosedProjects: false)
    }
}
