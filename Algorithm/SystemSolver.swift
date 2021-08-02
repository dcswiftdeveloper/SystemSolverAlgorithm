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
        let firstEquation = system.equations.first
        let secondEquation = system.equations.second

        guard let thirdEquation = system.equations.third,
              let firstZ = firstEquation.z,
              let secondZ = secondEquation.z,
              let thirdZ = thirdEquation.z else {
            return
        }

        let firstSecondX = firstEquation.x / secondEquation.x
        let firstThirdX = firstEquation.x / thirdEquation.x

        let newSecondY = firstEquation.y - (firstSecondX * secondEquation.y)
        let newSecondZ = firstZ - (firstSecondX * secondZ)
        let newSecondN = firstEquation.n - (firstSecondX * secondEquation.n)

        let newSecondEquation = Equation(x: newSecondY, y: newSecondZ, n: newSecondN)

        let newThirdY = firstEquation.y - (firstThirdX * thirdEquation.y)
        let newThirdZ = firstZ - (firstThirdX * thirdZ)
        let newThirdN = firstEquation.n - (firstThirdX * thirdEquation.n)

        let newThirdEquation = Equation(x: newThirdY, y: newThirdZ, n: newThirdN)

        do {
            var newSystem = try LinearSystem(equations: (newSecondEquation, newThirdEquation, nil))
            solveGradeFirst(&newSystem, using: .gauss)

            guard let newSystemSolution = newSystem.solution else { return }
            let newSystemSolutionX = newSystemSolution.x
            let newSystemSolutionY = newSystemSolution.y

            // swiftlint:disable:next line_length
            let systemSolutionX = firstEquation.n - (firstEquation.y * newSystemSolutionX) - (firstZ * newSystemSolutionY)

            let systemSolution = LinearSystem.Solution(x: systemSolutionX, y: newSystemSolutionX, z: newSystemSolutionY)
            system.solution = systemSolution
        } catch {
            print(error)
        }
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
