String filterNumber(int number) {
  List<String> reversed = number.toString().split('').reversed.toList();
  String res = "";
  for (var i = 0; i < reversed.length; i++) {
    if ((i % 3 == 0) && (i != reversed.length)) {
      res = res + ",";
    }
    res = res + reversed[i];
  }
  res = res.substring(1, res.length);
  return res.split('').reversed.toList().join();
}
