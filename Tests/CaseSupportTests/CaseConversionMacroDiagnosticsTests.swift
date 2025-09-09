import MacroTester
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

#if canImport(CaseSupportMacros)
    import CaseSupportMacros

    @Suite struct CaseConversionMacroDiagnosticsTests {
        let testMacros: [String: Macro.Type] = [
            "CaseConversion": CaseConversionMacro.self,
        ]

        @Test func structThrowsError() throws {
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
