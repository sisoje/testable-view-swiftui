//
//  TestApp.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 24.12.23..
//

import SwiftUI

struct TestApp: App {
    static var shared: Self!
    @State var view: any View = EmptyView()
    var body: some Scene {
        let _ = Self.shared = self
        WindowGroup {
            AnyView(view)
        }
    }
}
