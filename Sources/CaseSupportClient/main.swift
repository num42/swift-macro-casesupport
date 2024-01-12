import CaseSupport

@CaseDetection
enum TestEnum {
  case firstCase
  case secondCase
}

assert(TestEnum.firstCase.isFirstCase)
assert(!TestEnum.secondCase.isFirstCase)

@CaseConversion
enum TestEnumWithValues {
  case firstCase
  case secondCase(stringValue: String, boolValue: Bool)
}

assert(
  !TestEnumWithValues.secondCase(
    stringValue: "Hello",
    boolValue: false
  )
  .asSecondCase!.boolValue
)
