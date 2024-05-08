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
    public enum MacroError: Error, CustomStringConvertible {
        case requiresEnum

        public var description: String {
            switch self {
            case .requiresEnum:
                "#CaseDetection requires an enum"
            }
        }
    }
    
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
      guard declaration.as(EnumDeclSyntax.self) != nil else {
          throw MacroError.requiresEnum
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
