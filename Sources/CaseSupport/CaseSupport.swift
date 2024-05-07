/// Add computed properties named `is<Case>` for each case element in the enum.
@attached(member, names: arbitrary)
public macro CaseDetection(public: Bool = false) = #externalMacro(module: "CaseSupportMacros", type: "CaseDetectionMacro")

/// Add computed properties named `as<Case>` for each case element in the enum.
@attached(member, names: arbitrary)
public macro CaseConversion(public: Bool = false) = #externalMacro(module: "CaseSupportMacros", type: "CaseConversionMacro")
