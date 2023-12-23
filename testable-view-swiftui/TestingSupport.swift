//
//  TestingSupport.swift
//  testable-view-swiftui
//
//  Created by Lazar Otasevic on 23.12.23..
//

import Combine
import SwiftUI

struct ViewInspectorPreferenceKey<T>: PreferenceKey {
    struct FalseEquatableValueWrapper: Equatable {
        static func == (lhs: Self, rhs: Self) -> Bool { false }
        var value: T?
    }

    static var defaultValue: FalseEquatableValueWrapper { FalseEquatableValueWrapper() }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        fatalError()
    }
}

private extension NotificationCenter {
    static func viewInspectorName<T>(_ t: T.Type) -> Notification.Name {
        Notification.Name(rawValue: String(describing: ViewInspectorPreferenceKey<T>.self))
    }

    func viewInspectorPost<T>(_ v: T) {
        post(name: Self.viewInspectorName(T.self), object: v)
    }

    func viewInspectorPublisher<T>() -> AnyPublisher<T, Never> {
        publisher(for: Self.viewInspectorName(T.self)).map { $0.object as! T }.eraseToAnyPublisher()
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
        onAppear { NotificationCenter.default.viewInspectorPost(self) }
    }

    func viewInspectorReceiveOnAppear<T>(_ block: @escaping (T) -> Void) -> some View {
        onReceive(NotificationCenter.default.viewInspectorPublisher(), perform: block)
    }
}
