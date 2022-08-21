//
//  ProjectTests.swift
//  iProjectTests
//
//  Created by Yurii on 19.08.2022.
//

import CoreData
import XCTest
@testable import iProject

class ProjectTests: BaseTestCase {
    func testCreatingProjectAndItems() {
        let targetCount = 10

        for _ in 0..<targetCount {
            let project = Project(context: managedObjectContext)

            for _ in 0..<targetCount {
                let item = Item(context: managedObjectContext)
                item.project = project
            }
        }

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), targetCount * targetCount)
    }

    func testDeletingProjectCascadeDeletesItems() throws {
        try dataController.createSampleData()

        let request = NSFetchRequest<Project>(entityName: "Project")
        let projects = try managedObjectContext.fetch(request)

        dataController.delete(projects[0])

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 4)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 40)
    }
}
