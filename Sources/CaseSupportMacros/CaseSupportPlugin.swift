import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CaseSupportPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    CaseDetectionMacro.self,
    CaseConversionMacro.self,
  ]
}
