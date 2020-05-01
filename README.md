# ViperKit

VIPER module protocols for Vapor applications.


## Install

Add the repository as a dependency:

```swift
.package(url: "https://github.com/binarybirds/viper-kit.git", from: "1.2.0"),
```

Add ViperKit to the target dependencies:

```swift
.product(name: "ViperKit", package: "viper-kit"),
```

Update the packages and you are ready.

## Configuration

You can enable modular view directories for the Leaf template engine through ViperKit by calling `useViperViews()`.

The `#extend("Example/MyView")` or `render("Example/MyView")` snippets will look for views under the following places:

- Resources/Views/Example/MyView.leaf
- Sources/App/Modules/Example/Views/MyView.leaf

You can override the modulesDirectory if you are using a custom structure, default value is "Sources/App/Modules".

Here's an example configuration:

```swift
import Leaf
import Fluent
import Vapor
import ViperKit

public func configure(_ app: Application) throws {
    //...

    app.views.use(.leaf)
    app.leaf.useViperViews()

    //app.leaf.useViperViews(modulesDirectory: "Sources/App/Modules")

    let modules: [ViperModule] = [
        ExampleModule(),
    ]

    try app.viper.use(modules)
}
```

You'll have to configure all the modules that you'd like to use.

## Modules

A module can return:

- a router
- migrations
- a command group
- a lifecycle handler
- middlewares
- leaf tags

Basic example:

```swift
import ViperKit

final class ExampleModule: ViperModule {

    static var name: String = "example"

    var router: ViperRouter? = ExampleRouter()
}
```

Router:

```swift
import ViperKit

struct ExampleRouter: ViperRouter {
    
    func boot(routes: RoutesBuilder, app: Application) throws {
        routes.get { _ in "Hello ViperKit!" }
    }
}
```


## License

[WTFPL](LICENSE) - Do what the fuck you want to.
