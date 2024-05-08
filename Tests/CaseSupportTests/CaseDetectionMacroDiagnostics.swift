import MacroTester
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(CaseSupportMacros)
    import CaseSupportMacros

    final class CaseConversionMacroDiagnosticsTests: XCTestCase {
        let testMacros: [String: Macro.Type] = [
            "CaseConversion": CaseConversionMacro.self,
        ]

        func testStructThrowsError() throws {
            assertMacroExpansion(
                """
                @CaseConversion
                struct AStruct {}
                """,
                expandedSource: """
                struct AStruct {}
                """,
                diagnostics: [
                    .init(
                        message: CaseConversionMacro.MacroError.requiresEnum.description,
                        line: 1,
                        column: 1
                    ),
                ],
                macros: testMacros
            )
        }
    }
#endif
