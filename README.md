# DB Project with Dart Frog API

A Flutter database application with a Dart Frog API backend.

## Running the API Server

1. Make sure you have Dart SDK installed.

2. Install dart_frog:
   ```
   dart pub global activate dart_frog_cli
   ```

3. Navigate to the project directory:
   ```
   cd "e:\flutter projects\db"
   ```

4. Run the Dart Frog server:
   ```
   dart_frog dev
   ```

5. The API will be available at `http://localhost:8080`

## API Endpoints

### Root Endpoint

- `GET /`: Get API information

### Collections Endpoints

- `GET /collections`: List all collections
- `GET /collections/:collection`: Get all documents in a collection
- `POST /collections/:collection`: Create a new document
- `GET /collections/:collection/:documentId`: Get a specific document
- `PUT /collections/:collection/:documentId`: Update a document
- `DELETE /collections/:collection/:documentId`: Delete a document

### Query Endpoint

- `POST /query/:collection`: Run a query on a collection

## Example Queries

### Creating a document

```http
POST /collections/Users
Content-Type: application/json

{
  "username": "johndoe",
  "age": 28,
  "isActive": true,
  "hobbies": ["reading", "hiking"],
  "profile": {
    "bio": "Software developer",
    "avatar": "https://example.com/avatar.jpg"
  }
}
```

### Querying documents

```http
POST /query/Users
Content-Type: application/json

{
  "filters": [
    {
      "field": "age",
      "operator": ">",
      "value": 25
    },
    {
      "field": "isActive",
      "operator": "==",
      "value": true
    }
  ],
  "orderBy": {
    "field": "username",
    "descending": false
  },
  "limit": 10
}
```

## Using the API in Flutter

Use the ApiService class to interact with the API from Flutter:

```dart
final apiService = ApiService(baseUrl: 'http://localhost:8080');

// Get all collections
final collections = await apiService.getCollections();

// Get documents in a collection
final users = await apiService.getCollection('Users');

// Query documents
final results = await apiService.queryCollection('Users', {
  'filters': [
    {'field': 'age', 'operator': '>', 'value': 25},
  ],
  'orderBy': {'field': 'username', 'descending': false},
});
