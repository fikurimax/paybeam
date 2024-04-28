void main() {
	Future.delayed(const Duration(milliseconds: 200)).then((_) async {
      var token = "1";
      var index = -1;

      while (index < token.length) {
        // Start every token with 0x55, as this gives the other side a way to calibrate the timings.
        var c = index < 0 ? 0x55 : token.codeUnitAt(index);
        index++;
        for (int i = 0; i < 8; i++) {
          // Turn torch off.
          print("0");
          await Future.delayed(const Duration(milliseconds: 1));
          // Turn torch on.
          print("1");
          await Future.delayed(Duration(milliseconds: 1 * ((c & 1) + 1)));
          c >>= 1;
        }
        print(c);
      }
    });
}
