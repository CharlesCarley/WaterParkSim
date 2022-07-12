import 'attribute.dart';

class XmlNode {
  final Map<String, Attribute> _attributes = {};
  final List<XmlNode> _children = [];
  XmlNode? _parent;
  final int name;

  XmlNode(this.name);

  get hasParent => _parent != null;
  get parent => _parent;

  get hasChildren => _children.isNotEmpty;
  List<XmlNode> get children => _children;

  get hasAttributes => _children.isNotEmpty;
  get attributes => _attributes;

  void addChild(XmlNode child) {
    _children.add(child);
    child._parent = this;
  }

  void addAttribute(String key, String value) {
    _attributes.putIfAbsent(
      key,
      () => Attribute(
        key: key,
        value: value,
      ),
    );
  }

  bool hasAttribute(String key) {
    return _attributes.containsKey(key);
  }

  int asInt(String key, {int def = -1}) {
    return asDouble(key, def: def.toDouble()).toInt();
  }

  double asDouble(String key, {double def = -1.0}) {
    if (_attributes.containsKey(key)) {
      Attribute? attr = _attributes[key];
      if (attr != null) {
        return attr.asDouble(def: def);
      }
    }
    return def;
  }

  String asString(String key, {String def = ""}) {
    if (_attributes.containsKey(key)) {
      Attribute? attr = _attributes[key];
      if (attr != null) {
        return attr.asString();
      }
    }
    return def;
  }

  List<double> asListDouble(String key) {
    if (_attributes.containsKey(key)) {
      Attribute? attr = _attributes[key];
      if (attr != null) {
        return attr.asListDouble();
      }
    }
    return [];
  }

  bool asBool(String key, {bool def = false}) {
    if (_attributes.containsKey(key)) {
      Attribute? attr = _attributes[key];
      if (attr != null) {
        var str = attr.asString();
        bool res = str == "yes" || str == "on" || str == "true";
        if (!res) {
          double? v = double.tryParse(str);
          if (v != null) {
            return v.toInt() != 0;
          }
        }
        return res;
      }
    }
    return def;
  }

  List<XmlNode> childrenOf(int index) {
    List<XmlNode> res = [];

    for (XmlNode child in _children) {
      if (child.name == index) {
        res.add(child);
      }
    }
    return res;
  }
}
