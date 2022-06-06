enum RiskClass { one, two, three, four, five, six }

extension RiskClassExtension on RiskClass {
  String? get name {
    switch (this) {
      case RiskClass.one:
        return "1";
      case RiskClass.two:
        return "2";
      case RiskClass.three:
        return "3";
      case RiskClass.four:
        return "4";
      case RiskClass.five:
        return "5";
      case RiskClass.six:
        return "6";
      default:
        return null;
    }
  }
}
