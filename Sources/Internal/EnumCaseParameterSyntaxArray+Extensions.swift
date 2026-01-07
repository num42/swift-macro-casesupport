import SwiftSyntax

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
