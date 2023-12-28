# Testable SwiftUI views

- This example demonstrates how to test any `SwiftUI.View` without hacks or third-party libraries, accomplished in just a few minutes of coding.
- We compare SwiftUI and MVVM and show that the `Observable` view-model approach may not be the best fit for SwiftUI, as it doesn't align well with its paradigm.

`SwiftUI.View` is a protocol that only value types can conform to, its centerpiece being the `body` property, which produces another `SwiftUI.View`. Understanding this is key to grasping the essence of `SwiftUI.View`.

This implies that `SwiftUI.View` isn't a traditional view. It lacks typical view properties like frame or color. `SwiftUI.View` looks and acts more like a view-model.

# SwiftUI model vs MVVM view-model

Anyone claiming how Apple coupled view and business logic is not completely correct. Apple just used View conformance on top of the model. That is not coupling. That is POP.

MVVM uses hard-decoupling which is more suitable for Java and other old-school languages.

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

We can make two view variants, one is pure SwiftUI and the other is MVVM:
```
extension ContentModel: View {
    var body: some View {
        let _ = assertViewInspectorBody() // this is the line for testing support
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
        let _ = assertViewInspectorBody() // this is the line for testing support
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

# Native async testing

### App hosting

The key for view testing is to host the View in some App. Its very simple:
```
struct TestApp: App {
    @State private var hosting = ViewinspectorHosting.shared // for shared state we do use @Observable class
    var body: some Scene {
        WindowGroup {
            AnyView(hosting.view)
        }
    }
}
```

### Tests

We can test both pure SwiftUI and MVVM versions in the same way, no hacking, no third party libs, simple:
```
func testContenModel() async throws {
    ViewinspectorHosting.shared.view = ContentModel()
    for try await (index, view) in ContentModel.viewInspectorAsync().prefix(2) {
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
    ViewinspectorHosting.shared.view = ContentView()
    for try await (index, view) in ContentView.viewInspectorAsync().prefix(2) {
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

# Testing `body` using ViewInspector

Testing the body function using tools like ViewInspector, in conjunction with our native testing approach, allows us to ensure the accurate mapping of state to the resulting SwiftUI.View.

Tests are almost identical:
```
func testContenModel() async throws {
    ViewinspectorHosting.shared.view = ContentModel()
    for try await (index, view) in ContentModel.viewInspectorAsync().prefix(2) {
        switch index {
        case 0:
            XCTAssertEqual(view.counter, 0)
            try view.inspect().find(button: "Increase").tap()
        case 1:
            XCTAssertEqual(view.counter, 1)
            try view.inspect().find(button: "Show sheet").tap()
        default: break
        }
    }
}

func testContentView() async throws {
    ViewinspectorHosting.shared.view = ContentView()
    for try await (index, view) in ContentView.viewInspectorAsync().prefix(2) {
        switch index {
        case 0:
            XCTAssertEqual(view.vm.counter, 0)
            try view.inspect().find(button: "Increase").tap()
        case 1:
            XCTAssertEqual(view.vm.counter, 1)
            try view.inspect().find(button: "Show sheet").tap()
        default: break
        }
    }
}
```

# Test Analysis

Test findings spotlight a disparity in refresh cycles: the view-model approach necessitates more updates to the view’s body, underscoring a potential inefficiency in how MVVM patterns integrate with SwiftUI’s rendering cycle.

### Body evaluations using pure SwiftUI
```
ContentModel: @self, @identity, _sheetShown, _counter changed.
ContentModel: unchanged.
ContentModel: unchanged.
ContentModel: _counter changed.
ContentModel: unchanged.
ContentModel: unchanged.
Sheet: @self changed.
```

### Body evaluations using MVVM
```
ContentView: @self, @identity, _vm changed.
ContentView: unchanged.
ContentView: unchanged.
ContentView: @dependencies changed.
ContentView: unchanged.
ContentView: unchanged.
ContentView: @dependencies changed.
Sheet: @self changed.
```

# Design flaw of MVVM

My biggest issue with MVVM is inability to use native property wrappers like @Environment, @AppStorage, @Query and others.

Now that we know how to test "views" there is really no need to use MVVM.
