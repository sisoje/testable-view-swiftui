//
//  testable_view_swiftuiTests.swift
//  testable-view-swiftuiTests
//
//  Created by Lazar Otasevic on 22.12.23..
//

import SwiftUI
@testable import testable_view_swiftui
import XCTest

final class testable_view_swiftuiTests: XCTestCase {
    override func setUp() {
        NotificationCenter.viewInspectorCenter = NotificationCenter()
    }

    override func tearDown() {
        NotificationCenter.viewInspectorCenter = nil
    }

    func testContenModel() throws {
        var numberOfChanges = 0
        let exp = expectation(description: #function)
        ContentModel()
            .viewInspectorOnPreferenceChange { view in
                numberOfChanges += 1
                print("Number of changes \(numberOfChanges)")
                switch numberOfChanges {
                case 1:
                    XCTAssertEqual(view.counter, 0)
                    view.increase()
                case 2:
                    XCTAssertEqual(view.counter, 1)
                    view.showSheet()
                default: XCTFail()
                }
            }
            .viewInspectorReceiveOnAppear { (_: Text) in
                exp.fulfill()
            }
            .installView()
        wait(for: [exp], timeout: 3)
    }

    func testContentView() throws {
        var numberOfChanges = 0
        let exp = expectation(description: #function)
        ContentView()
            .viewInspectorOnPreferenceChange { view in
                numberOfChanges += 1
                print("Number of changes \(numberOfChanges)")
                switch numberOfChanges {
                case 1:
                    XCTAssertEqual(view.vm.counter, 0)
                    view.vm.increase()
                case 2:
                    XCTAssertEqual(view.vm.counter, 1)
                    view.vm.showSheet()
                case 3: break
                default: XCTFail()
                }
            }
            .viewInspectorReceiveOnAppear { (_: Text) in
                exp.fulfill()
            }
            .installView()
        wait(for: [exp], timeout: 3)
    }
}
