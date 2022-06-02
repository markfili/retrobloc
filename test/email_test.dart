import 'package:flutter_test/flutter_test.dart';

void main() {
  var emails = [
    "diriton.mariton@gmail.com",
    "d.mariton@gmail.com",
    "dmariton@gmail.com",
    "diritonmariton@gmail.com",
  ];
  var results = [
    "diriton",
    "d",
    "dmariton",
    "diritonmariton",
  ];
  test('Test name from email extraction', () {
    for (var i = 0; i < emails.length; i++) {
      expect(extractName(emails[i]), results[i]);
    }
  });
}

String extractName(String email) {
  var prefix = email.split('@');
  var prefixDivided = prefix.first.split('.');
  if (prefixDivided.isNotEmpty) {
    return prefixDivided.first;
  }
  return prefix.first;
}
