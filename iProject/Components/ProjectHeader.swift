//
//  ProjectHeader.swift
//  iProject
//
//  Created by Yurii on 13.08.2022.
//

import SwiftUI

struct ProjectHeader: View {
    @ObservedObject var project: Project

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.projectTitle)

                ProgressView(value: project.completionAmount)
                    .tint(Color(project.projectColor))
            }

            Spacer()

            NavigationLink(destination: EditProjectView(project: project)) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
    }
}

struct ProjectHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeader(project: Project.example)
    }
}
