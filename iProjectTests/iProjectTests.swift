//
//  iProjectTests.swift
//  iProjectTests
//
//  Created by Yurii on 19.08.2022.
//

import CoreData
import XCTest
@testable import iProject

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
