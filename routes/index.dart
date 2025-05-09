import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import '../lib/core/shared/mockDatabase.dart';

// Root handler for the API
Response onRequest(RequestContext context) {
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

  // Standard API response
  return Response.json(
    body: {
      'service': 'DB API',
      'version': '1.0.0',
      'status': 'online',
      'endpoints': [
        '/collections',
        '/collections/:collection',
        '/collections/:collection/:documentId',
        '/query/:collection',
      ],
    },
  );
}
