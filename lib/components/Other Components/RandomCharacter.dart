import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

RandomCharacter() {

  return randomMerge(randomAlpha(4), randomNumeric(4)).substring(0,8);

}

class _Provider with AbstractRandomProvider {
  _Provider();
  double nextDouble() => 0.5;
}

passRadomCharacter(String data){
  return data;
}