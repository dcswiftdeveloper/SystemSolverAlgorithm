//
//  main.swift
//  Algorithm
//
//  Created by Alessio Garzia Marotta Brusco on 01/08/2021.
//

import Foundation

let equation1 = Equation(x: 3, y: 4, z: 54, n: 5)
let equation2 = Equation(x: 5, y: 7, z: 33, n: 5.54)
let equation3 = Equation(x: 51, y: 0, z: 12, n: 6.2)

do {
    var system = try LinearSystem(equations: (equation1, equation2, equation3))
    print(system.compatibility)

    try SystemSolver.shared.solve(&system, using: .gauss)
    print(system.solution)
} catch {
    print(error)
}
