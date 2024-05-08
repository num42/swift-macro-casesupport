import CaseSupportMacros
import MacroTester
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

private let testMacros: [String: Macro.Type] = [
    "CaseConversion": CaseConversionMacro.self,
]

final class CaseConversionMacroTests: XCTestCase {
    func testCaseConversion() {
        testMacro(macros: testMacros)
    }

    func testPublicCaseConversion() {
        testMacro(macros: testMacros)
    }

    func testSubtypeCaseConversion() {
        testMacro(macros: testMacros)
    }

    func testArrayCaseConversion() {
        testMacro(macros: testMacros)
    }

    func testEmptyEnumCaseConversion() {
        testMacro(macros: testMacros)
    }
}
