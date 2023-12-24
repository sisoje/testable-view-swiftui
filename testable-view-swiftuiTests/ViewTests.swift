//
//  testable_view_swiftuiTests.swift
//  testable-view-swiftuiTests
//
//  Created by Lazar Otasevic on 22.12.23..
//

import Combine
import SwiftUI
@testable import testable_view_swiftui
import XCTest

final class ViewTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []

    override func tearDown() {
        cancellables.removeAll()
        ViewinspectorHosting.shared.view = nil
    }

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
                    view.increase()
                case 2:
                    XCTAssertEqual(view.counter, 1)
                    view.showSheet()
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
                    view.vm.increase()
                case 2:
                    XCTAssertEqual(view.vm.counter, 1)
                    view.vm.showSheet()
                case 3: break
                default: XCTFail()
                }
            }

        wait(for: [exp], timeout: 3)
    }
}
