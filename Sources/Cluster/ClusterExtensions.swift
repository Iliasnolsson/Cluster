//
//  File.swift
//  
//
//  Created by Ilias Nikolaidis Olsson on 2023-03-11.
//

import Foundation

// MARK: Helpers
public extension Cluster {
    
    func array() -> [Element] {
        return [primary] + secondaries
    }
    
    func flatArray<InnerElement>() -> [InnerElement] where Element == Array<InnerElement> {
        return ([primary] + secondaries).flatMap({$0})
    }
    
    func codable() -> CodableCluster<Element> where Element: Codable {
        return .init(primary: primary, secondaries: secondaries)
    }
    
}

public extension Array {
    
    func selection() -> Cluster<Element>? {
        return .init(array: self)
    }
    
}

// MARK: Equatable
extension Cluster: Equatable where Element: Equatable {
    
    public static func == (lhs: Cluster<Element>, rhs: Cluster<Element>) -> Bool  {
        if lhs.primary == rhs.primary && lhs.secondaries.count == rhs.secondaries.count {
            return !zip(lhs.secondaries, rhs.secondaries).contains(where: {!($0 == $1)})
        }
        return false
    }
    
}

// MARK: Map
public extension Cluster {
    
    func map<OtherElement, ElementOfResult>(with otherSelection: Cluster<OtherElement>, _ expression: (Element, OtherElement) throws -> ElementOfResult) rethrows -> Cluster<ElementOfResult> {
        let newPrimary = try expression(primary, otherSelection.primary)
        var newSecondaries = [ElementOfResult]()
        for index in secondaries.indices {
            let secondary = secondaries[index]
            let otherSecondary = otherSelection.secondaries[index]
            newSecondaries.append(try expression(secondary, otherSecondary))
        }
        return .init(primary: newPrimary, secondaries: newSecondaries)
    }
    
    func map<ElementOfResult>(_ expression: ((Element) throws -> ElementOfResult)) rethrows -> Cluster<ElementOfResult> {
        return .init(primary: try expression(primary),
                     secondaries: try secondaries.map(expression))
    }
    
    /// Returns a new cluster whose elements are the non-nil results of
    /// calling the given transformation with each element of this cluster.
    ///
    /// Will return a nil cluster if the "primary" of the cluster is nil after passing it through the expression
    ///
    /// - Parameter expression: A closure that takes an element of the cluster
    ///   as its argument and returns an optional value.
    /// - Returns: A cluster of the non-nil results of calling the given
    ///   transformation with each element of this cluster.
    /// - Throws: An error propagated from the transformation closure.
    func compactMap<ElementOfResult>(_ expression: ((Element) throws -> ElementOfResult?)) rethrows -> Cluster<ElementOfResult>? {
        if let primaryMapped = try expression(primary) {
            let secondariesMapped = try secondaries.compactMap(expression)
            return .init(primary: primaryMapped,
                         secondaries: secondariesMapped)
        }
        return nil
    }

    
}

// MARK: ForEach
public extension Cluster {
    
    func forEach<OtherElement>(with otherSelection: Cluster<OtherElement>, _ expression: (Element, OtherElement) throws -> Void) rethrows {
        try expression(primary, otherSelection.primary)
        for index in secondaries.indices {
            let secondary = secondaries[index]
            let otherSecondary = otherSelection.secondaries[index]
            try expression(secondary, otherSecondary)
        }
    }
    
    func forEach(_ expression: (Element) throws -> Void) rethrows {
        try expression(primary)
        try secondaries.forEach(expression)
    }
    
}

// MARK: All Satisfy
public extension Cluster {
    
    func allSatisfy(_ predicate: (Element) throws -> Bool) rethrows -> Bool {
        return try (predicate(primary) && secondaries.allSatisfy(predicate))
    }
    
    func allEqualsSameValue<T: Equatable>(_ getValue: ((_ element: Element) -> T)) -> Bool {
        let primaryValue = getValue(primary)
        return secondaries.allSatisfy({getValue($0) == primaryValue})
    }
    
}

// MARK: Max/Min
public extension Cluster {
    
    func min(by expression: (Element, Element) throws -> Bool) rethrows -> Element {
        if let minSecondary = try secondaries.min(by: expression) {
            return try expression(primary, minSecondary) ? primary : minSecondary
        }
        return primary
    }
    
    func max(by expression: (Element, Element) throws -> Bool) rethrows -> Element {
        if let maxSecondary = try secondaries.max(by: expression) {
            return try expression(primary, maxSecondary) ? maxSecondary : primary
        }
        return primary
    }
    
}
