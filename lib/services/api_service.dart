import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to interact with the Dart Frog API
class ApiService {
  /// Base URL of the API
  final String baseUrl;

  /// Create a new API service
  ApiService({required this.baseUrl});

  /// Singleton instance
  static final ApiService _instance =
      ApiService(baseUrl: 'http://localhost:8080');

  /// Get the singleton instance
  static ApiService get instance => _instance;

  /// Headers for API requests
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Get all collections
  Future<Map<String, dynamic>> getCollections() async {
    final response = await http.get(
      Uri.parse('$baseUrl/collections'),
      headers: _headers,
    );

    _validateResponse(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Get all documents in a collection
  Future<Map<String, dynamic>> getCollection(String collection) async {
    final response = await http.get(
      Uri.parse('$baseUrl/collections/$collection'),
      headers: _headers,
    );

    _validateResponse(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Get a specific document
  Future<Map<String, dynamic>> getDocument(
      String collection, String documentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/collections/$collection/$documentId'),
      headers: _headers,
    );

    _validateResponse(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Create a new document
  Future<Map<String, dynamic>> createDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/collections/$collection'),
      headers: _headers,
      body: jsonEncode(data),
    );

    _validateResponse(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Update a document
  Future<Map<String, dynamic>> updateDocument(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/collections/$collection/$documentId'),
      headers: _headers,
      body: jsonEncode(data),
    );

    _validateResponse(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Delete a document
  Future<Map<String, dynamic>> deleteDocument(
    String collection,
    String documentId,
  ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/collections/$collection/$documentId'),
      headers: _headers,
    );

    _validateResponse(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Run a query on a collection
  Future<Map<String, dynamic>> queryCollection(
    String collection,
    Map<String, dynamic> queryData,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/query/$collection'),
      headers: _headers,
      body: jsonEncode(queryData),
    );

    _validateResponse(response);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Validate API response
  void _validateResponse(http.Response response) {
    if (response.statusCode >= 400) {
      final error = jsonDecode(response.body);
      throw ApiException(
        statusCode: response.statusCode,
        message: error['error'] ?? 'Unknown error',
      );
    }
  }
}

/// Exception thrown when an API request fails
class ApiException implements Exception {
  /// HTTP status code
  final int statusCode;

  /// Error message
  final String message;

  /// Create a new API exception
  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException: $statusCode - $message';
}
