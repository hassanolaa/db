import 'dart:math';

import 'package:db/UI/dashboard/screens/dashboard.dart';
import 'package:flutter/material.dart';

class DocumentsPanel extends StatelessWidget {
  final String selectedCollection;
  final List<Map<String, dynamic>>? documents;
  final String? selectedDocId;
  final Function(String) onDocumentSelected;
  final VoidCallback onDeleteDocument;

  const DocumentsPanel({
    Key? key,
    required this.selectedCollection,
    required this.documents,
    required this.selectedDocId,
    required this.onDocumentSelected,
    required this.onDeleteDocument,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedCollection.isEmpty || documents == null) {
      return const Card(
        margin: EdgeInsets.only(right: 8),
        elevation: 0,
        child: Center(child: Text('Select a collection')),
      );
    }

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
                const Icon(Icons.table_rows, size: 20),
                const SizedBox(width: 8),
                Text(
                  selectedCollection,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onDeleteDocument,
                  child: const Icon(Icons.more_vert, size: 20),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => {
              // show dialog to create new document
              showDialog(
                context: context,
                builder: (context) {
                  // Controllers for managing form inputs
                  final docIdController = TextEditingController();
                  // Track all field values in a map
                  final Map<String, dynamic> documentValues = {};
                  // Use a single form key for the entire form
                  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

                  final collectionSchema = databaseSchemas[selectedCollection]
                      as List<Map<String, dynamic>>;

                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          constraints: BoxConstraints(
                            maxWidth: 720,
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.85,
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Header with blurred background
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.note_add_rounded,
                                        size: 32,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'New Document',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Collection: $selectedCollection',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            shape: BoxShape.circle,
                                          ),
                                          child:
                                              const Icon(Icons.close, size: 18),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                                ),

                                // Content area (scrollable)
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Document ID Section
                                        Card(
                                          elevation: 0,
                                          margin: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: BorderSide(
                                                color: Colors.grey.shade200),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.key,
                                                        size: 18,
                                                        color: Colors.blue),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Document ID',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    TextButton.icon(
                                                      onPressed: () {
                                                        setState(() {
                                                          docIdController
                                                              .text = DateTime
                                                                  .now()
                                                              .millisecondsSinceEpoch
                                                              .toString();
                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.refresh,
                                                          size: 16),
                                                      label: const Text(
                                                          'Generate'),
                                                      style:
                                                          TextButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .shade100,
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 8),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              )),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                TextFormField(
                                                  controller: docIdController,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Document ID is required';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Enter document identifier',
                                                    prefixIcon: const Icon(
                                                        Icons.fingerprint),
                                                    filled: true,
                                                    fillColor:
                                                        Colors.grey.shade50,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: BorderSide(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 24),

                                        // Fields Section
                                        Text(
                                          'Document Fields',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Fill in the values for each field in the collection',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        // Fields content
                                        collectionSchema.isEmpty
                                            ? Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 40),
                                                  child: Column(
                                                    children: [
                                                      Icon(
                                                          Icons.schema_outlined,
                                                          size: 64,
                                                          color: Colors
                                                              .grey.shade300),
                                                      const SizedBox(
                                                          height: 16),
                                                      Text(
                                                        'No fields defined for this collection',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .grey.shade600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        'Add fields to the collection schema first',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .grey.shade500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    collectionSchema.length,
                                                separatorBuilder: (_, __) =>
                                                    const SizedBox(height: 16),
                                                itemBuilder: (context, index) {
                                                  final field =
                                                      collectionSchema[index];
                                                  final String fieldName =
                                                      field['name'];
                                                  final String fieldType =
                                                      field['type'];
                                                  final bool isNullable =
                                                      field['nullable'] ??
                                                          false;

                                                  // Create controller based on field type
                                                  final controller = TextEditingController();
                                                  bool boolValue = false;

                                                 final ValueNotifier<List<dynamic>> myArrayNotifier = ValueNotifier([]);
                                                  final ValueNotifier<Map<String,dynamic>> myMapNotifier = ValueNotifier({});

                                                  // Store controller for later data collection
                                                  documentValues[fieldName] = {
                                                    'controller': controller,
                                                    'type': fieldType,
                                                    'boolValue': boolValue,
                                                    'array':  myArrayNotifier,
                                                    'map': myMapNotifier,
                                                  };

                                                  return Card(
                                                    elevation: 0,
                                                    margin: EdgeInsets.zero,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .grey.shade200),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              _getFieldTypeIcon(
                                                                  fieldType),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                fieldName,
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        2),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: _getTypeColor(
                                                                          fieldType)
                                                                      .withOpacity(
                                                                          0.1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  border: Border
                                                                      .all(
                                                                    color: _getTypeColor(
                                                                            fieldType)
                                                                        .withOpacity(
                                                                            0.5),
                                                                    width: 1,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  fieldType,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: _getTypeColor(
                                                                        fieldType),
                                                                  ),
                                                                ),
                                                              ),
                                                              if (isNullable)
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 8),
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          2),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade100,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  child: Text(
                                                                    'nullable',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700,
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 12),
                                                          _buildFieldInput(
                                                            fieldType,
                                                            controller,
                                                            fieldName,
                                                            isNullable,
                                                            (value) {
                                                              // For boolean fields
                                                              setState(() {
                                                                documentValues[
                                                                        fieldName]
                                                                    [
                                                                    'boolValue'] = value;
                                                              });
                                                            },
                                                            context,
                                                             myArrayNotifier,
                                                            myMapNotifier,
                                                             
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Footer with actions
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    border: Border(
                                      top: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text('Cancel'),
                                      ),
                                      const SizedBox(width: 16),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.save),
                                        label: const Text('Save Document'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            // Create document object
                                            final Map<String, dynamic>
                                                document = {
                                              'id': docIdController.text,
                                            };
                                            

                                            // Add all field values
                                            documentValues
                                                .forEach((fieldName, data) {
                                                  print('Field: $fieldName, Value: ${data['controller'].text}');
                                               
                                              if (data['type'] == 'Boolean') {
                                                document[fieldName] =
                                                    data['boolValue'];
                                              } else if (data['type'] ==
                                                  'Number') {
                                                document[fieldName] =
                                                    double.tryParse(
                                                            data['controller']
                                                                .text) ??
                                                        0;
                                              } else if (data['type']
                                                  .toString()
                                                  .contains('[')) {
                                                 document[fieldName] = data['array'].value; // Use .value to get the list // Use the array value
                                              }else if (data['type'] == 'Map') {
                                                document[fieldName] = data['map'].value; // Use the map value
                                              } 
                                              else {
                                                document[fieldName] =
                                                    data['controller'].text;
                                              }
                                            });

                                            // Debug output
                                            print('Saving document: $document');

                                            setState(() {
                                              // Add document to the collection
                                              mockFirestore[selectedCollection]!
                                                  .add(document);
                                            });

                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  Icon(Icons.add, size: 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'New Document',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: documents!.map((doc) {
                final id = doc['id'];
                return _buildDocumentItem(
                  id as String,
                  isSelected: selectedDocId == id,
                  onTap: () => onDocumentSelected(id),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String id,
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
            Expanded(
              child: Text(
                id,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            if (isSelected)
              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Widget _getFieldTypeIcon(String type) {
    switch (type) {
      case 'String':
        return const Icon(Icons.text_fields, size: 18, color: Colors.indigo);
      case 'Number':
        return const Icon(Icons.pin, size: 18, color: Colors.green);
      case 'Boolean':
        return const Icon(Icons.toggle_on, size: 18, color: Colors.amber);
      case 'Date':
        return const Icon(Icons.calendar_today, size: 18, color: Colors.orange);
      case 'Map':
        return const Icon(Icons.map, size: 18, color: Colors.purple);
      default:
        if (type.toString().contains('[')) {
          return const Icon(Icons.list, size: 18, color: Colors.teal);
        }
        return const Icon(Icons.data_object, size: 18, color: Colors.blue);
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'String':
        return Colors.indigo;
      case 'Number':
        return Colors.green;
      case 'Boolean':
        return Colors.amber.shade700;
      case 'Date':
        return Colors.orange;
      case 'Map':
        return Colors.purple;
      default:
        if (type.toString().contains('[')) {
          return Colors.teal;
        }
        return Colors.blue;
    }
  }

  Widget _buildFieldInput(
      String type,
      TextEditingController controller,
      String fieldName,
      bool isNullable,
      Function(bool) onBoolChanged,
      BuildContext context,
     ValueNotifier<List<dynamic>> arrayNotifier, 
     ValueNotifier<Map<String,dynamic>> mapNotifier, 
     
     ) {
    switch (type) {
      case 'String':
        return TextFormField(
          controller: controller,
          validator: (value) {
            if (!isNullable && (value == null || value.isEmpty)) {
              return 'Please enter a value for $fieldName';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter text value',
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        );

      case 'Number':
        return TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (!isNullable && (value == null || value.isEmpty)) {
              return 'Please enter a value for $fieldName';
            }
            if (value != null &&
                value.isNotEmpty &&
                double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter numeric value',
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        );

      case 'Boolean':
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Text('Value:'),
              const Spacer(),
              Switch.adaptive(
                value: false,
                onChanged: onBoolChanged,
                activeColor: Colors.blue,
              ),
            ],
          ),
        );

      case 'Date':
        return TextFormField(
          controller: controller,
          readOnly: true,
          validator: (value) {
            if (!isNullable && (value == null || value.isEmpty)) {
              return 'Please select a date for $fieldName';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Select date',
            suffixIcon: const Icon(Icons.calendar_today),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              controller.text = "${pickedDate.toLocal()}".split(' ')[0];
            }
          },
        );

      case 'Map':
        return KeyValueInputWidget(
          fieldName: '$fieldName',
          isNullable: false,
          onChanged: (map) {
            mapNotifier.value = map; // trigger rebuilds if needed
            print('Updated map: $map');
          },
          validator: (map) {
            
          },
        );

      default:
        if (type.toString().contains('[')) {
          return TypedArrayInputWidget(
      fieldName: 'Tags',
      initialValue: arrayNotifier.value,
      onChanged: (list) {
        arrayNotifier.value = List.of(list); // trigger rebuilds if needed
        print('Updated array: ${arrayNotifier.value}');
      },
      validator: (list) {}
          
    );
        }

        // Default case
        return TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter value',
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        );
    }
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





enum ArrayValueType { string, int, double, bool }

class TypedArrayInputWidget extends StatefulWidget {
  final String fieldName;
  final bool isNullable;
  final ArrayValueType initialType;
  final List<dynamic> initialValue;
  final void Function(List<dynamic>) onChanged;
  final String? Function(List<dynamic>)? validator;

  const TypedArrayInputWidget({
    super.key,
    required this.fieldName,
    required this.onChanged,
    this.isNullable = true,
    this.initialType = ArrayValueType.string,
    this.initialValue = const [],
    this.validator,
  });

  @override
  State<TypedArrayInputWidget> createState() => _TypedArrayInputWidgetState();
}

class _TypedArrayInputWidgetState extends State<TypedArrayInputWidget> {
  final _valueController = TextEditingController();
  late ArrayValueType _selectedType;
  late List<dynamic> _values;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _values = List.of(widget.initialValue);
    _validate();
  }

  void _validate() {
    if (!widget.isNullable && _values.isEmpty) {
      setState(() => _errorText = 'Please add at least one value');
    } else {
      setState(() => _errorText = widget.validator?.call(_values));
    }
  }

  dynamic _parseValue(String value) {
    switch (_selectedType) {
      case ArrayValueType.int:
        return int.tryParse(value);
      case ArrayValueType.double:
        return double.tryParse(value);
      case ArrayValueType.bool:
        if (value.toLowerCase() == 'true') return true;
        if (value.toLowerCase() == 'false') return false;
        return null;
      case ArrayValueType.string:
      default:
        return value;
    }
  }

  void _addItem() {
    final raw = _valueController.text.trim();
    if (raw.isEmpty) return;

    final parsed = _parseValue(raw);
    if (parsed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid value for ${_selectedType.name} type'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _values.add(parsed);
      _valueController.clear();
      widget.onChanged(_values);
      _validate();
    });
  }

  void _removeItem(dynamic item) {
    setState(() {
      _values.remove(item);
      widget.onChanged(_values);
      _validate();
    });
  }

  void _clearAll() {
    setState(() {
      _values.clear();
      widget.onChanged(_values);
      _validate();
    });
  }

  Color _getTypeColor(ArrayValueType type) {
    switch (type) {
      case ArrayValueType.string:
        return Colors.indigo;
      case ArrayValueType.int:
        return Colors.green.shade700;
      case ArrayValueType.double:
        return Colors.teal;
      case ArrayValueType.bool:
        return Colors.amber.shade700;
    }
  }

  IconData _getTypeIcon(ArrayValueType type) {
    switch (type) {
      case ArrayValueType.string:
        return Icons.text_fields;
      case ArrayValueType.int:
        return Icons.pin;
      case ArrayValueType.double:
        return Icons.straighten;
      case ArrayValueType.bool:
        return Icons.toggle_on;
    }
  }

  String _getHelperText(ArrayValueType type) {
    switch (type) {
      case ArrayValueType.int:
        return 'Enter a whole number';
      case ArrayValueType.double:
        return 'Enter a decimal number';
      case ArrayValueType.bool:
        return 'Enter true or false';
      case ArrayValueType.string:
      default:
        return 'Enter text';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _getTypeColor(_selectedType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Type selector
        Row(
          children: [
            Icon(_getTypeIcon(_selectedType), size: 20, color: typeColor),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<ArrayValueType>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Array Type',
                  labelStyle: TextStyle(color: typeColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                icon: Icon(Icons.arrow_drop_down, color: typeColor),
                onChanged: (type) {
                  if (_values.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Change Type?'),
                        content: const Text(
                            'Changing the type will clear all current values. Continue?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('CANCEL')),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                _selectedType = type!;
                                _clearAll();
                              });
                            },
                            child: const Text('CONTINUE'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    setState(() => _selectedType = type!);
                  }
                },
                items: ArrayValueType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(_getTypeIcon(type),
                            size: 16, color: _getTypeColor(type)),
                        const SizedBox(width: 8),
                        Text(type.name.toUpperCase()),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Input row
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _valueController,
                decoration: InputDecoration(
                  labelText: 'Value',
                  hintText: 'Enter ${_selectedType.name} value',
                  helperText: _getHelperText(_selectedType),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                onFieldSubmitted: (_) => _addItem(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(backgroundColor: typeColor),
              child: const Text('Add'),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Display items
        if (_values.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_values.length} item(s)',
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              TextButton.icon(
                onPressed: _clearAll,
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Clear All'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _values.map((e) {
              return Chip(
                label: Text(e.toString()),
                avatar: Icon(_getTypeIcon(_selectedType),
                    size: 16, color: typeColor),
                onDeleted: () => _removeItem(e),
              );
            }).toList(),
          ),
        ],

        // Validation error
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_errorText!,
                style: TextStyle(color: theme.colorScheme.error)),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }
}
