import SwiftSyntax

extension EnumCaseElementSyntax {
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
