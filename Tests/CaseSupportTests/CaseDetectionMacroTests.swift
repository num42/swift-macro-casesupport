import CaseSupportMacros
import MacroTester
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

private let testMacros: [String: Macro.Type] = [
    "CaseDetection": CaseDetectionMacro.self,
]

final class CaseDetectionMacroTests: XCTestCase {
    func testCaseDetection() {
        testMacro(macros: testMacros)
    }

    func testPublicCaseDetection() {
        testMacro(macros: testMacros)
    }

    func testEmptyEnumCaseDetection() {
        testMacro(macros: testMacros)
    }

    func testComplicatedEnumCaseDetection() {
        testMacro(macros: testMacros)
    }
}
