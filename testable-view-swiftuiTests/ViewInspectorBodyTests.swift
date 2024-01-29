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
        TestApp.shared.view = ContentModel()
        for await (index, view) in ContentModel.bodyEvaluations().prefix(2) {
            switch index {
            case 0:
                _ = try view.inspect().find(text: "The counter value is 0")
                try view.inspect().find(button: "Increase").tap()
            case 1:
                _ = try view.inspect().find(text: "The counter value is 1")
                try view.inspect().find(button: "Show sheet").tap()
                for await (_, view) in Sheet.bodyEvaluations().prefix(1) {
                    _ = try view.inspect().find(text: "This is sheet")
                }
            default: break
            }
        }
    }

    func testContentView() async throws {
        TestApp.shared.view = ContentView()
        for await (index, view) in ContentView.bodyEvaluations().prefix(2) {
            switch index {
            case 0:
                _ = try view.inspect().find(text: "The counter value is 0")
                try view.inspect().find(button: "Increase").tap()
            case 1:
                _ = try view.inspect().find(text: "The counter value is 1")
                try view.inspect().find(button: "Show sheet").tap()
                for await (_, view) in Sheet.bodyEvaluations().prefix(1) {
                    _ = try view.inspect().find(text: "This is sheet")
                }
            default: break
            }
        }
    }
}
