//
//  RealApp.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 24.12.23..
//

import SwiftUI

struct RealApp: App {
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 64) {
                ContentView()
                ContentModel()
            }
        }
    }
}
