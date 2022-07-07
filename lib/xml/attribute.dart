class Attribute {
  final String _key;
  final String _value;

  Attribute({
    String key = "",
    String value = "",
  })  : _key = key,
        _value = value;

  get key => _key;
  String asString() => _value;

  int asInt({int def = -1}) {
    int? v = int.tryParse(_value, radix: 10);
    if (v != null) {
      return v;
    }
    return def;
  }

  double asDouble({double def = -1.0}) {
    double? v = double.tryParse(_value);
    if (v != null) {
      return v;
    }
    return def;
  }
}
