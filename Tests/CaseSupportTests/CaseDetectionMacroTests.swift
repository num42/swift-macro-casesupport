import CaseSupportMacros
import MacroTester
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

private let testMacros: [String: Macro.Type] = [
    "CaseDetection": CaseDetectionMacro.self,
]

@Suite struct CaseDetectionMacroTests {
    @Test func caseDetection() {
        MacroTester.testMacro(macros: testMacros)
    }

    @Test func publicCaseDetection() {
        MacroTester.testMacro(macros: testMacros)
    }

    @Test func emptyEnumCaseDetection() {
        MacroTester.testMacro(macros: testMacros)
    }

    @Test func complicatedEnumCaseDetection() {
        MacroTester.testMacro(macros: testMacros)
    }
}
