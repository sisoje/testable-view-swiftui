//
//  ContentView.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 22.12.23..
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    var body: some View {
        VStack {
            Text("The counter value is \(vm.counter)")
            Button("Increase", action: vm.increase)
            Button("Show sheet", action: vm.showSheet)
        }
        .viewInspectorPreference(self)
        .sheet(isPresented: $vm.sheetShown) {
            Text("This is sheet")
                .viewInspectorPostOnAppear()
        }
    }
}

#Preview {
    ContentView()
}
