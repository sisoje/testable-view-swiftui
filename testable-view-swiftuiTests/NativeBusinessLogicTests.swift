//
//  testable_view_swiftuiTests.swift
//  testable-view-swiftuiTests
//
//  Created by Lazar Otasevic on 22.12.23..
//

import SwiftUI
@testable import testable_view_swiftui
import XCTest

final class NativeBusinessLogicTests: XCTestCase {}

@MainActor extension NativeBusinessLogicTests {
    func testContenModel() async throws {
        TestApp.shared.view = ContentModel()
        for await (index, view) in ContentModel.bodyEvaluations().prefix(2) {
            switch index {
            case 0:
                XCTAssertEqual(view.counter, 0)
                view.increase()
            case 1:
                XCTAssertEqual(view.counter, 1)
                view.showSheet()
                for await _ in Sheet.bodyEvaluations().prefix(1) {}
            default: break
            }
        }
    }
    
    func testContentView() async throws {
        TestApp.shared.view = ContentView()
        for await (index, view) in ContentView.bodyEvaluations().prefix(2) {
            switch index {
            case 0:
                XCTAssertEqual(view.vm.counter, 0)
                view.vm.increase()
            case 1:
                XCTAssertEqual(view.vm.counter, 1)
                view.vm.showSheet()
                for await _ in Sheet.bodyEvaluations().prefix(1) {}
            default: break
            }
        }
    }
}
