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
        let _ = assertViewInspectorBody()
        VStack {
            Text("The counter value is \(vm.counter)")
            Button("Increase", action: vm.increase)
            Button("Show sheet", action: vm.showSheet)
        }
        .sheet(isPresented: $vm.sheetShown) {
            Sheet()
        }
    }
}

#Preview {
    ContentView()
}
