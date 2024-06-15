//
//  KeyPaths+Extensions.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 17/04/24.
//

import Foundation

prefix func !<T>(keyPath: KeyPath<T, Bool>) -> (T) -> Bool {
    return { !$0[keyPath: keyPath] }
}

func ==<T, V: Equatable>(lhs: KeyPath<T, V>, rhs: V) -> (T) -> Bool {
    return { $0[keyPath: lhs] == rhs }
}


func !=<T, V: Equatable>(lhs: KeyPath<T, V>, rhs: V) -> (T) -> Bool {
    return { $0[keyPath: lhs] != rhs }
}
