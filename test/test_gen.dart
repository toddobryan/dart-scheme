import "dart:math";
import "package:basic_utils/basic_utils.dart";

void main() {
  Random rng = Random();
  for (String base in ["2", "8", "10", "16"]) {
    for (int i = 1; i <= 10; i++) {
      String rand = StringUtils.generateRandomString(
        rng.nextInt(20) + 1,
        from: fromMap[base]!,
      );
      print(
        '    check(p$base.parse("$rand"))'
        '.succeeds(IntString("$rand", $base), ${rand.length});',
      );
    }
    print("\n");
  }
}

Map<String, String> fromMap = {
  "2": "01",
  "8": "0123457",
  "10": "0123456789",
  "16": "0123456789aAbBcCdDeEfF",
};
