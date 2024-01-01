# Testable SwiftUI views using async/await

### NOTE: All the boilerplate code you need is in [TestingSupport.swift](https://github.com/sisoje/testable-view-swiftui/blob/main/testable-view-swiftui/TestingSupport.swift) and it has 30 lines of code.

- This example demonstrates how to test any `SwiftUI.View` without hacks or third-party libraries, accomplished in just a few minutes of coding.
- We compare SwiftUI and MVVM and show that the `Observable` view-model approach may not be the best fit for SwiftUI, as it doesn't align well with its paradigm.

`SwiftUI.View` is just a protocol that only value types can conform to, its centerpiece being the `body` property, which produces another `SwiftUI.View`.

It lacks typical view properties like frame or color. This implies that `SwiftUI.View` isn't a traditional view.

`SwiftUI.View` looks and acts more like a view-model. Understanding this is key to grasping the essence of `SwiftUI.View`.

# SwiftUI model vs MVVM view-model

Anyone claiming how Apple coupled view and business logic is wrong. Apple just used View conformance on top of the model. That is not coupling. That is POP.

In SwiftUI it is up to you what goes to model and what goes to View conformance extension. Don't blame Apple if your code is entangled.

MVVM uses **HARD** decoupling which is more suitable for Java and other old-school languages.

We start with two similar implementations of our business logic:
```
struct ContentModel {
    @State var sheetShown = false
    @State var counter = 0
    func increase() { counter += 1 }
    func showSheet() { sheetShown.toggle() }
}

@Observable final class ContentViewModel {
    var sheetShown = false
    var counter = 0
    func increase() { counter += 1 }
    func showSheet() { sheetShown.toggle() }
}
```

# Model conformance vs VM composition

We can make two view variants, one is SwiftUI and the other is MVVM. One uses conformance and the other uses composition.
```
extension ContentModel: View {
    var body: some View {
        let _ = assert(bodyAssertion) // this is the only line in the view for testing support
        VStack {
            Text("The counter value is \(counter)")
            Button("Increase", action: increase)
            Button("Show sheet", action: showSheet)
        }
        .sheet(isPresented: $sheetShown) {
            Sheet()
        }
    }
}

struct ContentView: View {
    @State var vm = ContentViewModel()
    var body: some View {
        let _ = assert(bodyAssertion) // this is the only line in the view for testing support
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
```

# Native async/await testing

### App hosting

The key for view testing is to host the View in some App.

Shockingly, we do use Observable class because we need to share state between the main-target and the test-target:
```
struct TestApp: App {
    @State private var hosting = AnyViewHosting.shared
    var body: some Scene {
        WindowGroup {
            AnyView(hosting.view)
        }
    }
}
```
### Body evaluation notifications

We need to notify the test function that body evaluation happened. To achieve this is we add `let _ = assert(bodyAssertion)` as the first line of the body.

**NOTE: Assertion does not evaluate in release! We dont need #if DEBUG ...**

### Tests

We can test both SwiftUI and MVVM versions in the same way, no hacking, no third party libs.

We receive body-evaluation index and the view itself as an async sequence from our 30-lines of code "framework" so we can test if the evaluations behave like we intended:
```
func testContenModel() async throws {
    AnyViewHosting.shared.view = ContentModel()
    for await (index, view) in ContentModel.bodyEvaluations().prefix(2) {
        switch index {
        case 0:
            XCTAssertEqual(view.counter, 0)
            view.increase()
        case 1:
            XCTAssertEqual(view.counter, 1)
            view.showSheet()
        default: break
        }
    }
}

func testContentView() async throws {
    AnyViewHosting.shared.view = ContentView()
    for await (index, view) in ContentView.bodyEvaluations().prefix(2) {
        switch index {
        case 0:
            XCTAssertEqual(view.vm.counter, 0)
            view.vm.increase()
        case 1:
            XCTAssertEqual(view.vm.counter, 1)
            view.vm.showSheet()
        default: break
        }
    }
}
```

# Testing UI interactions using ViewInspector

Testing the body function using tools like ViewInspector, in conjunction with our native testing approach, allows us to interact with SwiftUI elements and to verify their values with each interaction.

Tests are identical for both SwiftUI and MVVM:
```
switch index {
case 0:
    _ = try view.inspect().find(text: "The counter value is 0")
    try view.inspect().find(button: "Increase").tap()
case 1:
    _ = try view.inspect().find(text: "The counter value is 1")
    try view.inspect().find(button: "Show sheet").tap()
default: break
}
```

# Body evaluations during the ViewInspector test

Test findings spotlight a disparity in number of body evaluations.

MVVM approach necessitates more evaluations of the view’s body, underscoring a potential inefficiency in how MVVM patterns integrate with SwiftUI’s rendering cycle.

### 2 body evaluations using SwiftUI
```
ContentModel: @self, @identity, _sheetShown, _counter changed.
ContentModel: _counter changed.
```

### 3 body evaluations using MVVM
```
ContentView: @self, @identity, _vm changed.
ContentView: @dependencies changed.
ContentView: @dependencies changed.
```

# Design flaws of MVVM in SwiftUI

- My biggest issue with MVVM is inability to use native property wrappers like @Environment, @AppStorage, @Query and others.
- View-models are not composable, while SwiftUI models(views) are very easy to split and reuse. MVVM just leads us to massive views and massive view-models. Its harder to split to smaller components. You need double amount of work to split them. You need to split VM and the View each on its own.
- Another problem with MVVM is usage of reference types. Using `[weak self]` everywhere is so annoying and misuse can lead to reference cycles.

Now that we know how to test "views" there is really no need to use MVVM.
