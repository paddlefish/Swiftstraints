 //
//  LayoutConstraints.swift
//  Swiftstraints
//
//  Created by Bradley Hilton on 5/12/15.
//  Copyright (c) 2015 Skyvive. All rights reserved.
//

import Foundation

private func vflKey(_ object: AnyObject) -> String {
    return "A\(UInt(bitPattern: unsafeAddress(of: object).hashValue))B"
}

 func + <Key, Value>(lh: [Key : Value], rh: [Key : Value]) -> [Key : Value] {
    var dictionary = lh
    for (key, value) in rh {
        dictionary[key] = value
    }
    return dictionary
 }

class WeakView {
    weak var view: UIView?
    init(view: UIView) {
        self.view = view
    }
}

private func strongViewDictionary( weak: [String:WeakView]) -> [String:UIView] {
    var strong = [String:UIView]()
    for k in weak {
        if let view = k.value.view {
            strong[k.key] = view
        }
    }
    return strong
}

/// Represents constraints created from a interpolated string in the visual format language.
public struct VisualFormatLanguage : StringInterpolationConvertible {
    
    let format: String
    var metrics = [String : NSNumber]()
    var views = [String : WeakView]()
    
    public init(stringInterpolation strings: VisualFormatLanguage...) {
        format = strings
            .map { $0.format }
            .joined(separator: "")
        views = strings.reduce([:]) {
            return $0.0 + $0.1.views
        }
        metrics = strings.reduce([:]) {
            return $0.0 + $0.1.metrics
        }
    }
    
    public init<T>(stringInterpolationSegment expr: T) {
        format = String(expr)
    }
    
    public init(stringInterpolationSegment view: UIView) {
        format = vflKey(view)
        views[format] = WeakView(view: view)
    }
    
    public init(stringInterpolationSegment number: NSNumber) {
        format = vflKey(number)
        metrics[format] = number
    }
    
    /// Returns layout constraints with options.
    public func constraints(_ options: NSLayoutFormatOptions) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: strongViewDictionary(weak: views))
    }
    
    /// Returns layout constraints.
    public var constraints: [NSLayoutConstraint] {
        return constraints([])
    }
    
}

public typealias NSLayoutConstraints = [NSLayoutConstraint]

extension Array where Element : NSLayoutConstraint {
    
    /// Create a list of constraints using a string interpolated with nested views and metrics.
    /// You can optionally include NSLayoutFormatOptions as the second parameter.
    public init(_ visualFormatLanguage: VisualFormatLanguage, options: NSLayoutFormatOptions = []) {
        if let constraints = visualFormatLanguage.constraints(options) as? [Element] {
            self = constraints
        } else {
            self = []
        }
    }
    
}
