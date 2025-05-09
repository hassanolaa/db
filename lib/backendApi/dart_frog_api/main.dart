import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

// Mock database reference
import '../../core/shared/mockDatabase.dart';

/// Main entry point for the Dart Frog API server
Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  // Add global middleware
  handler = handler.use(requestLogger()).use(jsonResponseMiddleware());

  // Return the server
  return serve(handler, ip, port);
}

/// Middleware that ensures all responses are JSON
Middleware jsonResponseMiddleware() {
  return (handler) {
    return (context) async {
      final response = await handler(context);
      return response.copyWith(
        headers: {
          ...response.headers,
          'content-type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      );
    };
  };
}
