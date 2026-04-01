import 'package:client/main.dart';
import 'package:client/module/profile/profile_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Старт на вкладке Профиль', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
