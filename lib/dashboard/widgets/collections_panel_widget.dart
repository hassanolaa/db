import 'package:db/dashboard/screens/dashboard.dart';
import 'package:flutter/material.dart';

class CollectionsPanel extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>> mockFirestore;
  final String selectedCollection;
  final Function(String) onCollectionSelected;
  final VoidCallback onDeleteCollection;

  const CollectionsPanel({
    Key? key,
    required this.mockFirestore,
    required this.selectedCollection,
    required this.onCollectionSelected,
    required this.onDeleteCollection,
  }) : super(key: key);

  @override
  State<CollectionsPanel> createState() => _CollectionsPanelState();
}

class _CollectionsPanelState extends State<CollectionsPanel> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 8),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                const Icon(Icons.filter_list, size: 20),
                const SizedBox(width: 8),
                const Text(
                  '(default)',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                GestureDetector(
                    //onTap: widget.onDeleteCollection,
                    onTap: () {
                      // show menu for collection actions
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(500, 150, 600, 0),
                        items: [
                          PopupMenuItem(
                            value: 'Show Schema',
                            child: Row(
                              children: const [
                                Icon(Icons.view_list, size: 16),
                                SizedBox(width: 8),
                                Text('Show Schema'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: const [
                                Icon(Icons.delete_outline, size: 16),
                                SizedBox(width: 8),
                                Text('Delete Collection'),
                              ],
                            ),
                          ),
                        ],
                      ).then((value) {
                        if (widget.selectedCollection=='') {
                          // Show error message if no collection is selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  'Please select a collection to perform this action.'),
                            ),
                          );
                        } else {
                          if (value == 'delete') {
                            widget.onDeleteCollection();
                          } else if (value == 'Show Schema') {
                            // Show schema logic here
                             showDialog(
                context: context,
                builder: (context) {
                  // Controllers for managing form inputs
                 
                 final collectionInfo= databaseSchemas[widget.selectedCollection];
                 final collectionNameController = TextEditingController(text: widget.selectedCollection);
                  // List to track added collectionShema
                  List<Map<String, dynamic>> collectionShema = collectionInfo ?? [];

               
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          constraints: BoxConstraints(
                            maxWidth: 600,
                            maxHeight: MediaQuery.of(context).size.height * 0.8,
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.view_list,
                                      size: 28, color: Colors.blue),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Show Collection Schema',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                              const Divider(height: 32),
                              TextField(
                                readOnly: true,
                                controller: collectionNameController,
                                decoration: InputDecoration(
                                  labelText: 'Collection Name',
                                  hintText: 'Enter collection name',
                                  prefixIcon: const Icon(Icons.folder_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                              ),
                              const SizedBox(height: 24),
                             
                              const SizedBox(height: 24),
                              Expanded(
                                child: Card(
                                  elevation: 1,
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Fields',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                collectionShema.length
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(height: 1),
                                      Expanded(
                                        child: collectionShema.isEmpty
                                            ? Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.view_list,
                                                        size: 48,
                                                        color: Colors
                                                            .grey.shade400),
                                                    const SizedBox(height: 16),
                                                    Text(
                                                      'No Fields added yet',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : ListView.separated(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                itemCount:
                                                    collectionShema.length,
                                                separatorBuilder: (_, __) =>
                                                    const Divider(height: 1),
                                                itemBuilder: (context, index) {
                                                  final field =
                                                      collectionShema[index];
                                                  return ListTile(
                                                    title: Text(
                                                      field['name'],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    subtitle: Text(
                                                        '${field['type']} ' +
                                                            [
                                                              if (field[
                                                                  'nullable'])
                                                                'nullable',
                                                              if (field[
                                                                  'unique'])
                                                                'unique',
                                                              if (field[
                                                                  'autoIncrement'])
                                                                'auto increment'
                                                            ].join(', ')),
                                                    // trailing: IconButton(
                                                    //   icon: const Icon(
                                                    //       Icons.delete_outline,
                                                    //       color: Colors.red),
                                                    //   onPressed: () {
                                                    //     setState(() {
                                                    //       collectionShema
                                                    //           .removeAt(index);
                                                    //     });
                                                    //   },
                                                    //   tooltip: 'Remove field',
                                                    // ),
                                                  );
                                                },
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Close'),
                                  ),
                               
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
                          }
                        }
                      });
                    },
                    child: const Icon(Icons.more_vert, size: 20)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle the action for starting a new collection
              // showdialog contains the logic to create a new collection
              showDialog(
                context: context,
                builder: (context) {
                  // Controllers for managing form inputs
                  final collectionNameController = TextEditingController();
                  final fieldNameController = TextEditingController();
                  String? selectedFieldType;
                  bool isNullable = false;
                  bool isAutoIncrement = false;
                  bool isUnique = false;

                  // List to track added collectionShema
                  List<Map<String, dynamic>> collectionShema = [];

                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          constraints: BoxConstraints(
                            maxWidth: 600,
                            maxHeight: MediaQuery.of(context).size.height * 0.8,
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.create_new_folder_outlined,
                                      size: 28, color: Colors.blue),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Create New Collection',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                              const Divider(height: 32),
                              TextField(
                                controller: collectionNameController,
                                decoration: InputDecoration(
                                  labelText: 'Collection Name',
                                  hintText: 'Enter collection name',
                                  prefixIcon: const Icon(Icons.folder_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Card(
                                elevation: 1,
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Add Field',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: TextField(
                                              controller: fieldNameController,
                                              decoration: InputDecoration(
                                                labelText: 'Field Name',
                                                hintText: 'Enter field name',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            flex: 1,
                                            child:
                                                DropdownButtonFormField<String>(
                                              value: selectedFieldType,
                                              items: const [
                                                DropdownMenuItem(
                                                    value: 'String',
                                                    child: Text('String')),
                                                DropdownMenuItem(
                                                    value: 'Number',
                                                    child: Text('Number')),
                                                DropdownMenuItem(
                                                    value: 'Boolean',
                                                    child: Text('Boolean')),
                                                DropdownMenuItem(
                                                    value: 'Map',
                                                    child: Text('Map')),
                                                DropdownMenuItem(
                                                    value: 'Array',
                                                    child: Text('Array')),
                                                DropdownMenuItem(
                                                    value: 'Date',
                                                    child: Text('Date')),     
                                                DropdownMenuItem(
                                                    value: 'Timestamp',
                                                    child: Text('Timestamp')),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedFieldType = value;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                labelText: 'Type',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Wrap(
                                        spacing: 16,
                                        children: [
                                          FilterChip(
                                            label: const Text('Nullable'),
                                            selected: isNullable,
                                            onSelected: (value) {
                                              setState(() {
                                                isNullable = value;
                                              });
                                            },
                                            avatar: isNullable
                                                ? const Icon(Icons.check,
                                                    size: 16)
                                                : null,
                                          ),
                                          FilterChip(
                                            label: const Text('Auto Increment'),
                                            selected: isAutoIncrement,
                                            onSelected: (value) {
                                              setState(() {
                                                isAutoIncrement = value;
                                              });
                                            },
                                            avatar: isAutoIncrement
                                                ? const Icon(Icons.check,
                                                    size: 16)
                                                : null,
                                          ),
                                          FilterChip(
                                            label: const Text('Unique'),
                                            selected: isUnique,
                                            onSelected: (value) {
                                              setState(() {
                                                isUnique = value;
                                              });
                                            },
                                            avatar: isUnique
                                                ? const Icon(Icons.check,
                                                    size: 16)
                                                : null,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Center(
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.add),
                                          label: const Text('Add Field'),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (fieldNameController
                                                    .text.isNotEmpty &&
                                                selectedFieldType != null) {
                                              setState(() {
                                                collectionShema.add({
                                                  'name':
                                                      fieldNameController.text,
                                                  'type': selectedFieldType,
                                                  'nullable': isNullable,
                                                  'autoIncrement':
                                                      isAutoIncrement,
                                                  'unique': isUnique,
                                                });

                                                // Reset form
                                                fieldNameController.clear();
                                                selectedFieldType = null;
                                                isNullable = false;
                                                isAutoIncrement = false;
                                                isUnique = false;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Expanded(
                                child: Card(
                                  elevation: 1,
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Fields',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                collectionShema.length
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(height: 1),
                                      Expanded(
                                        child: collectionShema.isEmpty
                                            ? Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.view_list,
                                                        size: 48,
                                                        color: Colors
                                                            .grey.shade400),
                                                    const SizedBox(height: 16),
                                                    Text(
                                                      'No Fields added yet',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : ListView.separated(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                itemCount:
                                                    collectionShema.length,
                                                separatorBuilder: (_, __) =>
                                                    const Divider(height: 1),
                                                itemBuilder: (context, index) {
                                                  final field =
                                                      collectionShema[index];
                                                  return ListTile(
                                                    title: Text(
                                                      field['name'],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    subtitle: Text(
                                                        '${field['type']} ' +
                                                            [
                                                              if (field[
                                                                  'nullable'])
                                                                'nullable',
                                                              if (field[
                                                                  'unique'])
                                                                'unique',
                                                              if (field[
                                                                  'autoIncrement'])
                                                                'auto increment'
                                                            ].join(', ')),
                                                    trailing: IconButton(
                                                      icon: const Icon(
                                                          Icons.delete_outline,
                                                          color: Colors.red),
                                                      onPressed: () {
                                                        setState(() {
                                                          collectionShema
                                                              .removeAt(index);
                                                        });
                                                      },
                                                      tooltip: 'Remove field',
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Implement collection creation logic
                                      if (collectionNameController
                                              .text.isNotEmpty &&
                                          collectionShema.isNotEmpty) {
                                        // Add your collection creation logic here

                                        // collectionShema.forEach((field) {
                                        // field['id'] = DateTime.now().millisecondsSinceEpoch.toString();
                                        // field['createdAt'] = DateTime.now().toIso8601String();
                                        // field['updatedAt'] = DateTime.now().toIso8601String();
                                        // field['isDeleted'] = false;
                                        //  });

                                        List<Map<String, dynamic>> documents =
                                            [];

                                        documents.add({
                                          'id': DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          'createdAt':
                                              DateTime.now().toIso8601String(),
                                          'updatedAt':
                                              DateTime.now().toIso8601String(),
                                          'isDeleted': false,
                                        });

                                        widget.mockFirestore[
                                            collectionNameController.text] = [];
                                        setState(() {
                                          widget.onCollectionSelected(
                                              collectionNameController.text);
                                        });
                                        print(collectionShema);
                                        Navigator.of(context).pop();
                                      } else {
                                        // Show error message if collection name is empty or no collectionShema are added
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                'Please enter a collection name and add at least one field.'),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Create Collection'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  Icon(Icons.add, size: 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Start collection',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: widget.mockFirestore.keys.map((collectionName) {
                  return _buildCollectionItem(
                    collectionName,
                    isSelected: widget.selectedCollection == collectionName,
                    onTap: () => widget.onCollectionSelected(collectionName),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCollectionItem(String name,
      {bool isSelected = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Text(
              name,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
