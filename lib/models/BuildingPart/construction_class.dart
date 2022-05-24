enum ConstructionClass { solidConstruction, mixedConstruction }

extension ConstructionClassExtension on ConstructionClass {
  String? get name {
    switch (this) {
      case ConstructionClass.solidConstruction:
        return "Solid Construction";
      case ConstructionClass.mixedConstruction:
        return "Mixed Construction";
      default:
        return null;
    }
  }
}
