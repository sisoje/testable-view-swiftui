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

@MainActor final class ViewInspectorBodyTests: XCTestCase {
    func testContenModel() async throws {
        AnyViewHosting.shared.view = ContentModel()
        for try await (index, view) in ContentModel.bodyEvaluationsPublisher().prefix(2) {
            switch index {
            case 0:
                XCTAssertEqual(view.counter, 0)
                try view.inspect().find(button: "Increase").tap()
            case 1:
                XCTAssertEqual(view.counter, 1)
                try view.inspect().find(button: "Show sheet").tap()
                for try await _ in Sheet.bodyEvaluationsPublisher().prefix(1) {}
            default: break
            }
        }
    }

    func testContentView() async throws {
        AnyViewHosting.shared.view = ContentView()
        for try await (index, view) in ContentView.bodyEvaluationsPublisher().prefix(2) {
            switch index {
            case 0:
                XCTAssertEqual(view.vm.counter, 0)
                try view.inspect().find(button: "Increase").tap()
            case 1:
                XCTAssertEqual(view.vm.counter, 1)
                try view.inspect().find(button: "Show sheet").tap()
                for try await _ in Sheet.bodyEvaluationsPublisher().prefix(1) {}
            default: break
            }
        }
    }
}
