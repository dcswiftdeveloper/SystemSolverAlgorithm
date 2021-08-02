//
//  Equation.swift
//  Algorithm
//
//  Created by Alessio Garzia Marotta Brusco on 01/08/2021.
//
// swiftlint:disable identifier_name

import Foundation

struct Equation {
    let x: Double
    let y: Double
    let z: Double?
    let n: Double

    init(x: Double, y: Double, z: Double? = nil, n: Double) {
        self.x = x
        self.y = y
        self.z = z
        self.n = n
    }
}
