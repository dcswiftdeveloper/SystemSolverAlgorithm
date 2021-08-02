//
//  main.swift
//  Algorithm
//
//  Created by Alessio Garzia Marotta Brusco on 01/08/2021.
//

import Foundation

let equation1 = Equation(x: 3, y: 4, n: 5)
let equation2 = Equation(x: 5, y: 7, n: 5.54)

do {
    var system = try LinearSystem(equations: (equation1, equation2, nil))
    print(system.compatibility)

    try SystemSolver.shared.solve(&system, using: .cramer)
} catch {
    print(error)
}
