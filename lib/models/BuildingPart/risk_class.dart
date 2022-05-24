enum RiskClass { one, two, three, four, five, six }

extension RiskClassExtension on RiskClass {
  String? get name {
    switch (this) {
      case RiskClass.one:
        return "One";
      case RiskClass.two:
        return "Two";
      case RiskClass.three:
        return "Three";
      case RiskClass.four:
        return "Four";
      case RiskClass.five:
        return "Five";
      case RiskClass.six:
        return "Six";
      default:
        return null;
    }
  }
}
