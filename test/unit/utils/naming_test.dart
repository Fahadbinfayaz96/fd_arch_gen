import 'package:fd_arch_gen/utils/naming.dart';
import 'package:test/test.dart';

void main() {
  group('Naming Conversions', () {
    test('toPascalCase converts snake_case to PascalCase', () {
      expect(toPascalCase('hello_world'), equals('HelloWorld'));
      expect(toPascalCase('user_profile'), equals('UserProfile'));
      expect(toPascalCase('todo_list_item'), equals('TodoListItem'));
    });

    test('toPascalCase handles single word', () {
      expect(toPascalCase('hello'), equals('Hello'));
      expect(toPascalCase('user'), equals('User'));
    });

    test('toSnakeCase converts PascalCase to snake_case', () {
      expect(toSnakeCase('HelloWorld'), equals('hello_world'));
      expect(toSnakeCase('UserProfile'), equals('user_profile'));
      expect(toSnakeCase('TodoListItem'), equals('todo_list_item'));
    });

    test('toSnakeCase handles single word', () {
      expect(toSnakeCase('Hello'), equals('hello'));
      expect(toSnakeCase('User'), equals('user'));
    });
  });
}
