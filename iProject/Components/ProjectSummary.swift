//
//  ProjectSummary.swift
//  iProject
//
//  Created by Yurii on 17.08.2022.
//

import SwiftUI

struct ProjectSummary: View {
    @ObservedObject var project: Project

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(project.projectItems.count) items")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(project.projectTitle)
                .font(.title2)

            ProgressView(value: project.completionAmount)
                .tint(Color(project.projectColor))
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.2), radius: 5)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(project.label)
    }
}

struct ProjectSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSummary(project: Project.example)
    }
}
