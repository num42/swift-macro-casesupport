import CaseSupportMacros
import MacroTester
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

private let testMacros: [String: Macro.Type] = [
    "CaseConversion": CaseConversionMacro.self,
]

@Suite struct CaseConversionMacroTests {
    @Test func caseConversion() {
        MacroTester.testMacro(macros: testMacros)
    }

    @Test func publicCaseConversion() {
        MacroTester.testMacro(macros: testMacros)
    }

    @Test func subtypeCaseConversion() {
        MacroTester.testMacro(macros: testMacros)
    }

    @Test func arrayCaseConversion() {
        MacroTester.testMacro(macros: testMacros)
    }

    @Test func emptyEnumCaseConversion() {
        MacroTester.testMacro(macros: testMacros)
    }

    @Test func complicatedEnumCaseConversion() {
        MacroTester.testMacro(macros: testMacros)
    }
}
