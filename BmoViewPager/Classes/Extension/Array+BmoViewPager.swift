//
//  Array+GetterSetter.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/1.
//
//

public struct ArrayBmoVPProxy<Element> {
    public var base: Array<Element>
    public init(_ base: Array<Element>) {
        self.base = base
    }
}
public protocol ArrayBmoVPCompatible {
    associatedtype CompatibleType
    var bmoVP: CompatibleType { get }
}

extension Array: ArrayBmoVPCompatible {
    public typealias CompatibleType = ArrayBmoVPProxy<Any>
    public var bmoVP: CompatibleType {
        return ArrayBmoVPProxy(self)
    }
}

extension ArrayBmoVPProxy where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = self.base.index(of: object) {
            self.base.remove(at: index)
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
