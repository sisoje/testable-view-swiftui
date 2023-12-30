//
//  TestApp.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 24.12.23..
//

import SwiftUI

struct TestApp: App {
    @State private var hosting = AnyViewHosting.shared
    var body: some Scene {
        WindowGroup {
            AnyView(hosting.view)
        }
    }
}
