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

    override func setUp() {
        ViewinspectorHosting.shared.view = nil
    }

    override func tearDown() {
        cancellables.removeAll()
        ViewinspectorHosting.shared.view = nil
    }
}
