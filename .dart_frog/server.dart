// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/index.dart' as index;
import '../routes/query/[collection].dart' as query_$collection;
import '../routes/collections/index.dart' as collections_index;
import '../routes/collections/[collection]/index.dart' as collections_$collection_index;
import '../routes/collections/[collection]/[documentId].dart' as collections_$collection_$document_id;

import '../routes/_middleware.dart' as middleware;

void main() async {
  final address = InternetAddress.tryParse('') ?? InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  hotReload(() => createServer(address, port));
}

Future<HttpServer> createServer(InternetAddress address, int port) {
  final handler = Cascade().add(buildRootHandler()).handler;
  return serve(handler, address, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/collections/<collection>', (context,collection,) => buildCollections$collectionHandler(collection,)(context))
    ..mount('/collections', (context) => buildCollectionsHandler()(context))
    ..mount('/query', (context) => buildQueryHandler()(context))
    ..mount('/', (context) => buildHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildCollections$collectionHandler(String collection,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => collections_$collection_index.onRequest(context,collection,))..all('/<documentId>', (context,documentId,) => collections_$collection_$document_id.onRequest(context,collection,documentId,));
  return pipeline.addHandler(router);
}

Handler buildCollectionsHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => collections_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildQueryHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/<collection>', (context,collection,) => query_$collection.onRequest(context,collection,));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => index.onRequest(context,));
  return pipeline.addHandler(router);
}

