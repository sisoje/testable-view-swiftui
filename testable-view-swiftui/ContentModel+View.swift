//
//  ContentModel+View.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 24.12.23..
//

import SwiftUI

extension ContentModel: View {
    var body: some View {
        VStack {
            Text("This is pure SwiftUI")
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
