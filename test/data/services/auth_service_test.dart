import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modern_turkmen_admin/data/services/auth_service.dart';

@GenerateMocks([FirebaseAuth, User])
import 'auth_service_test.mocks.dart';

void main() {
  late AuthService authService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUser = MockUser();
    authService = AuthService(mockFirebaseAuth);
  });

  group('AuthService', () {
    test('currentUserId returns user uid when user is signed in', () {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('test-uid');

      expect(authService.currentUserId, 'test-uid');
    });

    test('currentUserId returns null when no user is signed in', () {
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      expect(authService.currentUserId, null);
    });

    test('signInWithEmailAndPassword calls FirebaseAuth successfully', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => MockUserCredential());

      await authService.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password',
      );

      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password',
      )).called(1);
    });

    test('signInWithEmailAndPassword throws exception for user-not-found', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      expect(
        () => authService.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('No user found for that email.'),
        )),
      );
    });

    test('signInWithEmailAndPassword throws exception for wrong-password', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      expect(
        () => authService.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Wrong password provided for that user.'),
        )),
      );
    });

    test('signInWithEmailAndPassword throws generic exception for other errors', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(code: 'other-error', message: 'Some error'));

      expect(
        () => authService.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password',
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to sign in: Some error'),
        )),
      );
    });

    test('signOut calls FirebaseAuth signOut', () async {
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      await authService.signOut();

      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });
}

class MockUserCredential extends Mock implements UserCredential {}