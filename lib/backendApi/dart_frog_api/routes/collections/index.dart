import 'package:dart_frog/dart_frog.dart';
import '../../../../core/shared/mockDatabase.dart';

/// Handler for /collections endpoint
Future<Response> onRequest(RequestContext context) async {
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

  // Only GET method is allowed for collections listing
  if (context.request.method == HttpMethod.get) {
    return Response.json(
      body: {
        'collections': mockFirestore.keys.toList(),
        'count': mockFirestore.length,
        'schemas': databaseSchemas,
      },
    );
  }

  // Method not allowed
  return Response.json(
    statusCode: 405,
    body: {'error': 'Method not allowed'},
  );
}
