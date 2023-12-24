//
//  BaseTest.swift
//  testable-view-swiftuiTests
//
//  Created by Lazar Otasevic on 24.12.23..
//

import Combine
@testable import testable_view_swiftui
import XCTest

class BaseTest: XCTestCase {
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {}

    override func tearDown() {
        cancellables.removeAll()
        ViewinspectorHosting.shared.view = nil
        waitForNextLoop()
    }

    func waitForNextLoop() {
        let exp = expectation(description: "wait for next loop")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}
