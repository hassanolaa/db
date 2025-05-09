import 'package:dart_frog/dart_frog.dart';
import '../../../../../UI/dashboard/screens/dashboard.dart';
import '../../../utils/db_utils.dart';


/// Handler for /collections/:collection endpoint
Future<Response> onRequest(RequestContext context, String collection) async {
  // Handle OPTIONS request for CORS
  if (context.request.method == HttpMethod.options) {
    return Response(
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token',
      },
    );
  }

  // Check if collection exists for GET and PUT
  if (!mockFirestore.containsKey(collection) &&
      context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: 404,
      body: {'error': 'Collection not found'},
    );
  }

  switch (context.request.method) {
    case HttpMethod.get:
      return _handleGetCollection(context, collection);

    case HttpMethod.post:
      return _handleCreateDocument(context, collection);

    default:
      return Response.json(
        statusCode: 405,
        body: {'error': 'Method not allowed'},
      );
  }
}

/// Handle GET request to retrieve all documents in a collection
Response _handleGetCollection(RequestContext context, String collection) {
  final docs = mockFirestore[collection]!;

  return Response.json(
    body: {
      'collection': collection,
      'documents': docs,
      'count': docs.length,
    },
  );
}

/// Handle POST request to create a new document
Future<Response> _handleCreateDocument(
  RequestContext context,
  String collection,
) async {
  try {
    final data = await parseJsonBody(context.request);

    // Create collection if it doesn't exist
    if (!mockFirestore.containsKey(collection)) {
      mockFirestore[collection] = [];
    }

    // Check if ID is provided, otherwise generate one
    if (!data.containsKey('id')) {
      data['id'] = generateUniqueId();
    }

    // Check if document with this ID already exists
    final existingDocIndex =
        mockFirestore[collection]!.indexWhere((doc) => doc['id'] == data['id']);

    if (existingDocIndex != -1) {
      return Response.json(
        statusCode: 400,
        body: {'error': 'Document with this ID already exists'},
      );
    }

    // Add document to collection
    mockFirestore[collection]!.add(data);

    return Response.json(
      statusCode: 201,
      body: {
        'success': true,
        'message': 'Document created successfully',
        'document': data,
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Invalid request data: $e'},
    );
  }
}
