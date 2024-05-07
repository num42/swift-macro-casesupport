import SwiftSyntax

extension SwiftSyntax.AttributeSyntax {
    func boolValueOfArgumentWith(name: String) -> Bool {
        guard let value = (arguments?.as(LabeledExprListSyntax.self)?.first {$0.label?.text == name}?.expression.as(BooleanLiteralExprSyntax.self)?.literal) else {
            return false
        }
        
        return value.description == TokenSyntax.keyword(SwiftSyntax.Keyword.true).description
    }
}
