import 'package:flutter_test/flutter_test.dart';
import 'package:modern_turkmen_admin/domain/models/user/user.dart';

void main() {
  group('User', () {
    test('should create User with required fields', () {
      const user = User(admin: true);
      
      expect(user.admin, true);
      expect(user.id, null);
    });

    test('should create User with id and admin fields', () {
      const user = User(id: 'test-id', admin: false);
      
      expect(user.id, 'test-id');
      expect(user.admin, false);
    });

    test('should create User from JSON', () {
      final json = {'admin': true};
      final user = User.fromJson(json);
      
      expect(user.admin, true);
      expect(user.id, null);
    });

    test('should serialize to JSON without id field', () {
      const user = User(id: 'test-id', admin: true);
      final json = user.toJson();
      
      expect(json['admin'], true);
      expect(json.containsKey('id'), false);
    });

    test('should support equality', () {
      const user1 = User(admin: true);
      const user2 = User(admin: true);
      const user3 = User(admin: false);
      
      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });

    test('should support copyWith', () {
      const user = User(id: 'original-id', admin: false);
      final copied = user.copyWith(admin: true);
      
      expect(copied.id, 'original-id');
      expect(copied.admin, true);
    });
  });
}