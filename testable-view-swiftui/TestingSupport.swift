//
//  TestingSupport.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 23.12.23..
//

import Combine
import SwiftUI

@Observable final class ViewinspectorHosting {
    static let shared = ViewinspectorHosting()
    var view: any View = EmptyView()
}

extension Publisher {
    func enumerated() -> AnyPublisher<(Int, Output), Failure> {
        scan(nil) { acc, next in
            (acc.map { $0.0 + 1 } ?? 0, next)
        }
        .compactMap { $0 }
        .eraseToAnyPublisher()
    }
}

extension View {
    private static var viewInspectorBody: Notification.Name { Notification.Name("viewInspectorBody") }
    
    var bodyAssertion: Bool {
        Self._printChanges()
        NotificationCenter.default.post(name: Self.viewInspectorBody, object: self)
        return true
    }

    static func viewInspectorAsync() -> AsyncPublisher<AnyPublisher<(Int, Self), Never>> {
        NotificationCenter.default
            .publisher(for: viewInspectorBody)
            .compactMap { $0.object as? Self }
            .enumerated().values
    }
}
