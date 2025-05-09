/// Mock Firestore database for the application
Map<String, List<Map<String, dynamic>>> mockFirestore = {
  'Users': [
    {
      'id': 'user1',
      'username': 'Hassan',
      'age': 25,
      'isActive': true,
      'joinedAt': '2023-10-05T14:21:00',
      'hobbies': ['coding', 'gaming'],
      'profile': {
        'bio': 'Flutter developer',
        'avatar': 'https://i.imgur.com/uPgNOK3.jpg',
      },
    },
    {
      'id': 'user2',
      'username': 'Ahmed',
      'age': 30,
      'isActive': false,
      'joinedAt': '2022-04-15T09:00:00',
      'hobbies': ['reading'],
      'profile': {
        'bio': 'Backend engineer',
        'avatar': 'https://i.imgur.com/6Jz9PzX.png',
      },
    },
  ],
  'Products': [
    {
      'id': 'prod1',
      'name': 'Laptop',
      'price': 1299.99,
      'inStock': true,
      'tags': ['electronics', 'computers'],
      'addedOn': '2023-01-01T00:00:00',
    },
    {
      'id': 'prod2',
      'name': 'Smartphone',
      'price': 899.50,
      'inStock': false,
      'tags': ['electronics', 'mobile'],
      'addedOn': '2023-02-15T00:00:00',
    },
  ],
  'test': []
};

/// Database schemas for validation
Map<String, List<Map<String, dynamic>>> databaseSchemas = {
  'test': [
    {
      'name': 'id',
      'type': 'String',
      'nullable': false,
      'autoIncrement': true,
      'unique': false
    },
    {
      'name': 'name',
      'type': 'String',
      'nullable': false,
      'autoIncrement': false,
      'unique': false
    },
    {
      'name': 'Date',
      'type': 'Date',
      'nullable': false,
      'autoIncrement': false,
      'unique': false
    },
  ],
  'Users': [
    {
      'name': 'id',
      'type': 'String',
      'nullable': false,
      'autoIncrement': false,
      'unique': true
    },
    {
      'name': 'username',
      'type': 'String',
      'nullable': false,
      'autoIncrement': false,
      'unique': false
    },
    {
      'name': 'age',
      'type': 'Number',
      'nullable': true,
      'autoIncrement': false,
      'unique': false
    },
    {
      'name': 'isActive',
      'type': 'Boolean',
      'nullable': true,
      'autoIncrement': false,
      'unique': false
    },
    {
      'name': 'joinedAt',
      'type': 'Date',
      'nullable': true,
      'autoIncrement': false,
      'unique': false
    },
    {
      'name': 'hobbies',
      'type': '[String]',
      'nullable': true,
      'autoIncrement': false,
      'unique': false
    },
    {
      'name': 'profile',
      'type': 'Map',
      'nullable': true,
      'autoIncrement': false,
      'unique': false
    },
  ],
  'Products': [
    {
      'name': 'id',
      'type': 'String',
      'nullable': false,
      'autoIncrement': false,
      'unique': true
    },
    {
      'name': 'name',
      'type': 'String',
      'nullable': false,
      'autoIncrement': false,
      'unique': false
    },
    {
      'name': 'price',
      'type': 'Number',
      'nullable': true,
      'autoIncrement': false,
      'unique': false
    },
    {
      'name': 'inStock',
      'type': 'Boolean',
      'nullable': true,
      'autoIncrement': false,
      'unique': false
    },
    {
      'name': 'tags',
      'type': '[String]',
      'nullable': true,
      'autoIncrement': false,
      'unique': false
    },
    {
      'name': 'addedOn',
      'type': 'Date',
      'nullable': true,
      'autoIncrement': false,
      'unique': false
    },
  ],
};
