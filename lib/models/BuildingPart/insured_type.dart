enum InsuredType { newValue, timeValue }

extension InsuredTypeExtension on InsuredType {
  String? get name {
    switch (this) {
      case InsuredType.newValue:
        return "New Value";
      case InsuredType.timeValue:
        return "Time Value";
      default:
        return null;
    }
  }
}
