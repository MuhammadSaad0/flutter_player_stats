String getFirstName(input) {
  input = divide(input.toString().split('/dd')[0]);
  return input.toString().substring(0, input.toString().length - 1);
}

String getLastName(input) {
  input = divide(input.toString().split('/dd')[1]);
  return input.toString().substring(0, input.toString().length - 1);
}

String getNationality(input) {
  input = divide(input.toString().split('/dd')[2]);
  return input.toString().substring(0, input.toString().length - 1);
}

String getDoB(input) {
  input = divide(input.toString().split('/dd')[3]);
  return input.toString().substring(0, input.toString().length - 1);
}

String getAge(input) {
  input = divide(input.toString().split('/dd')[4]);
  return input.toString().substring(0, input.toString().length - 1);
}

String getCoB(input) {
  input = divide(input.toString().split('/dd')[5]);
  return input.toString().substring(0, input.toString().length - 1);
}

String getPoB(input) {
  input = divide(input.toString().split('/dd')[6]);
  return input.toString().substring(0, input.toString().length - 1);
}

String getPosition(input) {
  input = divide(input.toString().split('/dd')[7]);
  return input.toString().substring(0, input.toString().length - 1);
}

String getHeight(input) {
  input = divide(input.toString().split('/dd')[8]);
  return input.toString().substring(0, input.toString().length - 1);
}

String divide(input) {
  String start = '">';
  final startIndex = input.toString().indexOf(start);
  return input.toString().substring(startIndex + start.length);
}
