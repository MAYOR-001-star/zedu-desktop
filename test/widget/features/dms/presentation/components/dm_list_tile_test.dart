import 'package:zedu/core/core.dart';
import 'package:zedu/features/features.dart';

import '../../../../../helpers/helpers.dart';

class _FakeAuthNotifier extends AuthNotifier {
  @override
  AuthState build() => AuthState(
    status: AuthStatus.authenticated,
    user: User(
      id: 'me',
      firstName: 'Jennifer',
      lastName: 'Amanze',
      email: 'jenie@z.com',
      phone: '',
      username: 'Jenie',
      isVerified: true,
      isOnboarded: true,
      createdAt: DateTime(2026, 1, 1),
      currentOrg: 'org-1',
      currentOrganisationSlug: 'hng',
      avatarUrl: '',
      defaultAvatarUrl: '',
    ),
  );
}

DmConversation _dm(String name, {required String participantId}) =>
    DmConversation(
      channelId: 'channel-$name',
      username: name,
      participantId: participantId,
      previewMessage: 'See you at standup',
      unreadCount: 0,
    );

Future<void> _pumpTile(WidgetTester tester, DmConversation conversation) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authNotifierProvider.overrideWith(_FakeAuthNotifier.new)],
      child: buildTestMaterialApp(
        Scaffold(body: DmListTile(conversation: conversation)),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('DmListTile', () {
    testWidgets('labels your own space "(you)" with "Your notes and drafts"', (
      tester,
    ) async {
      await _pumpTile(tester, _dm('Jenie', participantId: 'me'));

      expect(find.text('Jenie (you)'), findsOneWidget);
      expect(find.text('Your notes and drafts'), findsOneWidget);
      expect(find.text('See you at standup'), findsNothing);
    });

    testWidgets('shows other DMs as before', (tester) async {
      await _pumpTile(tester, _dm('Song Martins', participantId: 'u-song'));

      expect(find.text('Song Martins'), findsOneWidget);
      expect(find.text('See you at standup'), findsOneWidget);
      expect(find.textContaining('(you)'), findsNothing);
    });
  });
}
