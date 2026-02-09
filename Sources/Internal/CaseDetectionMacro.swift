import Foundation
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct CaseDetectionMacro: MemberMacro {
  public enum MacroDiagnostic: String, DiagnosticMessage {
    case requiresEnum = "#CaseDetection requires an enum"

    public var message: String { rawValue }

    public var diagnosticID: MessageID {
      MessageID(domain: "CaseSupport", id: rawValue)
    }

    public var severity: DiagnosticSeverity { .error }
  }

  public static func expansion(
    of attribute: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard declaration.as(EnumDeclSyntax.self) != nil else {
      let diagnostic = Diagnostic(node: Syntax(attribute), message: MacroDiagnostic.requiresEnum)
      context.diagnose(diagnostic)
      throw DiagnosticsError(diagnostics: [diagnostic])
    }

    let modifiers = declaration.modifiers
      .map { $0.description.replacingOccurrences(of: "\n", with: "") }
      .joined(separator: "")

    return declaration.memberBlock.members
      .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
      .map { $0.elements.first!.name }
      .map { ($0, $0.initialUppercased) }
      .map { original, uppercased in
        """
        \(raw: modifiers)var is\(raw: uppercased): Bool {
          if case .\(raw: original) = self {
            true
          } else {
            false
          }
        }
        """
      }
  }
}
