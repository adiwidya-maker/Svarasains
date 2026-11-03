// This is a basic Flutter widget test for SvaraSains.

import 'package:flutter_test/flutter_test.dart';
import 'package:uts_2415051001_i_gede_adiwidya_utama_5iki_pti_svarasains/main.dart';

void main() {
  testWidgets('SvaraSains app sanity test', (WidgetTester tester) async {
    // Build app SvaraSains
    await tester.pumpWidget(const SvaraSainsApp());
  });
}