import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

private extension TokenSyntax {
  var initialUppercased: String {
    let name = text
    guard let initial = name.first else {
      return name
    }

    return "\(initial.uppercased())\(name.dropFirst())"
  }
}

public struct CaseDetectionMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let addPublicIdentifier = node.boolValueOfArgumentWith(name: "public")
      
    return declaration.memberBlock.members
      .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
      .map { $0.elements.first!.name }
      .map { ($0, $0.initialUppercased) }
      .map { original, uppercased in
        """
        \(raw: addPublicIdentifier ? "public " : "")var is\(raw: uppercased): Bool {
          return if case .\(raw: original) = self {
            true
          } else {
            false
          }
        }
        """
      }
  }
}
