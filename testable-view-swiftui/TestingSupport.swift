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
    var view: (any View)?
}

struct FalseEquatableValueWrapper<T>: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool { false }
    var value: T?
}

struct ViewInspectorPreferenceKey<T>: PreferenceKey {
    static var defaultValue: FalseEquatableValueWrapper<T> { FalseEquatableValueWrapper() }
    static func reduce(value: inout Value, nextValue: () -> Value) { assertionFailure("this should not be called") }
}

extension NotificationCenter {
    static var viewInspectorCenter: NotificationCenter?

    func viewInspectorPost<T>(_ v: T) {
        post(name: .init(String(describing: T.self)), object: v)
    }

    func viewInspectorPublisher<T>() -> AnyPublisher<T, Never> {
        publisher(for: .init(String(describing: T.self))).map { $0.object as! T }.eraseToAnyPublisher()
    }
}

extension View {
    func viewInspectorPreference<T>(_ t: T) -> some View {
        preference(key: ViewInspectorPreferenceKey<T>.self, value: .init(value: t))
    }

    func viewInspectorOnPreferenceChange(_ block: @escaping (Self) -> Void) -> some View {
        onPreferenceChange(ViewInspectorPreferenceKey<Self>.self) { block($0.value!) }
    }

    func viewInspectorPostOnAppear() -> some View {
        onAppear { NotificationCenter.viewInspectorCenter?.viewInspectorPost(self) }
    }
}
