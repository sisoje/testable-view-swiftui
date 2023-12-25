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

struct FalseEquatableValueWrapper<T>: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool { false }
    var value: T?
}

struct ViewInspectorPreferenceKey<T>: PreferenceKey {
    static var defaultValue: FalseEquatableValueWrapper<T> { FalseEquatableValueWrapper() }
    static func reduce(value: inout Value, nextValue: () -> Value) { assertionFailure("this should not be called") }
}

extension Notification.Name {
    static let viewInspectorAppear = Notification.Name("viewInspectorAppear")
    static let viewInspectorDisappear = Notification.Name("viewInspectorDisappear")
}

extension NotificationCenter {
    func typedPublisher<T>(_ name: Notification.Name) -> AnyPublisher<T, Never> {
        publisher(for: name).compactMap { $0.object as? T }.eraseToAnyPublisher()
    }
}

extension View {
    func viewInspectorPreference<T>(_ t: T) -> some View {
        preference(key: ViewInspectorPreferenceKey<T>.self, value: .init(value: t))
    }

    func viewInspectorOnPreferenceChange(_ block: @escaping (Self) -> Void) -> some View {
        onPreferenceChange(ViewInspectorPreferenceKey<Self>.self) { pref in
            guard let v = pref.value else {
                return
            }
            DispatchQueue.main.async {
                block(v)
            }
        }
    }

    func viewInspectorPostLifecycle() -> some View {
        onAppear {
            NotificationCenter.default.post(name: .viewInspectorAppear, object: self)
        }
        .onDisappear {
            NotificationCenter.default.post(name: .viewInspectorDisappear, object: self)
        }
    }
}
