//
//  TestingSupport.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 23.12.23..
//

import Combine
import SwiftUI

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
    private static var bodyEvaluationNotification: Notification.Name { Notification.Name("bodyEvaluationNotification") }
    
    var bodyAssertion: Bool {
        Self._printChanges()
        NotificationCenter.default.post(name: Self.bodyEvaluationNotification, object: self)
        return true
    }

    static func bodyEvaluations() -> AsyncPublisher<AnyPublisher<(Int, Self), Never>> {
        NotificationCenter.default
            .publisher(for: bodyEvaluationNotification)
            .compactMap { $0.object as? Self }
            .enumerated().values
    }
}
