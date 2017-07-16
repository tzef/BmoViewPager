//
//  Array+GetterSetter.swift
//  Pods
//
//  Created by LEE ZHE YU on 2017/4/1.
//
//

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
