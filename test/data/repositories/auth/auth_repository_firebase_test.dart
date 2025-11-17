import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:modern_turkmen_admin/data/repositories/auth/auth_repository_firebase.dart';
import 'package:modern_turkmen_admin/data/services/auth_service.dart';
import 'package:modern_turkmen_admin/data/services/firestore/firestore_service.dart';
import 'package:modern_turkmen_admin/domain/models/user/user.dart';

@GenerateMocks([AuthService, FirestoreService])
import 'auth_repository_firebase_test.mocks.dart';

class MockUser implements User {
  @override
  final bool admin;
  MockUser({required this.admin});
  
  @override
  $UserCopyWith<User> get copyWith => throw UnimplementedError();
  
  @override
  String? get id => throw UnimplementedError();
  
  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

void main() {
  late AuthRepositoryFirebase repository;
  late MockAuthService mockAuthService;
  late MockFirestoreService mockFirestoreService;

  setUp(() {
    mockAuthService = MockAuthService();
    mockFirestoreService = MockFirestoreService();
    repository = AuthRepositoryFirebase(
      authService: mockAuthService,
      firestoreService: mockFirestoreService,
    );
  });

  group('AuthRepositoryFirebase', () {
    group('login', () {
      test('should login successfully when user is admin', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const userId = 'user123';
        final adminUser = MockUser(admin: true);

        when(mockAuthService.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async {});

        when(mockAuthService.currentUserId).thenReturn(userId);
        when(mockFirestoreService.getUser(userId))
            .thenAnswer((_) async => adminUser);

        // Act
        await repository.login(email: email, password: password);

        // Assert
        verify(mockAuthService.signInWithEmailAndPassword(
          email: email,
          password: password,
        ));
        verify(mockFirestoreService.getUser(userId));
      });

      test('should throw exception when user is not admin', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const userId = 'user123';
        final nonAdminUser = MockUser(admin: false);

        when(mockAuthService.signInWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async {});

        when(mockAuthService.currentUserId).thenReturn(userId);
        when(mockFirestoreService.getUser(userId))
            .thenAnswer((_) async => nonAdminUser);

        // Act & Assert
        expect(
          () => repository.login(email: email, password: password),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('isLoggedIn', () {
      test('should return true when user is logged in', () {
        // Arrange
        when(mockAuthService.currentUserId).thenReturn('user123');

        // Act
        final result = repository.isLoggedIn;

        // Assert
        expect(result, true);
      });

      test('should return false when user is not logged in', () {
        // Arrange
        when(mockAuthService.currentUserId).thenReturn(null);

        // Act
        final result = repository.isLoggedIn;

        // Assert
        expect(result, false);
      });
    });

    group('signOut', () {
      test('should call auth service signOut', () async {
        // Arrange
        when(mockAuthService.signOut()).thenAnswer((_) async {});

        // Act
        await repository.signOut();

        // Assert
        verify(mockAuthService.signOut());
      });
    });

    group('currentUserId', () {
      test('should return current user id', () {
        // Arrange
        const userId = 'user123';
        when(mockAuthService.currentUserId).thenReturn(userId);

        // Act
        final result = repository.currentUserId;

        // Assert
        expect(result, userId);
      });

      test('should return null when no user is logged in', () {
        // Arrange
        when(mockAuthService.currentUserId).thenReturn(null);

        // Act
        final result = repository.currentUserId;

        // Assert
        expect(result, null);
      });
    });
  });
}