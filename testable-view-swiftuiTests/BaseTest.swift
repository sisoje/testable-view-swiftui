//
//  BaseTest.swift
//  testable-view-swiftuiTests
//
//  Created by Lazar Otasevic on 24.12.23..
//

import Combine
@testable import testable_view_swiftui
import XCTest
import SwiftUI

class BaseTest: XCTestCase {
    var cancellables: Set<AnyCancellable> = []

    override func setUp() async throws {}

    override func tearDown() async throws {
        cancellables.removeAll()
    }
}
