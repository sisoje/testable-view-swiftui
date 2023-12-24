//
//  ContentViewModelView.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 23.12.23..
//

import SwiftUI

struct ContentModel {
    @State var sheetShown = false
    @State var counter = 0
    func increase() { counter += 1 }
    func showSheet() { sheetShown.toggle() }
}
