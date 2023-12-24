//
//  ContentViewModelView.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 23.12.23..
//

import SwiftUI

struct ContentModel {
    @State private(set) var sheetShown = false
    @State private(set) var counter = 0
    func increase() { counter += 1 }
    func showSheet() { sheetShown.toggle() }
}

extension ContentModel: View {
    var body: some View {
        VStack {
            Text("The counter value is \(counter)")
            Button("Increase", action: increase)
            Button("Show sheet", action: showSheet)
        }
        .sheet(isPresented: $sheetShown) {
            Text("This is sheet")
                .viewInspectorPostOnAppear()
        }
        .viewInspectorPreference(self)
    }
}

#Preview {
    ContentModel()
}
