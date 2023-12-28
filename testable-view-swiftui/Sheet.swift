//
//  Sheet.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 25.12.23..
//

import SwiftUI

struct Sheet: View {
    var body: some View {
        let _ = assertViewInspectorBody()
        Text("This is sheet")
    }
}

#Preview {
    Sheet()
}
