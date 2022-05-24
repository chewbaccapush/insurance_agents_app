enum FireProtection { none, bma, spa, bmaSpa }

extension FireProtectionExtension on FireProtection {
  String? get name {
    switch (this) {
      case FireProtection.none:
        return "None";
      case FireProtection.bma:
        return "BMA";
      case FireProtection.spa:
        return "SPA";
      case FireProtection.bmaSpa:
        return "BMA-SPA";
      default:
        return null;
    }
  }
}
