//
//  SystemSolver.swift
//  Algorithm
//
//  Created by Alessio Garzia Marotta Brusco on 01/08/2021.
//
// swiftlint:disable identifier_name
import Foundation

class SystemSolver {
    static let shared = SystemSolver()
    var latestSystem: LinearSystem?

    private init() { }

    func solve(_ system: inout LinearSystem, using method: SolutionMethod) throws {
        // Solves the linear system iff it is compatible
        guard system.compatibility == .compatible else { throw SolutionError.systemNotCompatible }
        latestSystem = system

        switch system.grade {
        case .first:
            solveGradeFirst(&system, using: method)
        case .second:
            solveGradeSecond(&system, using: method)
        }
    }

    // MARK: Solve grade first systems
    private func solveGradeFirst(_ system: inout LinearSystem, using method: SolutionMethod) {
        if system.equations.first.x == 0 {
            solveGradeFirstGeneric(&system)
        } else {
            switch method {
            case .gauss:
                solveGradeFirstUsingGauss(&system)
            case .cramer:
                solveGradeFirstUsingCramer(&system)
            }
        }
    }

    private func solveGradeFirstUsingGauss(_ system: inout LinearSystem) {
        let firstEquation = system.equations.first
        let secondEquation = system.equations.second

        let firstSecondX = firstEquation.x / secondEquation.x

//        let newSecondX = firstEquation.x - (secondEquation.x / firstSecondX)
        let newSecondY = firstEquation.y - (secondEquation.y * firstSecondX)
        let newSecondN = firstEquation.n - (secondEquation.n * firstSecondX)

        let solutionY = newSecondN / newSecondY
        let solutionX = (firstEquation.n - firstEquation.y * solutionY) / firstEquation.x

        let solution = LinearSystem.Solution(x: solutionX, y: solutionY)
        system.solution = solution
    }

    private func solveGradeFirstUsingCramer(_ system: inout LinearSystem) {
        let firstEquation = system.equations.first
        let secondEquation = system.equations.second

        let d = (firstEquation.x * secondEquation.y) - (secondEquation.x * firstEquation.y)
        let dX = (firstEquation.n * secondEquation.y) - (secondEquation.n * firstEquation.y)
        let dY = (firstEquation.x * secondEquation.n) - (secondEquation.x * firstEquation.n)

        let solutionX = dX / d
        let solutionY = dY / d

        let solution = LinearSystem.Solution(x: solutionX, y: solutionY)
        system.solution = solution
    }

    private func solveGradeFirstGeneric(_ system: inout LinearSystem) {
        let firstEquation = system.equations.first
        let secondEquation = system.equations.second

        let calculation = secondEquation.y * firstEquation.n
        let solutionX = (secondEquation.n - ( calculation / firstEquation.y)) / secondEquation.x
        let solutionY = firstEquation.n / firstEquation.y

        let solution = LinearSystem.Solution(x: solutionX, y: solutionY)
        system.solution = solution
    }

    // MARK: Solve grade second systems
    private func solveGradeSecond(_ system: inout LinearSystem, using method: SolutionMethod) {
        switch method {
        case .gauss:
            solveGradeSecondUsingGauss(&system)
        case .cramer:
            solveGradeSecondUsingCramer(&system)
        }
    }

    private func solveGradeSecondUsingGauss(_ system: inout LinearSystem) {

    }

    private func solveGradeSecondUsingCramer(_ system: inout LinearSystem) {

    }

    enum SolutionMethod {
        case gauss, cramer
    }

    enum SolutionError: Error {
        case systemNotCompatible
    }
}
