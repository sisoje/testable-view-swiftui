# Testable SwiftUI views

## Note:

- This tutorial demonstrates how to test a `SwiftUI.View` in the same way you might test a view-model, without hacks or third-party libraries, accomplished in just a few minutes of coding.
- We show why the `ObservableObject` view-model approach may not be the best fit for SwiftUI, as it doesn't align well with its paradigm.

`SwiftUI.View` is a protocol that only value types can conform to, its centerpiece being the `body` function, which produces another `SwiftUI.View`. Understanding this is key to grasping the essence of `SwiftUI.View`.

This implies that `SwiftUI.View` isn't a traditional view—it lacks typical view properties like frame or color. So, we're left to wonder: What actually defines a `SwiftUI.View`?


# Attempting MVVM in SwiftUI

Consider two similar implementations:
```swift
class ContentViewModel: ObservableObject {
  @Published var sheetShown = false
  @Published var counter = 0
  func increase() { counter += 1 }
  func showSheet() { sheetShown.toggle() }
}

struct ContentModel {
  @State private var sheetShown = false
  @State private var counter = 0
  func increase() { counter += 1 }
  func showSheet() { sheetShown.toggle() }
}
```
One is a class, a reference type, incompatible with SwiftUI.View. The other, a struct—a value type—we can make conform to SwiftUI.View.

# SwiftUI.View couplig/decoupling

The native SwiftUI.View for ContentModel would look like this:
```swift
extension ContentModel: View {
    var body: some View {
        VStack {
            Text("The counter value is \(counter)")
            Button("Increase", action: increase)
            Button("Show sheet", action: showSheet)
        }
        .sheet(isPresented: $sheetShown) {
            Text("This is sheet")
        }
    }
}
```
By conforming to SwiftUI.View, we simply extend ContentModel with a body function. It remains akin to a view-model, except it’s a value type.

Did Apple really couple view and business logic? No! They followed the Open-Closed principle, took the model (functionally similar to a view-model), and extended it with a body function. That is protocol-oriented programming at work!

# MVVM practitioners

MVVM practitioners adapt the class-based view-model for SwiftUI like this:
```swift
struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    var body: some View {
        VStack {
            Text("The counter value is \(vm.counter)")
            Button("Increase", action: vm.increase)
            Button("Show sheet", action: vm.showSheet)
        }
        .sheet(isPresented: $vm.sheetShown) {
            Text("This is sheet")
        }
    }
}
```
What’s the justification for MVVM advocates to decouple as they do? It seems duplicative, given Apple’s use of protocol-oriented programming for innate decoupling.

The chosen path often fragments SwiftUI.View into a reference-type view-model, effectively diminishing the View to merely encapsulate a body function. This transformation not only hampers SwiftUI’s native state management but also renders native property wrappers like @Environment, @AppStorage, @Query, etc., unusable within the view-model class.

Additionally, MVVM proponents typically focus on extensively testing these view-models, yet they frequently overlook testing the body function, a critical piece in ensuring SwiftUI views behave as intended. Why test something that strays from the framework’s design?

Apple intentionally embraced value types for their safe and encapsulated nature. And so, the decision by MVVM enthusiasts to separate the view-model from the “view,” seems unnecessary, especially when such a physical view may not exist and when protocol-oriented programming already ensures decoupling.

Moreover, why concentrate on testing the view-model rather than the model itself? Disentangling the view-model from a speculative view appears counterproductive, especially when the view-in-question never physically manifests.

# Testing SwiftUI.View natively as a view-model

Testing the model aspect of a SwiftUI.View is straightforward. We “host” the SwiftUI.View to initialize @State in the view hierarchy, then notify the testing framework using a PreferenceKey that sets the model:
```swift
extension View {
    func viewInspectorPreference<T>(_ t: T) -> some View {
        preference(key: ViewInspectorPreferenceKey<T>.self, value: .init(value: t))
    }
}
```
Incorporate this modifier within the body:
```swift
.viewInspectorPreference(self)
```
Then, in testing code:
```swift
        ContentModel()
            .viewInspectorOnPreferenceChange { installedView in ... }
            .installView()
```
All native, free of hacking, pure Swift in just a few minutes. Say farewell to the need for MVVM!

# Testing SwiftUI.View body using ViewInspector

We should indeed test the body function of SwiftUI.View, as it plays a crucial role in mapping the state to the resulting view. Verifying that the body function behaves correctly is essential for ensuring the desired behavior of our SwiftUI views.

To accomplish this, one approach is to utilize tools like ViewInspector in combination with our native testing methodology. ViewInspector enables us to inspect and interact with the SwiftUI views, allowing us to assert that the state is correctly reflected in the view's output.

By testing the body function, we can validate that the view is rendered as expected based on the provided state. This helps us identify and address any issues or discrepancies that may occur during the mapping process.

In summary, testing the body function using tools like ViewInspector, in conjunction with our native testing approach, allows us to ensure the accurate mapping of state to the resulting SwiftUI.View

# Test Analysis

- The provided tests employ native SwiftUI inspection techniques to validate the view and view-model interactions, demonstrating the feasibility of in-depth SwiftUI testing without resorting to complex workarounds.
- Test findings spotlight a disparity in refresh cycles: the view-model approach necessitates three updates to the view’s body, whereas a direct SwiftUI approach requires only two, underscoring a potential inefficiency in how MVVM patterns integrate with SwiftUI’s rendering cycle.
- The additional rendering pass observed in MVVM may indicate a non-negligible performance overhead that could be critical in resource-intensive or highly dynamic interfaces.

It is essential to recognize that SwiftUI views are defined as value types with a body property, determining their rendered content. This understanding is key when considering how MVVM patterns might introduce extra complexity into this rendering process.

# Bonus - testing the sheet presentation logic

The ContentModel structure implements the SwiftUI View protocol and includes a sheet presentation controlled by the sheetShown Boolean state. The .sheet modifier is set to present a sheet when sheetShown is true. The content of the sheet includes a Text view with .viewInspectorPostOnAppear(), which posts a notification through a custom NotificationCenter when the sheet appears.

In testing, an asynchronous expectation is set up to listen for this notification using .viewInspectorReceiveOnAppear. When the notification is received, indicating the Text view has appeared (and thus the sheet is presented), the expectation is fulfilled, confirming the sheet presentation logic works as intended. This test assures that the navigation flow to the sheet in the SwiftUI app occurs as expected, relying solely on notification handling rather than visual verification.
