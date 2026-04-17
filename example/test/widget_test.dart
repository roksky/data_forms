import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('sample picker opens a form', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Choose a sample form'), findsOneWidget);
    expect(find.text('Multi-section form'), findsOneWidget);

    await tester.tap(find.text('Single-section form'));
    await tester.pumpAndSettle();

    expect(find.text('Single section Page'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
  });
}
