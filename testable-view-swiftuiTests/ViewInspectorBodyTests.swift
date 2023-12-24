//
//  BodyTests.swift
//  testable-view-swiftuiTests
//
//  Created by Lazar Otasevic on 24.12.23..
//

import SwiftUI
@testable import testable_view_swiftui
import ViewInspector
import XCTest

final class ViewInspectorBodyTests: BaseTest {
    func testContenModel() throws {
        var numberOfChanges = 0

        let exp = expectation(description: "Sheet expectation")
        NotificationCenter.default.typedPublisher(.viewInspectorAppear).sink { (_: Text) in
            XCTAssertEqual(numberOfChanges, 2)
            exp.fulfill()
        }
        .store(in: &cancellables)

        ViewinspectorHosting.shared.view = ContentModel()
            .viewInspectorOnPreferenceChange { view in
                numberOfChanges += 1
                switch numberOfChanges {
                case 1:
                    XCTAssertEqual(view.counter, 0)
                    let button = try? view.inspect().find(button: "Increase")
                    XCTAssertNotNil(button)
                    try? button?.tap()
                case 2:
                    XCTAssertEqual(view.counter, 1)
                    let button = try? view.inspect().find(button: "Show sheet")
                    XCTAssertNotNil(button)
                    try? button?.tap()
                default: XCTFail()
                }
            }

        wait(for: [exp], timeout: 3)
    }

    func testContentView() throws {
        var numberOfChanges = 0

        let exp = expectation(description: "Sheet expectation")
        NotificationCenter.default.typedPublisher(.viewInspectorAppear).sink { (_: Text) in
            XCTAssertEqual(numberOfChanges, 3)
            exp.fulfill()
        }
        .store(in: &cancellables)

        ViewinspectorHosting.shared.view = ContentView()
            .viewInspectorOnPreferenceChange { view in
                numberOfChanges += 1
                switch numberOfChanges {
                case 1:
                    XCTAssertEqual(view.vm.counter, 0)
                    let button = try? view.inspect().find(button: "Increase")
                    XCTAssertNotNil(button)
                    try? button?.tap()
                case 2:
                    XCTAssertEqual(view.vm.counter, 1)
                    let button = try? view.inspect().find(button: "Show sheet")
                    XCTAssertNotNil(button)
                    try? button?.tap()
                case 3: break
                default: XCTFail()
                }
            }

        wait(for: [exp], timeout: 3)
    }
}
