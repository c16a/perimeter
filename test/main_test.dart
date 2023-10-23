import 'package:flutter_test/flutter_test.dart';
import 'package:perimeter/main.dart';

void main() {
  testWidgets('app should work', (tester) async {
    await tester.pumpWidget(MyApp());
  });
}
