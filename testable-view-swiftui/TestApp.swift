//
//  TestApp.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 24.12.23..
//

import SwiftUI

struct TestApp: App {
    @State var vm = ViewinspectorHosting.shared
    var body: some Scene {
        WindowGroup {
            if let v = vm.view {
                AnyView(v)
            } else {
                EmptyView()
            }
        }
    }
}
