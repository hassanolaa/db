import 'package:dart_frog/dart_frog.dart';
import '../../../lib/core/shared/mockDatabase.dart';
import '../../../lib/api/utils.dart';

Future<Response> onRequest(
  RequestContext context,
  String collection,
  String documentId,
) async {
  // Check if collection exists
  if (!mockFirestore.containsKey(collection)) {
    return Response.json(
      statusCode: 404,
      body: {'error': 'Collection not found'},
    );
  }

  // Find the document
  final docs = mockFirestore[collection]!;
  final docIndex = docs.indexWhere((doc) => doc['id'] == documentId);

  // Check if document exists (for all operations except POST)
  if (docIndex == -1) {
    return Response.json(
      statusCode: 404,
      body: {'error': 'Document not found'},
    );
  }

  switch (context.request.method) {
    case HttpMethod.get:
      return _handleGetDocument(context, collection, docIndex);

    case HttpMethod.put:
      return _handleUpdateDocument(context, collection, docIndex, documentId);

    case HttpMethod.delete:
      return _handleDeleteDocument(context, collection, docIndex);

    default:
      return Response.json(
        statusCode: 405,
        body: {'error': 'Method not allowed'},
      );
  }
}

/// Handle GET request to retrieve a specific document
Response _handleGetDocument(
  RequestContext context,
  String collection,
  int docIndex,
) {
  final doc = mockFirestore[collection]![docIndex];

  return Response.json(body: doc);
}

/// Handle PUT request to update a specific document
Future<Response> _handleUpdateDocument(
  RequestContext context,
  String collection,
  int docIndex,
  String documentId,
) async {
  try {
    final data = await parseJsonBody(context.request);

    // Preserve the original ID
    data['id'] = documentId;

    // Update the document
    mockFirestore[collection]![docIndex] = data;

    return Response.json(
      body: {
        'success': true,
        'message': 'Document updated successfully',
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

/// Handle DELETE request to delete a specific document
Response _handleDeleteDocument(
  RequestContext context,
  String collection,
  int docIndex,
) {
  // Remove the document
  final removedDoc = mockFirestore[collection]!.removeAt(docIndex);

  return Response.json(
    body: {
      'success': true,
      'message': 'Document deleted successfully',
      'document': removedDoc,
    },
  );
}
