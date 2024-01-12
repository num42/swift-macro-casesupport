/// Add computed properties named `is<Case>` for each case element in the enum.
@attached(member, names: arbitrary)
public macro CaseDetection() = #externalMacro(module: "CaseSupportMacros", type: "CaseDetectionMacro")

/// Add computed properties named `as<Case>` for each case element in the enum.
@attached(member, names: arbitrary)
public macro CaseConversion() = #externalMacro(module: "CaseSupportMacros", type: "CaseConversionMacro")
