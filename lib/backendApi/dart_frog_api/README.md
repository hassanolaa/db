# Dart Frog API for Database

This is a Dart Frog API implementation for the database application that provides RESTful endpoints to manage collections and documents.

## Setup Instructions

1. Install Dart Frog:

```bash
dart pub global activate dart_frog_cli
```

2. Run the server:

```bash
dart_frog dev
```

The server will start on `http://localhost:8080`

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

## Supported Query Operators

- `==`: Equal to
- `!=`: Not equal to
- `>`: Greater than
- `>=`: Greater than or equal to
- `<`: Less than
- `<=`: Less than or equal to
- `contains`: Contains the value (for strings, lists, and maps)
- `hasKey`: Checks if a map has the specified key
- `hasLength`: Checks if a list, map, or string has the specified length
- `startsWith`: Checks if a string starts with the specified value
- `endsWith`: Checks if a string ends with the specified value

## Working with Nested Fields

Use dot notation to access nested fields:

```http
POST /query/Users
Content-Type: application/json

{
  "filters": [
    {
      "field": "profile.bio",
      "operator": "contains",
      "value": "developer"
    }
  ]
}
```