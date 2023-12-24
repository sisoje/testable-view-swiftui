//
//  BaseTest.swift
//  testable-view-swiftuiTests
//
//  Created by Lazar Otasevic on 24.12.23..
//

import XCTest
import Combine
@testable import testable_view_swiftui

class BaseTest: XCTestCase {
    var cancellables: Set<AnyCancellable> = []

    override func tearDown() {
        cancellables.removeAll()
        ViewinspectorHosting.shared.view = nil
    }
}
