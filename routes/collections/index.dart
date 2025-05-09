import 'package:dart_frog/dart_frog.dart';
import '../../lib/core/shared/mockDatabase.dart';

Response onRequest(RequestContext context) {
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
