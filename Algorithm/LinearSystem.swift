//
//  LinearSystem.swift
//  Algorithm
//
//  Created by Alessio Garzia Marotta Brusco on 01/08/2021.
//
// swiftlint:disable large_tuple
// swiftlint:disable function_body_length
// swiftlint:disable identifier_name

import Foundation

struct LinearSystem {
    let equations: (first: Equation, second: Equation, third: Equation?)
    let compatibility: Compatibility
    let grade: Grade
    var solution: Solution?

    init(equations: (first: Equation, second: Equation, third: Equation?)) throws {
        // Checks if the equations have the right format
        if equations.third == nil {
            guard equations.first.z == nil,
                  equations.second.z == nil else {
                throw SystemError.badEquations
            }

            self.equations = equations
            self.grade = .first

        } else if let thirdEquation = equations.third {
            guard equations.first.z != nil,
                  equations.second.z != nil,
                  thirdEquation.z != nil else {
                throw SystemError.badEquations
            }

            self.equations = equations
            self.grade = .second

        } else {
            fatalError("Failed to initialize a linear system")
        }

        let firstEquation = equations.first
        let secondEquation = equations.second

        // Checks that there are three equations
        if let thirdEquation = equations.third,
           let firstZ = equations.first.z,
           let secondZ = equations.second.z,
           let thirdZ = thirdEquation.z {
            let d: Double = {
                let first = (firstEquation.x * secondEquation.y * thirdZ)
                let second = (firstEquation.y * secondZ * thirdEquation.x)
                let third = (firstZ * secondEquation.x * thirdEquation.x)
                let fourth = (firstZ * secondEquation.x * thirdEquation.x)
                let fifth = (firstEquation.x * secondEquation.x * thirdZ)
                let sixth = (firstEquation.x * secondZ * thirdEquation.x)

                return first + second + third - fourth - fifth - sixth
            }()

            let dX: Double = {
                let first = (firstEquation.n * secondEquation.x * thirdZ)
                let second = (firstEquation.x * secondZ * thirdEquation.n)
                let third = (firstZ * secondEquation.n * thirdEquation.x)
                let fourth = (firstZ * secondEquation.x * thirdEquation.n)
                let fifth = (firstEquation.x * secondEquation.n * thirdZ)
                let sixth = (firstEquation.n * secondZ * thirdEquation.x)

                return first + second + third - fourth - fifth - sixth
            }()

            let dY: Double = {
                let first = (firstEquation.x * secondEquation.n * thirdZ)
                let second = (firstEquation.n * secondZ * thirdEquation.x)
                let third = (firstZ * secondEquation.x * thirdEquation.n)
                let fourth = (firstZ * secondEquation.n * thirdEquation.x)
                let fifth = (firstEquation.n * secondEquation.x * thirdZ)
                let sixth = (firstEquation.x * secondZ * thirdEquation.n)

                return first + second + third - fourth - fifth - sixth
            }()

            let dZ: Double = {
                let first = (firstEquation.x * secondEquation.x * thirdEquation.n)
                let second = (firstEquation.x * secondEquation.n * thirdEquation.x)
                let third = (firstEquation.n * secondEquation.x * thirdEquation.x)
                let fourth = (firstEquation.n * secondEquation.x * thirdEquation.x)
                let fifth = (firstEquation.x * secondEquation.x * thirdEquation.n)
                let sixth = (firstEquation.x * secondEquation.n * thirdEquation.x)

                return first + second + third - fourth - fifth - sixth
            }()

            if d != 0 {
                compatibility = .compatible
            } else if dY == 0 && dX == 0 && dZ == 0 {
                compatibility = .undetermined
            } else {
                compatibility = .incompatible
            }

        } else {
            if (firstEquation.x == 0 && secondEquation.x == 0)
                || (firstEquation.y == 0 && secondEquation.y == 0)
                || (firstEquation.x == 0 && firstEquation.y == 0)
                || (secondEquation.x == 0 && secondEquation.y == 0) {
                compatibility = .notALinearSystem
            } else if ((firstEquation.x / secondEquation.x) != (firstEquation.y / secondEquation.y))
                        || (firstEquation.y == 0
                        || secondEquation.y == 0
                        || firstEquation.x == 0
                        || secondEquation.x == 0) {
                compatibility = .compatible
            } else if (firstEquation.x / secondEquation.x) == (firstEquation.n / secondEquation.n) {
                compatibility = .undetermined
            } else {
                compatibility = .incompatible
            }
        }
    }

    struct Solution {
        let x: Double
        let y: Double
        let z: Double?

        init(x: Double, y: Double, z: Double? = nil) {
            self.x = x
            self.y = y
            self.z = z
        }
    }

    enum Grade {
        case first, second
    }

    enum Compatibility {
        case compatible, incompatible, undetermined, notALinearSystem
    }

    enum SystemError: Error {
        case badEquations
    }
}
