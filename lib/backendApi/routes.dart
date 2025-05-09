// filepath: e:\flutter projects\db\lib\backendApi\routes.dart
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';



/// API Router for database operations
class DbApiRouter {
  // Reference to the mock Firestore data
  final Map<String, List<Map<String, dynamic>>> mockFirestore;

  DbApiRouter({required this.mockFirestore});

  /// Creates a router for handling database API routes
  Router get router {
    final router = Router();

    // GET /collections - List all collections
    router.get('/collections', _getAllCollections);

    // GET /collections/<collection> - Get all documents in a collection
    router.get('/collections/<collection>', _getCollection);

    // GET /collections/<collection>/<documentId> - Get a specific document
    router.get('/collections/<collection>/<documentId>', _getDocument);

    // POST /collections/<collection> - Create a new document
    router.post('/collections/<collection>', _createDocument);

    // PUT /collections/<collection>/<documentId> - Update a document
    router.put('/collections/<collection>/<documentId>', _updateDocument);

    // DELETE /collections/<collection>/<documentId> - Delete a document
    router.delete('/collections/<collection>/<documentId>', _deleteDocument);

    // POST /query/<collection> - Run a query on a collection
    router.post('/query/<collection>', _queryCollection);

    return router;
  }

  // Handler for getting all collections
  Response _getAllCollections(Request request) {
    final collectionsResponse = {
      'collections': mockFirestore.keys.toList(),
      'count': mockFirestore.length,
    };

    return Response.ok(
      jsonEncode(collectionsResponse),
      headers: {'content-type': 'application/json'},
    );
  }

  // Handler for getting all documents in a collection
  Response _getCollection(Request request, String collection) {
    if (!mockFirestore.containsKey(collection)) {
      return Response.notFound(
        jsonEncode({'error': 'Collection not found'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final docs = mockFirestore[collection]!;
    final response = {
      'collection': collection,
      'documents': docs,
      'count': docs.length,
    };

    return Response.ok(
      jsonEncode(response),
      headers: {'content-type': 'application/json'},
    );
  }

  // Handler for getting a specific document
  Response _getDocument(Request request, String collection, String documentId) {
    if (!mockFirestore.containsKey(collection)) {
      return Response.notFound(
        jsonEncode({'error': 'Collection not found'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final docs = mockFirestore[collection]!;
    final doc = docs.firstWhere(
      (doc) => doc['id'] == documentId,
      orElse: () => <String, dynamic>{},
    );

    if (doc.isEmpty) {
      return Response.notFound(
        jsonEncode({'error': 'Document not found'}),
        headers: {'content-type': 'application/json'},
      );
    }

    return Response.ok(
      jsonEncode(doc),
      headers: {'content-type': 'application/json'},
    );
  }

  // Handler for creating a new document
  Future<Response> _createDocument(Request request, String collection) async {
    if (!mockFirestore.containsKey(collection)) {
      // Create new collection if it doesn't exist
      mockFirestore[collection] = [];
    }

    try {
      final String body = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(body);

      // Check if ID is provided, otherwise generate one
      if (!data.containsKey('id')) {
        data['id'] = 'doc_${DateTime.now().millisecondsSinceEpoch}';
      }

      // Check if document with this ID already exists
      final existingDocIndex = mockFirestore[collection]!
          .indexWhere((doc) => doc['id'] == data['id']);

      if (existingDocIndex != -1) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Document with this ID already exists'}),
          headers: {'content-type': 'application/json'},
        );
      }

      // Add document to collection
      mockFirestore[collection]!.add(data);

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'Document created successfully',
          'document': data,
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.badRequest(
        body: jsonEncode({'error': 'Invalid request data: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // Handler for updating a document
  Future<Response> _updateDocument(
      Request request, String collection, String documentId) async {
    if (!mockFirestore.containsKey(collection)) {
      return Response.notFound(
        jsonEncode({'error': 'Collection not found'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final docs = mockFirestore[collection]!;
    final docIndex = docs.indexWhere((doc) => doc['id'] == documentId);

    if (docIndex == -1) {
      return Response.notFound(
        jsonEncode({'error': 'Document not found'}),
        headers: {'content-type': 'application/json'},
      );
    }

    try {
      final String body = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(body);

      // Preserve the original ID
      data['id'] = documentId;

      // Update the document
      mockFirestore[collection]![docIndex] = data;

      return Response.ok(
        jsonEncode({
          'success': true,
          'message': 'Document updated successfully',
          'document': data,
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.badRequest(
        body: jsonEncode({'error': 'Invalid request data: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // Handler for deleting a document
  Response _deleteDocument(
      Request request, String collection, String documentId) {
    if (!mockFirestore.containsKey(collection)) {
      return Response.notFound(
        jsonEncode({'error': 'Collection not found'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final docs = mockFirestore[collection]!;
    final docIndex = docs.indexWhere((doc) => doc['id'] == documentId);

    if (docIndex == -1) {
      return Response.notFound(
        jsonEncode({'error': 'Document not found'}),
        headers: {'content-type': 'application/json'},
      );
    }

    // Remove the document
    final removedDoc = mockFirestore[collection]!.removeAt(docIndex);

    return Response.ok(
      jsonEncode({
        'success': true,
        'message': 'Document deleted successfully',
        'document': removedDoc,
      }),
      headers: {'content-type': 'application/json'},
    );
  }

  // Handler for querying a collection
  Future<Response> _queryCollection(Request request, String collection) async {
    if (!mockFirestore.containsKey(collection)) {
      return Response.notFound(
        jsonEncode({'error': 'Collection not found'}),
        headers: {'content-type': 'application/json'},
      );
    }

    try {
      final String body = await request.readAsString();
      final Map<String, dynamic> queryData = jsonDecode(body);

      // Get collection documents
      List<Map<String, dynamic>> results =
          List.from(mockFirestore[collection]!);

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
                    return fieldValue.contains(value);
                  }
                  return false;
                case 'hasKey':
                  if (fieldValue is Map && value is String) {
                    return fieldValue.containsKey(value);
                  }
                  return false;
                default:
                  return false;
              }
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
          final aValue = _getNestedValue(a, orderByField);
          final bValue = _getNestedValue(b, orderByField);

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

      return Response.ok(
        jsonEncode({
          'collection': collection,
          'results': results,
          'count': results.length,
        }),
        headers: {'content-type': 'application/json'},
      );
    } catch (e) {
      return Response.badRequest(
        body: jsonEncode({'error': 'Invalid query data: $e'}),
        headers: {'content-type': 'application/json'},
      );
    }
  }

  // Helper function to get nested field values using dot notation
  dynamic _getNestedValue(Map<String, dynamic> doc, String fieldPath) {
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
}
