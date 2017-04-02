//
//  Array+GetterSetter.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/1.
//
//

public struct ArraySafeProxy<Element> {
    public var base: Array<Element>
    public init(_ base: Array<Element>) {
        self.base = base
    }
}
public protocol ArraySafeCompatible {
    associatedtype CompatibleType
    var safe: CompatibleType { get }
}

extension Array: ArraySafeCompatible {
    public typealias CompatibleType = ArraySafeProxy<Any>
    public var safe: CompatibleType {
        return ArraySafeProxy(self)
    }
    
}

extension ArraySafeProxy where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = self.base.index(of: object) {
            self.base.remove(at: index)
        }
    }
}
