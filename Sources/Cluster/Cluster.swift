//
//  Selection.swift
//  secret-project
//
//  Created by Ilias Nikolaidis Olsson on 2022-10-27.
//

import Foundation

open class Cluster<Element> {
    
    public var primary: Element
    public var secondaries: [Element]
    
    public init(primary: Element, secondaries: [Element]) {
        self.primary = primary
        self.secondaries = secondaries
    }
    
    public init(_ primary: Element) {
        self.primary = primary
        self.secondaries = []
    }
    
    public init(_ selection: Cluster<Element>) {
        self.primary = selection.primary
        self.secondaries = selection.secondaries
    }
    
    public convenience init?(array: [Element]) {
        var mutableArray = array
        if let first = mutableArray.first {
            mutableArray.removeFirst()
            self.init(primary: first, secondaries: mutableArray)
            return
        }
        return nil
    }
}
