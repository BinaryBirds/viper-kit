//
//  BundleFinder.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 11. 17..
//

/// original code:
/// https://developer.apple.com/forums/thread/652736
import class Foundation.Bundle

private class BundleFinder {}

extension Foundation.Bundle {

    /// Returns the resource bundle associated with the current Swift module.
    static func module(named name: String) -> Bundle {
        // This is your `target.path` (located in your `Package.swift`) by replacing all the `/` by the `_`.
        //let bundleName = "AAA_BBB"
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,
            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleFinder.self).resourceURL,
            // For command-line tools.
            Bundle.main.bundleURL,
        ]
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(name + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        return Bundle(for: BundleFinder.self)
    }
}
