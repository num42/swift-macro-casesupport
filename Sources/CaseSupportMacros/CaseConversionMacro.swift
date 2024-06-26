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

private extension EnumCaseElementSyntax {
    var hasAssociatedValues: Bool {
        !associatedValues.isEmpty
    }

    var associatedValues: [EnumCaseParameterSyntax] {
        guard let parameterList = parameterClause?.parameters else {
            return []
        }

        return parameterList.compactMap { $0 }
    }
}

extension EnumCaseParameterSyntax {
    var typeString: String {
        let wrappedType = type.as(OptionalTypeSyntax.self)?.wrappedType
        let isOptional = wrappedType != nil

        let theType = wrappedType ?? type

        let name = if let simpleType = theType.as(IdentifierTypeSyntax.self) {
            simpleType.name.text
        } else if let memberType = theType.as(MemberTypeSyntax.self) {
            [memberType.baseType.as(IdentifierTypeSyntax.self)!.name.text, memberType.name.text].joined(separator: ".")
        } else if let arrayType = theType.as(ArrayTypeSyntax.self) {
            "[" + arrayType.element.as(IdentifierTypeSyntax.self)!.name.text + "]"
        } else {
            fatalError("Could not get name from type \(theType)")
        }

        return name + (isOptional ? "?" : "")
    }
}

extension [EnumCaseParameterSyntax] {
    var asTypedTuple: String {
        if count > 1 {
            """
            (\(compactMap { "\($0.firstName!.text): \($0.typeString)" }.joined(separator: ", ")))
            """
        } else {
            """
            \(self[0].typeString)
            """
        }
    }

    var asParameters: String {
        if count > 1 {
            """
            \(compactMap { "\($0.firstName!.text)" }.joined(separator: ", "))
            """
        } else {
            """
            \(
                self[0].firstName?.text
                    ?? self[0].typeString.prefix(1).lowercased() + self[0].typeString.dropFirst()
            )
            """
        }
    }

    var asUntypedList: String {
        if count > 1 {
            """
            (\(compactMap { "\($0.firstName!.text)" }.joined(separator: ", ")))
            """
        } else {
            """
            \(
                self[0].firstName?.text
                    ?? self[0].typeString.prefix(1).lowercased() + self[0].typeString.dropFirst()
            )
            """
        }
    }
}

public struct CaseConversionMacro: MemberMacro {
    public enum MacroError: Error, CustomStringConvertible {
        case requiresEnum

        public var description: String {
            switch self {
            case .requiresEnum:
                "#CaseConversion requires an enum"
            }
        }
    }

    public static func expansion(
        of _: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in _: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let modifiers = declaration.modifiers
            .map { $0.description.replacingOccurrences(of: "\n", with: "") }
            .joined(separator: "")

        guard declaration.as(EnumDeclSyntax.self) != nil else {
            throw MacroError.requiresEnum
        }

        let elements = declaration.memberBlock.members
            .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
            .flatMap(\.elements)

        return elements
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
