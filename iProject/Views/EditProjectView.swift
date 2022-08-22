//
//  EditProjectView.swift
//  iProject
//
//  Created by Yurii on 13.08.2022.
//

import CoreHaptics
import SwiftUI

struct EditProjectView: View {
    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var dataController: DataController

    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var showingAlert = false

    @State private var engine = try? CHHapticEngine()

    let project: Project

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
    }

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            } header: {
                Text("Basic settings")
            }

            Section {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            } header: {
                Text("Custom color")
            }

            Section {
                Button(project.closed ? "Reopen this project" : "Close this project",
                       action: toggleClosed)

                Button("Delete this project", role: .destructive) {
                    showingAlert.toggle()
                }
            } footer: {
                Text("Closing a project moves it from the Open to Closed tab; Deleting it removes the project entirely.") // swiftlint:disable:this line_length
            }
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert("Delete project", isPresented: $showingAlert) {
            Button("Delete", role: .destructive) { delete() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this project? You will also delete all items it contains.")
        }
    }

    func update() {
        project.title = title
        project.detail = detail
        project.color = color
    }

    func delete() {
        dataController.delete(project)
        dismiss()
    }

    func toggleClosed() {
        project.closed.toggle()

        if project.closed {
//            UINotificationFeedbackGenerator().notificationOccurred(.success)

            do {
                try engine?.start()

                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

                let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
                let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)

                // Control haptic strength
                let parameter = CHHapticParameterCurve(
                    parameterID: .hapticIntensityControl,
                    controlPoints: [start, end],
                    relativeTime: 0
                )

                let event1 = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: 0
                )

                // Create haptic event starting immediately and lasting one second
                let event2 = CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [sharpness, intensity],
                    relativeTime: 0.125,
                    duration: 1
                )

                let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])

                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {

            }
        }
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(10)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(item == color ? [.isButton, .isSelected] : .isButton)
        .accessibilityLabel(LocalizedStringKey(item))
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        EditProjectView(project: Project.example)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
