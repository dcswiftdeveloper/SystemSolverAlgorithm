//
//  Equation.swift
//  Algorithm
//
//  Created by Alessio Garzia Marotta Brusco on 01/08/2021.
//
// swiftlint:disable identifier_name

import Foundation

struct Equation {
    var x: Double
    var y: Double
    var z: Double?
    var n: Double

    init(x: Double, y: Double, z: Double? = nil, n: Double) {
        self.x = x
        self.y = y
        self.z = z
        self.n = n
    }
}
