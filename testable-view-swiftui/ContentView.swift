//
//  ContentView.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 22.12.23..
//

import Combine
import SwiftUI

struct ContentView: View {
    @State private(set) var sheetShown = false
    @State private(set) var counter = 0

    func increase() {
        counter += 1
    }

    func showSheet() {
        sheetShown.toggle()
    }

    var body: some View {
        VStack {
            Text("The counter value is \(counter)")

            Button("Increase", action: increase)

            Button("Show sheet", action: showSheet)
        }
        .viewInspectorPreference(self)
        .sheet(isPresented: $sheetShown) {
            Text("This is sheet")
                .viewInspectorPostOnAppear()
        }
    }
}

#Preview {
    ContentView()
}
