# SwiftUIToast

A simple Toast view in SwiftUI.

Key features:

- single wrapper over primary view
- global state, call from anywhere as function rather than wrapper and binding

## Usage

```swift
import SwiftUIToast
// Wrap your content in a ToastContainerView so that the toast can always appear on top.
// A good spot to put this is in your ContentView file.
SwiftUIToast.ToastContainerView {
    // Your content goes here
    ZStack{
        Color.green
            Button(action: {
                // Show a toast by calling the show function anywhere
                SwiftUIToast.show(
                    image: "airpodsmax",
                    text: "Playing music"
                )
            }) {
                Text("Toggle")
            }
    }
    .onAppear{
        // You can set the defaults any time to affect every Toast
        Toast.setDefaults(duration: 2.0, shadow: 0.0, position: .bottom)
    }

}
```
