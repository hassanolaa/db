import 'package:dart_frog/dart_frog.dart';
import '../../lib/core/shared/mockDatabase.dart';
import '../../lib/api/utils.dart';

Future<Response> onRequest(RequestContext context, String collection) async {
  // Only POST method is allowed for queries
  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: 405,
      body: {'error': 'Method not allowed, use POST for queries'},
    );
  }

  // Check if collection exists
  if (!mockFirestore.containsKey(collection)) {
    return Response.json(
      statusCode: 404,
      body: {'error': 'Collection not found'},
    );
  }

  try {
    final queryData = await parseJsonBody(context.request);

    // Get collection documents
    List<Map<String, dynamic>> results = List.from(mockFirestore[collection]!);

    // Apply filters if provided
    if (queryData.containsKey('filters') && queryData['filters'] is List) {
      final filters = queryData['filters'] as List;

      for (var filter in filters) {
        if (filter is Map &&
            filter.containsKey('field') &&
            filter.containsKey('operator') &&
            filter.containsKey('value')) {
          final field = filter['field'] as String;
          final operator = filter['operator'] as String;
          final value = filter['value'];

          results = results.where((doc) {
            return applyFilter(doc, field, operator, value);
          }).toList();
        }
      }
    }

    // Apply sorting if provided
    if (queryData.containsKey('orderBy') &&
        queryData['orderBy'] is Map &&
        queryData['orderBy'].containsKey('field')) {
      final orderByField = queryData['orderBy']['field'] as String;
      final descending = queryData['orderBy']['descending'] ?? false;

      results.sort((a, b) {
        final aValue = getNestedValue(a, orderByField);
        final bValue = getNestedValue(b, orderByField);

        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return descending ? 1 : -1;
        if (bValue == null) return descending ? -1 : 1;

        int comparison;
        if (aValue is num && bValue is num) {
          comparison = aValue.compareTo(bValue);
        } else if (aValue is String && bValue is String) {
          comparison = aValue.compareTo(bValue);
        } else if (aValue is bool && bValue is bool) {
          comparison = aValue == bValue ? 0 : (aValue ? 1 : -1);
        } else {
          comparison = 0;
        }

        return descending ? -comparison : comparison;
      });
    }

    // Apply limit if provided
    if (queryData.containsKey('limit') && queryData['limit'] is int) {
      final limit = queryData['limit'] as int;
      if (limit > 0 && limit < results.length) {
        results = results.take(limit).toList();
      }
    }

    return Response.json(
      body: {
        'collection': collection,
        'results': results,
        'count': results.length,
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Invalid query data: $e'},
    );
  }
}
