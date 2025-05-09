import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

/// Helper utilities for database operations

/// Get nested field value using dot notation
dynamic getNestedValue(Map<String, dynamic> doc, String fieldPath) {
  final fieldParts = fieldPath.split('.');
  dynamic value = doc;

  for (var part in fieldParts) {
    if (value is Map) {
      value = value[part];
    } else {
      return null;
    }
  }

  return value;
}

/// Parse request body to Map<String, dynamic>
Future<Map<String, dynamic>> parseJsonBody(Request request) async {
  try {
    final body = await request.body();
    return jsonDecode(body) as Map<String, dynamic>;
  } catch (e) {
    throw FormatException('Invalid JSON: $e');
  }
}

/// Apply filter operation to document
bool applyFilter(
  Map<String, dynamic> doc,
  String field,
  String operator,
  dynamic value,
) {
  final fieldParts = field.split('.');
  dynamic fieldValue = doc;

  for (var part in fieldParts) {
    if (fieldValue is Map) {
      fieldValue = fieldValue[part];
    } else {
      return false;
    }
  }

  switch (operator) {
    case '==':
      return fieldValue == value;
    case '!=':
      return fieldValue != value;
    case '>':
      return fieldValue != null && fieldValue > value;
    case '>=':
      return fieldValue != null && fieldValue >= value;
    case '<':
      return fieldValue != null && fieldValue < value;
    case '<=':
      return fieldValue != null && fieldValue <= value;
    case 'contains':
      if (fieldValue is String && value is String) {
        return fieldValue.contains(value);
      } else if (fieldValue is List) {
        if (value is List) {
          return value.any((item) => fieldValue.contains(item));
        } else {
          return fieldValue.contains(value);
        }
      } else if (fieldValue is Map) {
        if (value is String) {
          return fieldValue.containsKey(value);
        } else if (value is Map) {
          return value.entries.every((entry) =>
              fieldValue.containsKey(entry.key) &&
              fieldValue[entry.key] == entry.value);
        }
      }
      return false;
    case 'hasKey':
      if (fieldValue is Map && value is String) {
        return fieldValue.containsKey(value);
      }
      return false;
    case 'hasLength':
      if (value is int) {
        if (fieldValue is List || fieldValue is String || fieldValue is Map) {
          return fieldValue?.length == value;
        }
      }
      return false;
    case 'startsWith':
      if (fieldValue is String && value is String) {
        return fieldValue.startsWith(value);
      }
      return false;
    case 'endsWith':
      if (fieldValue is String && value is String) {
        return fieldValue.endsWith(value);
      }
      return false;
    default:
      return false;
  }
}

/// Get a unique document ID
String generateUniqueId() =>
    'doc_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (DateTime.now().microsecond % 9000)).toString()}';
