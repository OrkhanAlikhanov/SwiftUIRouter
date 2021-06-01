[![License](https://img.shields.io/github/license/OrkhanAlikhanov/SwiftUIRouter.svg)](https://github.com/OrkhanAlikhanov/SwiftUIRouter/blob/master/LICENSE)

# SwiftUIRouter 🔗
An ⚠️experimental⚠️ navigation router for SwiftUI

## Usage
Check out [ExampleApp](https://github.com/OrkhanAlikhanov/SwiftUIRouter/tree/master/ExampleApp) for more.

Define your routes
```swift
import SwiftUIRouter

extension NavigationRouteLink {
  static var login: NavigationRouteLink { "/login" }
  static var signUp: NavigationRouteLink { "/register" }
  
  static func userDetails(for user: User) -> NavigationRouteLink {
    NavigationRouteLink(path: "/users/\(user.id)", meta: [
      "user": user, /// used 
    ])
  }
  
  static func userDetails(for id: Int) -> NavigationRouteLink {
    NavigationRouteLink(path: "/users/\(id)")
  }
}
```

Implement how they should be resolved:
```swift
extension Array where Element == NavigationRoute {
  static var all: [NavigationRoute] {
    let login = NavigationRoute(path: "/login", destination: LoginPage())
    let register = NavigationRoute(path: "/register", destination: RegisterPage())
    let user = NavigationRoute(path: "/users/{id}") { route in
      /// meta "user" can passed when creating `NavigationRouteLink`. Eg. in `userDetails(for user: User)`
      /// Useful when you go to user details page and want to show user something until detailed data comes in.
      UserPage(user: route.meta("user") ?? User(id: route.int("id"), name: "Unknown"))
    }

    return [login, register, user]
  }
}
```

Create root app:
```swift
struct ExampleApp: View {
  var body: some View {
    NavigationView {
      RouterView(router: .main, root: .login)
    }
    /// I don't know why, but setting \.router in RouterView itself was not enough. Probably NavigationView
    /// overrides environment of its children somehow. So we set \.router environment again
    .environment(\.router, .main)
    
    /// This is important because default one (DoubleColumnNavigationViewStyle) is
    /// updating NavigationLink.$isActive inconsistently causing navigation bugs.
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

extension NavigationRouter {
  static var main = NavigationRouter(routes: .all)
}
```

Benefit:
```swift
struct LoginPage: View {
  @Environment(\.router) var router
  
  var body: some View {
    VStack {
      RouterLink(.signUp) { /// or use RouterLink("/register")
        Text("Don't have an acccount? Register here")
      }

      Button("Log in") {
        router.push(link: .userDetails(for: User(id: 1, name: "Orkhan")))
        // router.push(link: .userDetails(for: /* id */ 1)
      }
    }
    .navigationTitle("Login")
  }
}
```

## Other works
- [LayoutSwift](https://github.com/OrkhanAlikhanov/LayoutSwift) - Yet another Swift Autolayout DSL for iOS.
- [ChainSwift](https://github.com/OrkhanAlikhanov/ChainSwift) - ChainSwift 🔗 is an extension that provides chainable way of setting properties.

## Installation

### Swift Package Manager

_Note: Instructions below are for using **SwiftPM** without the Xcode UI. It's the easiest to go to your Project Settings -> Swift Packages and add SwiftUIRouter from there._

To integrate using Apple's [Swift Package Manager](https://swift.org/package-manager/) , without Xcode integration, add the following as a dependency to your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/OrkhanAlikhanov/SwiftUIRouter.git", .upToNextMajor(from: "1.0.0"))
]
```
and then specify `"SwiftUIRouter"` as a dependency of the Target in which you wish to use SwiftUIRouter.

### Manually
Just drag and drop the files in the [Sources](https://github.com/OrkhanAlikhanov/SwiftUIRouter/blob/master/Sources) folder.

## Authors
* **Orkhan Alikhanov** - *Initial work* - [OrkhanAlikhanov](https://github.com/OrkhanAlikhanov)

See also the list of [contributors](https://github.com/OrkhanAlikhanov/SwiftUIRouter/contributors) who participated in this project.

## Love our work?
Hit the star 🌟 button! It helps! ❤️

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/OrkhanAlikhanov/SwiftUIRouter/blob/master/LICENSE) file for details
