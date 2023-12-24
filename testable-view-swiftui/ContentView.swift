//
//  ContentView.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 22.12.23..
//

import SwiftUI

struct ContentView: View {
    @State var vm = ContentViewModel()
    var body: some View {
        VStack {
            Text("This is MVVM")
            Text("The counter value is \(vm.counter)")
            Button("Increase", action: vm.increase)
            Button("Show sheet", action: vm.showSheet)
        }
        .sheet(isPresented: $vm.sheetShown) {
            Text("This is sheet")
                .viewInspectorPostOnAppear()
        }
        .viewInspectorPreference(self)
    }
}

#Preview {
    ContentView()
}
