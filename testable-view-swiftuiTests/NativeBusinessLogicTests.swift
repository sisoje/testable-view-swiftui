//
//  testable_view_swiftuiTests.swift
//  testable-view-swiftuiTests
//
//  Created by Lazar Otasevic on 22.12.23..
//

import SwiftUI
@testable import testable_view_swiftui
import XCTest

@MainActor final class NativeBusinessLogicTests: XCTestCase {
    func testContenModel() async throws {
        ViewinspectorHosting.shared.view = ContentModel()

        for try await (index, view) in ContentModel.viewInspectorAsync().prefix(2) {
            switch index {
            case 0:
                XCTAssertEqual(view.counter, 0)
                view.increase()
            case 1:
                XCTAssertEqual(view.counter, 1)
                view.showSheet()
            default: break
            }
        }
        
        for try await _ in Sheet.viewInspectorAsync().prefix(1) {}
    }

    func testContentView() async throws {
        ViewinspectorHosting.shared.view = ContentView()

        for try await (index, view) in ContentView.viewInspectorAsync().prefix(2) {
            switch index {
            case 0:
                XCTAssertEqual(view.vm.counter, 0)
                view.vm.increase()
            case 1:
                XCTAssertEqual(view.vm.counter, 1)
                view.vm.showSheet()
            default: break
            }
        }
        
        for try await _ in Sheet.viewInspectorAsync().prefix(1) {}
    }
}
