import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

extension EnumCaseParameterSyntax {
  var typeString: String {
    let wrappedType = type.as(OptionalTypeSyntax.self)?.wrappedType
    let isOptional = wrappedType != nil

    let theType = wrappedType ?? type

    let name =
      if let simpleType = theType.as(IdentifierTypeSyntax.self) {
        simpleType.name.text
      } else if let memberType = theType.as(MemberTypeSyntax.self) {
        [memberType.baseType.as(IdentifierTypeSyntax.self)!.name.text, memberType.name.text].joined(
          separator: ".")
      } else if let arrayType = theType.as(ArrayTypeSyntax.self) {
        "[" + arrayType.element.as(IdentifierTypeSyntax.self)!.name.text + "]"
      } else {
        fatalError("Could not get name from type \(theType)")
      }

    return name + (isOptional ? "?" : "")
  }
}

public struct CaseConversionMacro: MemberMacro {
  public enum MacroDiagnostic: String, DiagnosticMessage {
    case requiresEnum = "#CaseConversion requires an enum"
    case requiresLabeledAssociatedValues = "#CaseConversion requires labeled associated values"

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
    let modifiers = declaration.modifiers
      .map { $0.description.replacingOccurrences(of: "\n", with: "") }
      .joined(separator: "")

    guard declaration.as(EnumDeclSyntax.self) != nil else {
      let diagnostic = Diagnostic(node: Syntax(attribute), message: MacroDiagnostic.requiresEnum)
      context.diagnose(diagnostic)
      throw DiagnosticsError(diagnostics: [diagnostic])
    }

    let elements = declaration.memberBlock.members
      .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
      .flatMap(\.elements)

    guard
      elements.filter(\.hasAssociatedValues).allSatisfy({ element in
        element.associatedValues.allSatisfy { $0.firstName != nil }
      })
    else {
      let diagnostic = Diagnostic(
        node: Syntax(attribute),
        message: MacroDiagnostic.requiresLabeledAssociatedValues
      )
      context.diagnose(diagnostic)
      throw DiagnosticsError(diagnostics: [diagnostic])
    }

    return
      elements
      .filter(\.hasAssociatedValues)
      .map { ($0, $0.name.initialUppercased, $0.associatedValues) }
      .map { original, uppercased, associatedValues in
        // TODO: add test for enum case with a single optional associated value. this lead to "??" types without the check below
        let tuple = associatedValues.asTypedTuple

        return """
          \(raw: modifiers)var as\(raw: uppercased): \(raw: tuple)\(raw: tuple.hasSuffix("?") ? "" : "?") {
            if case let .\(raw: original.name)(\(raw: associatedValues.asParameters)) = self {
              \(raw: associatedValues.asUntypedList)
            } else {
              nil
            }
          }
          """
      }
  }
}
