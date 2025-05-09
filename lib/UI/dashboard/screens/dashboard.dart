import 'package:db/UI/core/shared/shareddata.dart';
import 'package:db/UI/dashboard/widgets/keyValue.dart';
import 'package:db/UI/dashboard/widgets/noSqlQueryMode.dart';
import 'package:flutter/material.dart';
import '../widgets/Authantcation.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/sidebar_widget.dart';
import '../widgets/main_content_widget.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _FirebaseCloneDashboardState();
}

class _FirebaseCloneDashboardState extends State<dashboard> {
  final String selectedProject = "Stabrak";
  final String selectedSection = "Database name";
  String selectedCollection = '';
  String selectedValue = 'Option 1';
  int view =0; // 0: Main content, 1: Key-Value, 2: NoSQL Query, 3: Authentication

  final List<String> options = ['Option 1', 'Option 2', 'Option 3'];

  String? selectedDocId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DashboardAppBar(
            selectedValue: selectedValue,
            options: options,
            onValueChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedValue = newValue;
                });
              }
            },
          ),
          Expanded(
            child: Row(
              children: [
                SidebarWidget(
                  onTap: () {
                    setState(() {
                      if (view == 0) {
                        view = 1;
                      } else if (view == 1) {
                        view = 2;
                      } else if (view == 2) {
                        view = 0;
                      } else {
                        view = 0;
                      }
                    });
                  },
                ),
                Expanded(
                    child: view == 0
                        ? MainContentWidget(
                            selectedSection: selectedSection,
                            selectedCollection: selectedCollection,
                            selectedDocId: selectedDocId,
                            mockFirestore: mockFirestore,
                            onCollectionSelected: (collection) {
                              setState(() {
                                selectedCollection = collection;
                                selectedDocId = null;
                              });
                            },
                            onDocumentSelected: (docId) {
                              setState(() {
                                selectedDocId = docId;
                              });
                            },
                            onDeleteCollection: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Collection'),
                                    content: const Text(
                                        'Are you sure you want to delete this collection?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          mockFirestore
                                              .remove(selectedCollection);
                                          setState(() {
                                            selectedCollection =
                                                ''; // Reset to default collection
                                            selectedDocId =
                                                null; // Reset selected document
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onDeleteDocument: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Document'),
                                    content: const Text(
                                        'Are you sure you want to delete this document?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Delete the document from the collection
                                          mockFirestore[selectedCollection]!
                                              .removeWhere((doc) =>
                                                  doc['id'] == selectedDocId);
                                          setState(() {
                                            selectedDocId =
                                                null; // Reset selected document
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          )
                        : view == 1
                            ? KeyValueDatabaseUI()
                            
                                : UserManagementScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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

final Map<String, List<Map<String, dynamic>>> mockFirestore = {
  'Users': [
    {
      'id': 'user1',
      'username': 'Hassan',
      'age': 25,
      'isActive': true,
      'joinedAt': DateTime(2023, 10, 5, 14, 21),
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
      'joinedAt': DateTime(2022, 4, 15, 9, 0),
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
      'addedOn': DateTime.now(),
    },
    {
      'id': 'prod2',
      'name': 'Smartphone',
      'price': 899.50,
      'inStock': false,
      'tags': ['electronics', 'mobile'],
      'addedOn': DateTime.now(),
    },
  ],
  'test': []
};
