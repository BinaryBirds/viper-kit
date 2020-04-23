//
//  SelectionFormField.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 04. 21..
//

import Foundation

/// can be used for option lists
public struct SelectionFormField: FormField {
    /// selectable option
    public struct Option: Encodable {
        /// key of the option
        public let key: String
        /// title of the option
        public let label: String
        
        public init(key: String, label: String) {
            self.key = key
            self.label = label
        }
    }
    /// value of the selected option key
    public var value: String
    /// error message
    public var error: String?
    /// available options
    public var options: [Option]
    
    public init(value: String = "", error: String? = nil, options: [Option] = []) {
        self.value = value
        self.error = error
        self.options = options
    }
}
