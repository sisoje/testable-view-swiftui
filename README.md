# Testable SwiftUI Views
NOTE:
- In this example I show you how to test the SwiftUI.View natively, the same way like you would test view-model, no hacking, no third party libs, all made in few minutes of coding.
- The test shows how ObservableObject view-model is not optimal approach. It basically makes no sense in SwiftUI.

SwifUI.View is just a protocol that ANY value and ONLY value can conform to. It contains body function that evaluates to yet another SwiftUI.View. That is all we need to know about the SwiftUI.View.

That means SwiftUI.View is not a real view, it has no property of a real view that we can access, no frame, no color, nothing. So what REALLY is a SwiftUI.View?

# Attempting MVVM in SwiftUI

Lets see two very similar, basically the same, implementations:

```
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
One is a class, a reference type, and it can never conform to a SwiftUI.View.\
The other is a struct, a value type, and we are going to conform it to a SwiftUI.View:

```
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
It's clear that by conforming SwiftUI.View we basically just extend out ContentModel with a body function. It is basically the same as view-model with exception that it is a value type.

Did Apple really couple "view" and the business logic? They did not! They followed Open-Closed principle. They just took the model (which is practically the same as view-model) and extended it with a body function.

# MVVM practitioners

The view-model class is abused by MVVM practitioners and they make a SwiftUI.View like this:
```
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
Apple purposly used value type with body function extension, but MVVM practitioners decided to rip it apart, turn it into a rfeference type mess. Why? So that can test MVVM, really?

What do MVVM practitioners try to decouple here? As we see its already decoupled. In the process of view-model decoupling from some imaginary view that does not exist, MVVM practitioners broke the native state management and now all the native wrappers can not be used inside the view-model, such as: @Environment @AppStorage @Query and others.

MVVM practitioners just want to test their VM even though it broke fundamentals of SwiftUI. Why test it? Its broken, there is nothing to test.

And who will test the body function? MVVM practitioners simply do not care! They ignore the fact that SwiftUI.View is not a view. They simply ignore the body function, with the excuse that views should not be tested.

# Testing SwiftUI.View using third party

Since SwiftUI.View is a value with a body function. We SHOULD test the body function. We need to test if the body correctly maps the state to the resulting SwiftUI.View.
To do that we may use ViewInspector.

# Testing SwiftUI.View natively as a view-model

We can easily implement testing of the model part of the SwiftUI.View. All we need to do is to "host" the SwiftUI.View so that @State can be installed into view hierarchy.
Next, we need to notify the testing framework that State is installed. We do that with PreferenceKey and setting the "self" that is our model into that key.
```
extension View {
    func viewInspectorPreference<T>(_ t: T) -> some View {
        preference(key: ViewInspectorPreferenceKey<T>.self, value: .init(value: t))
    }
}
```
apply modifier inside the body (we need only this one line in production code):
```
.viewInspectorPreference(self)
```
And then in the test observe it and install the view (in our testing code):
```
        ContentModel()
            .viewInspectorOnPreferenceChange { installedView in ... }
            .installView()
```
All natively, no hacking, pure swift in few minutes of coding. MVVM needs to burn in flames!


