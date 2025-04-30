import 'package:db/core/shared/shareddata.dart';
import 'package:flutter/material.dart';
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
                 SidebarWidget(onTap: () {
                  setState(() {
                   if (view == 0) {
                      view = 1;
                    } else {
                      view = 0;
                    }
                  });
                 },),
                Expanded(
                  child: 
                  view == 0 ?
                  MainContentWidget(
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
                                  mockFirestore.remove(selectedCollection);
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
                                      .removeWhere(
                                          (doc) => doc['id'] == selectedDocId);
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
                  :KeyValueDatabaseUI(),
                
                ),
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
    
    {'name': 'id', 'type': 'String', 'nullable': false, 'autoIncrement': true, 'unique': false}, 
    {'name': 'name', 'type': 'String', 'nullable': false,'autoIncrement': false, 'unique': false}, 
    {'name': 'Date', 'type': 'Date', 'nullable': false,'autoIncrement': false, 'unique': false}, 

    
  ],
  'Users': [
    {'name': 'id', 'type': 'String', 'nullable': false, 'autoIncrement': false, 'unique': true},
    {'name': 'username', 'type': 'String', 'nullable': false, 'autoIncrement': false, 'unique': false},
    {'name': 'age', 'type': 'Number', 'nullable': true, 'autoIncrement': false, 'unique': false},
    {'name': 'isActive', 'type': 'Boolean', 'nullable': true, 'autoIncrement': false, 'unique': false},
    {'name': 'joinedAt', 'type': 'Date', 'nullable': true, 'autoIncrement': false, 'unique': false},
    {'name': 'hobbies', 'type': '[String]', 'nullable': true, 'autoIncrement': false, 'unique': false},
    {'name': 'profile', 'type': 'Map', 'nullable': true,'autoIncrement': false, 'unique': false  },
   
  ],
  'Products': [
    {'name': 'id', 'type': 'String', 'nullable': false, 'autoIncrement': false, 'unique': true},
    {'name': 'name', 'type': 'String', 'nullable': false, 'autoIncrement': false, 'unique': false},
    {'name': 'price', 'type': 'Number', 'nullable': true, 'autoIncrement': false, 'unique': false},
    {'name': 'inStock', 'type': 'Boolean', 'nullable': true, 'autoIncrement': false, 'unique': false},
    {'name': 'tags', 'type': '[String]', 'nullable': true, 'autoIncrement': false, 'unique': false},
    {'name': 'addedOn', 'type': 'Date','nullable': true, 'autoIncrement': false, 'unique': false  },
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
    'test':[]
  };




class KeyValueDatabaseUI extends StatefulWidget {
  const KeyValueDatabaseUI({super.key});

  @override
  State<KeyValueDatabaseUI> createState() => _KeyValueDatabaseUIState();
}

class _KeyValueDatabaseUIState extends State<KeyValueDatabaseUI> {
  final ValueNotifier<Map<String, dynamic>> kvStore = ValueNotifier({});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key-Value Store',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          KeyValueInputWidget(
            fieldName: 'Add Entry',
            isNullable: false,
            initialValue: const {},
            onChanged: (newMap) {
              kvStore.value = Map.from(newMap); // Update the main store
            },
            validator: (map) {
              if (map.length < 1) return 'At least one key-value pair required';
              return null;
            },
          ),
          const SizedBox(height: 24),
          const Text('Stored Values:', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: kvStore,
              builder: (context, store, _) {
                if (store.isEmpty) {
                  return Center(
                    child: Text('No entries yet',
                        style: TextStyle(color: Colors.grey[600])),
                  );
                }

                return ListView.separated(
                  itemCount: store.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final key = store.keys.elementAt(index);
                    final value = store[key];
                    return ListTile(
                      title: Text('$key'),
                      subtitle: Text('$value (${value.runtimeType})'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          setState(() {
                            store.remove(key);
                            kvStore.value = Map.from(store); // notify change
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class KeyValueInputWidget extends StatefulWidget {
  final String fieldName;
  final bool isNullable;
  final Map<String, dynamic> initialValue;
  final void Function(Map<String, dynamic>) onChanged;
  final String? Function(Map<String, dynamic>)? validator;

  const KeyValueInputWidget({
    super.key,
    required this.fieldName,
    required this.onChanged,
    this.isNullable = true,
    this.initialValue = const {},
    this.validator,
  });

  @override
  State<KeyValueInputWidget> createState() => _KeyValueInputWidgetState();
}

class _KeyValueInputWidgetState extends State<KeyValueInputWidget> {
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _pairs;
  String? _errorText;
  String _selectedValueType = 'String';  // Default value type is String

  @override
  void initState() {
    super.initState();
    _pairs = Map.of(widget.initialValue);
  }

  void _addPair() {
    final key = _keyController.text.trim();
    final valueStr = _valueController.text.trim();

    if (key.isEmpty || valueStr.isEmpty) return;

    dynamic value;

    // Convert value based on selected type
    switch (_selectedValueType) {
      case 'String':
        value = valueStr;
        break;
      case 'Number':
        value = double.tryParse(valueStr);
        if (value == null) {
          _showSnackbar('Value must be a valid number');
          return;
        }
        break;
      case 'Boolean':
        value = valueStr.toLowerCase() == 'true';
        break;
      default:
        _showSnackbar('Unsupported value type');
        return;
    }

    // Check if key already exists
    if (_pairs.containsKey(key)) {
      _showSnackbar('Key "$key" already exists.');
      return;
    }

    setState(() {
      _pairs[key] = value;
      _keyController.clear();
      _valueController.clear();
      widget.onChanged(_pairs);
      _validate();
    });
  }

  void _removePair(String key) {
    setState(() {
      _pairs.remove(key);
      widget.onChanged(_pairs);
      _validate();
    });
  }

  void _editPair(String key, dynamic value) {
    _keyController.text = key;
    _valueController.text = value.toString();
    _removePair(key);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.orange),
    );
  }

  void _validate() {
    if (!widget.isNullable && _pairs.isEmpty) {
      setState(() => _errorText =
          'Please add at least one key-value pair for ${widget.fieldName}');
    } else {
      setState(() => _errorText = widget.validator?.call(_pairs));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(theme),
        const SizedBox(height: 8),
        _buildChips(theme),
        const SizedBox(height: 8),
        _buildValueTypeSelector(theme),
        const SizedBox(height: 8),
        _buildForm(theme),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _errorText!,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.tune, color: theme.colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(widget.fieldName,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const Spacer(),
        Text('${_pairs.length} items', style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildChips(ThemeData theme) {
    if (_pairs.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.layers_outlined,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
            const SizedBox(height: 8),
            Text('No key-value pairs added yet',
                style: theme.textTheme.bodyMedium),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: _pairs.entries.map((e) {
        return InkWell(
          onTap: () => _editPair(e.key, e.value),
          child: Chip(
            label: Text('${e.key}: ${e.value}'),
            deleteIcon: const Icon(Icons.close),
            onDeleted: () => _removePair(e.key),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildValueTypeSelector(ThemeData theme) {
    return DropdownButton<String>(
      value: _selectedValueType,
      onChanged: (value) {
        setState(() {
          _selectedValueType = value!;
        });
      },
      items: ['String', 'Number', 'Boolean'].map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      isExpanded: true,
      hint: Text('Select Value Type'),
    );
  }

  Widget _buildForm(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _keyController,
              decoration: const InputDecoration(labelText: 'Key'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Key is required' : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: _valueController,
              decoration: const InputDecoration(labelText: 'Value'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Value is required' : null,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _addPair();
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}

