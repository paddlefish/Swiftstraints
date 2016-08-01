//
//  AxisAnchor.swift
//  Swiftstraints
//
//  Created by Bradley Hilton on 10/22/15.
//  Copyright © 2015 Skyvive. All rights reserved.
//

import Foundation

// There doesn't seem to be a way satisfy Swift 3's compiler with respect to
// generics, protocols, extensions, etc... in such a way that we can
// describe AxisAnchor in a generic fashion :-/
// The crux of the problem is that we can't describe the return type
// of the add function using a protocol with an associated type.
// (We run into "Protocol 'AxisAnchor' can only be used as a generic
// constraint because it has Self or associated type requirements")
// So I've created two more concrete sets of protocols and structs
// to handle X & Y axes. Buyer beware: Changes here need to be propagated
// across both. :-(
// -- [Andrew Rahn 2016-07-31]

public protocol XAxisAnchor {
    var anchor: NSLayoutXAxisAnchor { get }
    var constant: CGFloat { get }
    var priority: LayoutPriority { get }
}

struct CompoundXAxis : XAxisAnchor {
    let anchor: NSLayoutXAxisAnchor
    let constant: CGFloat
    let priority: LayoutPriority
}

extension XAxisAnchor {

    func add(addend: CGFloat) -> XAxisAnchor {
        return CompoundXAxis(anchor: anchor, constant: constant + addend, priority: priority)
    }

}

extension NSLayoutXAxisAnchor {
    public var anchor: NSLayoutXAxisAnchor { return self }
    public var constant: CGFloat { return 0 }
    public var priority: LayoutPriority { return .required }
}

extension NSLayoutXAxisAnchor : XAxisAnchor {}
//extension NSLayoutYAxisAnchor : AxisAnchor {}

/// Create a layout constraint from an inequality comparing two axis anchors.
public func <=(lhs: XAxisAnchor, rhs: XAxisAnchor) -> NSLayoutConstraint {
    return lhs.anchor.constraint(lessThanOrEqualTo: rhs.anchor, constant: rhs.constant - lhs.constant).priority(rhs.priority)
}

/// Create a layout constraint from an equation comparing two axis anchors.
public func ==(lhs: XAxisAnchor, rhs: XAxisAnchor) -> NSLayoutConstraint {
    return lhs.anchor.constraint(equalTo: rhs.anchor, constant: rhs.constant - lhs.constant).priority(rhs.priority)
}

/// Create a layout constraint from an inequality comparing two axis anchors.
public func >=(lhs: XAxisAnchor, rhs: XAxisAnchor) -> NSLayoutConstraint {
    return lhs.anchor.constraint(greaterThanOrEqualTo: rhs.anchor, constant: rhs.constant - lhs.constant).priority(rhs.priority)
}

/// Add a constant to an axis anchor.
public func +(axis: XAxisAnchor, addend: CGFloat) -> XAxisAnchor {
    return axis.add(addend: addend)
}

/// Add a constant to an axis anchor.
public func +(addend: CGFloat, axis: XAxisAnchor) -> XAxisAnchor {
    return axis.add(addend: addend)
}

/// Subtract a constant from an axis anchor.
public func -(axis: XAxisAnchor, subtrahend: CGFloat) -> XAxisAnchor {
    return axis.add(addend: -subtrahend)
}



public protocol YAxisAnchor {
    var anchor: NSLayoutYAxisAnchor { get }
    var constant: CGFloat { get }
    var priority: LayoutPriority { get }
}

struct CompoundYAxis : YAxisAnchor {
    let anchor: NSLayoutYAxisAnchor
    let constant: CGFloat
    let priority: LayoutPriority
}

extension YAxisAnchor {

    func add(addend: CGFloat) -> YAxisAnchor {
        return CompoundYAxis(anchor: anchor, constant: constant + addend, priority: priority)
    }

}

extension NSLayoutYAxisAnchor {
    public var anchor: NSLayoutYAxisAnchor { return self }
    public var constant: CGFloat { return 0 }
    public var priority: LayoutPriority { return .required }
}

extension NSLayoutYAxisAnchor : YAxisAnchor {}
//extension NSLayoutYAxisAnchor : AxisAnchor {}

/// Create a layout constraint from an inequality comparing two axis anchors.
public func <=(lhs: YAxisAnchor, rhs: YAxisAnchor) -> NSLayoutConstraint {
    return lhs.anchor.constraint(lessThanOrEqualTo: rhs.anchor, constant: rhs.constant - lhs.constant).priority(rhs.priority)
}

/// Create a layout constraint from an equation comparing two axis anchors.
public func ==(lhs: YAxisAnchor, rhs: YAxisAnchor) -> NSLayoutConstraint {
    return lhs.anchor.constraint(equalTo: rhs.anchor, constant: rhs.constant - lhs.constant).priority(rhs.priority)
}

/// Create a layout constraint from an inequality comparing two axis anchors.
public func >=(lhs: YAxisAnchor, rhs: YAxisAnchor) -> NSLayoutConstraint {
    return lhs.anchor.constraint(greaterThanOrEqualTo: rhs.anchor, constant: rhs.constant - lhs.constant).priority(rhs.priority)
}

/// Add a constant to an axis anchor.
public func +(axis: YAxisAnchor, addend: CGFloat) -> YAxisAnchor {
    return axis.add(addend: addend)
}

/// Add a constant to an axis anchor.
public func +(addend: CGFloat, axis: YAxisAnchor) -> YAxisAnchor {
    return axis.add(addend: addend)
}

/// Subtract a constant from an axis anchor.
public func -(axis: YAxisAnchor, subtrahend: CGFloat) -> YAxisAnchor {
    return axis.add(addend: -subtrahend)
}
