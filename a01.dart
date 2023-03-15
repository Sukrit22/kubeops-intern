import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  // . = 'any' single character
  // * = zero or more 'preceding' element
  print("input your string to be checked");
  String string = stdin.readLineSync() ?? "";
  print("input your pattern 'A-z' including . and * ");
  String pattern = stdin.readLineSync() ?? "";

  //rule out all case
  /**
   * same as pattern  ex s=A      p=A, s=AAabB p=AAabB
   * empty string     ex s=       p=   ?  p=* ? | p=. ?
   * out of scope pattern ex s="'$%#@)_ say they are of scope (not in A-z . *)
   * 
   * A-z exact pattern
   * .   match to 1 A-z
   * *   match to what come before, in this case, none??
   * .*  match to atleast 1 A-z then check each until end
   * .** well.. how should we interpret this, match to at least 1 A-z then the last character until stop ex 'ascascasc"ccccc"' inside "" is where * take effect
   * *.* == .*
   * **.* == .*
   * .*** == .**
   * ***.*** == .**
   * A** == A*
   * A.
   * A..
   * .*. == .*
   * .*.. == .*
   * .**.
   * .**..
   * 
   */

  // or maybe write in NFA???
  /**
   * start -> 
   * 
   * 
   * 
   */

  /**
   * maybe we need recursive pattern for each possibility that can be occured
   */

  bool patternChecker(Pattern currentPattern) {
    //return true if match all the way
    if (!currentPattern.checkCurrentPattern()) {
      return false; //
    }
    //current is match, go on, to check if the current still apply to next char or next pattern

    return patternChecker(
          currentPattern.stayCurrent(),
        ) ||
        patternChecker(
          currentPattern.moveNext(),
        );
    //idea : if not fixed character like A-z, like . and *
    //if match pattern, check if current pattern apply to next string or go next pattern and next string also.
  }

  if (string.length < 1 ||
      string.length > 20 ||
      pattern.length < 1 ||
      pattern.length > 20) {
    print(
        'your input is either empty or exceed the maximum input length, which is 20 for string and 30 for pattern.');
    return;
  }

  bool startWithAsterisk = true;
  bool asterisked = false;
  bool twiceAsterisk = false;
  String cleanPattern = "";
  //clean the pattern
  for (int codeUnit in pattern.codeUnits) {
    String currentPattern = codeUnit.toString();
    if (currentPattern != "*" && startWithAsterisk) {
      startWithAsterisk = false;
      continue;
    }
    if (twiceAsterisk && currentPattern == "*") {
      continue;
    }
    if (currentPattern != "*") {
      twiceAsterisk = false;
    }
    if (currentPattern == "*") {
      asterisked = true;
      if (startWithAsterisk) {
        continue;
      }
    }
    cleanPattern = cleanPattern + currentPattern;
  }

  Pattern myPattern = Pattern(pattern, string);
  if (patternChecker(myPattern)) {
    print("congrat la, your string and pattern match");
  } else {
    print("well.. it's not match. What can I do.");
  }
}

class Pattern {
  Pattern(this.pattern, this.string) {
    patternPos = 0;
    stringPos = 0;
  }

  String pattern;
  late int patternPos;

  String string;
  late int stringPos;

  Pattern copyWith({
    String? pattern,
    int? patternPos,
    String? string,
    int? stringPos,
  }) {
    return Pattern(pattern ?? this.pattern, string ?? this.string)
      ..patternPos = patternPos ?? this.patternPos
      ..stringPos = stringPos ?? this.stringPos;
  }

  Pattern stayCurrent() {
    return copyWith(stringPos: stringPos + 1);
  }

  Pattern moveNext() {
    return copyWith(patternPos: patternPos + 1, stringPos: stringPos + 1);
  }

  bool checkCurrentPattern() {
    String currentChar = string[stringPos];
    String currentPatt = pattern[patternPos];

    if (currentChar.codeUnits[0] < 32 || currentChar.codeUnits[0] == 127) {
      print('detect false string');
      return false;
    }

    //not match return false la
    if (currentPatt == ".") {
      // is . match any single character
      if (currentChar.codeUnits[0] < 32 && currentChar.codeUnits[0] >= 127) {
        return false;
      }
    } else if (currentPatt == "*") {
      // is *
      String prevPattern = getPrevPattern();

      if (prevPattern == ".") {
        //match any
      }
    } else if (currentPatt.codeUnits[0] < 32 ||
        currentPatt.codeUnits[0] == 127) {
      // is unprintable
      return false;
    } else {
      // is normal 32-126 ascii and not . or *
      if (currentChar.codeUnits[0] != currentPatt.codeUnits[0]) {
        return false;
      }
    }

    //well it match all the way
    return true;
  }

  String getPrevPattern() {
    if (patternPos > 0) {
      return string[patternPos - 1];
    }
    return "";
  }
}
