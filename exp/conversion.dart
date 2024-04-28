void main() {
  String token = "5";
  final codes = token.codeUnits;
  for (final code in codes) {
    var unit = code.toRadixString(2);
    unit.runes.forEach((int rune) {
      var character = new String.fromCharCode(rune);
      print(character);
    });
  }
}
