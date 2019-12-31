class DrawerMenu {
  const DrawerMenu(this.label, [this.parent, this.value]);

  final String label;
  final DrawerMenu parent;
  final dynamic value;

  static const DrawerMenu info = DrawerMenu('Info');
  static const DrawerMenu serverInfo = DrawerMenu('Server Info', info);

  static const DrawerMenu browser = DrawerMenu('Browser');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawerMenu &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          parent == other.parent;

  @override
  int get hashCode => label.hashCode ^ parent.hashCode;
}
