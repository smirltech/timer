Map<String, int> intToTimeLeft(int value) {
  int d, h, m, s;

  d = value ~/ 86400;
  h = ((value - d * 86400)) ~/ 3600;
  m = ((value - d * 86400 - h * 3600)) ~/ 60;
  s = ((value - d * 86400 - h * 3600)) - (m * 60);

  var result = {
    'd': d,
    'h': h,
    'm': m,
    's': s,
  };

  return result;
}
