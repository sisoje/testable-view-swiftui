//
//  testable_view_swiftuiApp.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 22.12.23..
//

import SwiftUI

@main
struct testable_view_swiftuiApp: App {
    var body: some Scene {
        WindowGroup {
            if NSClassFromString("XCTestCase") != nil {
                EmptyView()
            } else {
                ContentModel()
            }
        }
    }
}
