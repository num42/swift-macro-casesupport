# CaseSupport

Adds `is<Case>` and `as<Case>` helpers for enum cases.

## Usage

```swift
@CaseDetection
enum TestEnum {
  case firstCase
  case secondCase
}
```

Generated:

```swift
enum TestEnum {
  case firstCase
  case secondCase

    var isFirstCase: Bool {
      if case .firstCase = self {
        true
      } else {
        false
      }
    }

    var isSecondCase: Bool {
      if case .secondCase = self {
        true
      } else {
        false
      }
    }
}
```

```swift
@CaseConversion
enum TestEnum {
  case firstCase
  case secondCase(string: String, bool: Bool)
  case thirdCase(argument: String)
  case fourthCase(subtypeArgument: SubType.String)
}
```

Generated:

```swift
enum TestEnum {
  case firstCase
  case secondCase(string: String, bool: Bool)
  case thirdCase(argument: String)
  case fourthCase(subtypeArgument: SubType.String)

    var asSecondCase: (string: String, bool: Bool)? {
      if case let .secondCase(string, bool) = self {
        (string, bool)
      } else {
        nil
      }
    }

    var asThirdCase: String? {
      if case let .thirdCase(argument) = self {
        argument
      } else {
        nil
      }
    }

    var asFourthCase: SubType.String? {
      if case let .fourthCase(subtypeArgument) = self {
        subtypeArgument
      } else {
        nil
      }
    }
}
```

## Notes

Apply to enums only.
