import MacroTester
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(CaseSupportMacros)
    import CaseSupportMacros

    final class CaseDetectionMacroDiagnosticsTests: XCTestCase {
        let testMacros: [String: Macro.Type] = [
            "CaseDetection": CaseDetectionMacro.self,
        ]

        func testStructThrowsError() throws {
            assertMacroExpansion(
                """
                @CaseDetection
                struct AStruct {}
                """,
                expandedSource: """
                struct AStruct {}
                """,
                diagnostics: [
                    .init(
                        message: CaseDetectionMacro.MacroError.requiresEnum.description,
                        line: 1,
                        column: 1
                    ),
                ],
                macros: testMacros
            )
        }
    }
#endif
