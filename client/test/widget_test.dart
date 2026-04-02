import 'package:client/core/dependencies.dart';
import 'package:client/main.dart';
import 'package:client/module/profile/profile_screen.dart';
import 'package:client/network/http_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Старт на вкладке Профиль', (WidgetTester tester) async {
    await tester.pumpWidget(
      DependenciesScope(
        dependencies: Dependencies(dio: createAppHttpClient()),
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
