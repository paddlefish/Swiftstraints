//
//  LayoutPriority.swift
//  Swiftstraints
//
//  Created by Bradley Hilton on 6/15/16.
//  Copyright © 2016 Skyvive. All rights reserved.
//

public enum LayoutPriority {
    
    case required
    case high
    case low
    case fittingSizeLevel
    case other(UILayoutPriority)
    
    var priority: UILayoutPriority {
        switch self {
        case .required: return UILayoutPriorityRequired
        case .high: return UILayoutPriorityDefaultHigh
        case .low: return UILayoutPriorityDefaultLow
        case .fittingSizeLevel: return UILayoutPriorityFittingSizeLevel
        case .other(let priority): return priority
        }
    }
    
}

public func |(lhs: XAxisAnchor, rhs: LayoutPriority) -> XAxisAnchor {
    return CompoundXAxis(anchor: lhs.anchor, constant: lhs.constant, priority: rhs)
}

public func |(lhs: YAxisAnchor, rhs: LayoutPriority) -> YAxisAnchor {
    return CompoundYAxis(anchor: lhs.anchor, constant: lhs.constant, priority: rhs)
}

public func |(dimension: DimensionAnchor, priority: LayoutPriority) -> DimensionAnchor {
    return CompoundDimension(dimension: dimension.dimension, multiplier: dimension.multiplier, constant: dimension.constant, priority: priority)
}

public struct PrioritizedConstant {
    let constant: CGFloat
    let priority: LayoutPriority
}

public func |(constant: CGFloat, priority: LayoutPriority) -> PrioritizedConstant {
    return PrioritizedConstant(constant: constant, priority: priority)
}
