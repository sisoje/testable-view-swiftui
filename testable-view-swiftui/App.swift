//
//  testable_view_swiftuiApp.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 22.12.23..
//

import SwiftUI

@main enum baseApp {
    static func main() {
        if NSClassFromString("XCTestCase") != nil {
            testApp.main()
        } else {
            realApp.main()
        }
    }
}

struct testApp: App {
    init() {
        NotificationCenter.viewInspectorCenter = NotificationCenter()
    }
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

struct realApp: App {
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 64) {
                ContentView()
                ContentModel()
            }
        }
    }
}
