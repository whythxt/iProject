//
//  AssetTests.swift
//  iProjectTests
//
//  Created by Yurii on 19.08.2022.
//

import XCTest
@testable import iProject

class AssetTests: XCTestCase {
    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from assets catalog.")
        }
    }

    func testJSONLoadsCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from JSON.")
    }
}
