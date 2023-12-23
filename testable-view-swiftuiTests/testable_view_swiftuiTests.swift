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
    override func setUpWithError() throws {}

    func testExample() throws {
        var numberOfChanges = 0
        let exp = expectation(description: "host")
        let contentView = ContentView()
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
                default: fatalError()
                }
            }
            .viewInspectorReceiveOnAppear { (_: Text) in
                exp.fulfill()
            }

        let window = UIWindow()
        window.rootViewController = UIHostingController(rootView: contentView)
        window.makeKeyAndVisible()
        wait(for: [exp], timeout: 1)
    }
}
