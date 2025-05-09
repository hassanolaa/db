import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/services.dart'; // For HapticFeedback

class KeyValueDatabaseUI extends StatefulWidget {
  const KeyValueDatabaseUI({super.key});

  @override
  State<KeyValueDatabaseUI> createState() => _KeyValueDatabaseUIState();
}

class _KeyValueDatabaseUIState extends State<KeyValueDatabaseUI> {
  final ValueNotifier<Map<String, dynamic>> kvStore = ValueNotifier({});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.storage_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Key-Value Store',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onBackground,
                                ),
                          ),
                          Text(
                            'Store and manage data pairs',
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.7),
                                    ),
                          ),
                        ],
                      ),
                    ],
                   
                  ),
                Row(
                  children: [
                     GestureDetector(
                                onTap: () {
                                 // show add new entry dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Container(
                                          width: 500,
                                          height: 300,
                                          child: KeyValueInputWidget(
                                            fieldName: 'Add Entry',
                                            isNullable: false,
                                            initialValue: const {},
                                            onChanged: (newMap) {
                                              kvStore.value = Map.from(newMap);
                                              HapticFeedback.lightImpact();
                                            },
                                            validator: (map) {
                                              if (map.length < 1)
                                                return 'At least one key-value pair required';
                                              return null;
                                            },
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                       child: Container(
                                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                 decoration: BoxDecoration(
                                   color: Colors.blue,
                                   borderRadius: BorderRadius.circular(4),
                                 ),
                                 child: Row(
                                   children: const [
                                     Icon(Icons.add_box_outlined, size: 16, color: Colors.white),
                                     SizedBox(width: 8),
                                     Text(
                                       'Add New Entry',
                                       style: TextStyle(color: Colors.white),
                                     ),
                                 
                                   ],
                                 ),
                               ),
                     ),
                      const SizedBox(width: 16),
                     Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Switch to Query Mode',
                  style: TextStyle(color: Colors.white),
                ),
            
              ],
            ),
          ),
                  ],
                )
                ],
              ),
              const SizedBox(height: 24),
              // Card(
              //   elevation: 2,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(16),
              //     child: KeyValueInputWidget(
              //       fieldName: 'Add Entry',
              //       isNullable: false,
              //       initialValue: const {},
              //       onChanged: (newMap) {
              //         kvStore.value = Map.from(newMap); // Update the main store
              //         HapticFeedback.lightImpact(); // Provide tactile feedback
              //       },
              //       validator: (map) {
              //         if (map.length < 1)
              //           return 'At least one key-value pair required';
              //         return null;
              //       },
              //     ),
              //   ),
              // ),
              const SizedBox(height: 24),
              const Text('Stored Values:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 16),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: kvStore,
                  builder: (context, store, _) {
                    if (store.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Icon(
                                Icons.inventory_2_outlined,
                                size: 60,
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No entries yet',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add your first key-value pair above',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: store.length,
                      itemBuilder: (context, index) {
                        final key = store.keys.elementAt(index);
                        final value = store[key];


                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                // Show details or edit dialog
                                HapticFeedback.selectionClick();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Color(
                                                (math.Random().nextDouble() *
                                                        0xFFFFFF)
                                                    .toInt())
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        value is List? Icons.list: value is int? Icons.numbers : value is String ? Icons.text_fields_sharp:Icons.key,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$key',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            value is List
                                                ? '[${value.join(', ')}] (List<${value.isNotEmpty ? value.first.runtimeType : 'dynamic'}>)'
                                                : '$value (${value.runtimeType})',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.7),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outlined),
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      onPressed: () {
                                        HapticFeedback.mediumImpact();
                                        setState(() {
                                          store.remove(key);
                                          kvStore.value =
                                              Map.from(store); // notify change
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
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
  String _selectedValueType = 'String'; // Default type
  String _selectedArrayElementType = 'String'; // For Array element types

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
      case 'Array':
        final rawItems = valueStr
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        switch (_selectedArrayElementType) {
          case 'int':
            value = rawItems.map(int.tryParse).toList();
            if (value.contains(null)) {
              _showSnackbar('All array elements must be valid integers');
              return;
            }
            break;
          case 'double':
            value = rawItems.map(double.tryParse).toList();
            if (value.contains(null)) {
              _showSnackbar('All array elements must be valid numbers');
              return;
            }
            break;
          case 'bool':
            value = rawItems.map((e) {
              final lower = e.toLowerCase();
              if (lower == 'true' || lower == 'false') {
                return lower == 'true';
              }
              return null;
            }).toList();
            if (value.contains(null)) {
              _showSnackbar('All array elements must be true or false');
              return;
            }
            break;
          case 'String':
          default:
            value = rawItems;
            break;
        }
        break;
      default:
        _showSnackbar('Unsupported value type');
        return;
    }

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
    if (value is List) {
      _valueController.text = value.join(', ');
      _selectedValueType = 'Array';
      if (value.isNotEmpty) {
        final type = value.first.runtimeType;
        if (type == int) {
          _selectedArrayElementType = 'int';
        } else if (type == double) {
          _selectedArrayElementType = 'double';
        } else if (type == bool) {
          _selectedArrayElementType = 'bool';
        } else {
          _selectedArrayElementType = 'String';
        }
      }
    } else {
      _valueController.text = value.toString();
      if (value is double || value is int) {
        _selectedValueType = 'Number';
      } else if (value is bool) {
        _selectedValueType = 'Boolean';
      } else {
        _selectedValueType = 'String';
      }
    }
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
        _buildValueTypeSelector(),
        _buildArrayElementTypeSelector(),
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
      runSpacing: 8,
      children: _pairs.entries.map((e) {
        final displayValue =
            e.value is List ? '[${e.value.join(', ')}]' : e.value.toString();

        final Color chipColor = e.value is bool
            ? theme.colorScheme.tertiaryContainer
            : e.value is num
                ? theme.colorScheme.secondaryContainer
                : e.value is List
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceVariant;

        return InkWell(
          onTap: () => _editPair(e.key, e.value),
          borderRadius: BorderRadius.circular(16),
          child: Chip(
            label: Text(
              '${e.key}: $displayValue',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            deleteIcon: Icon(
              Icons.close_rounded,
              size: 18,
              color: theme.colorScheme.error,
            ),
            onDeleted: () => _removePair(e.key),
            backgroundColor: chipColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: chipColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildValueTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedValueType,
          onChanged: (value) {
            setState(() {
              _selectedValueType = value!;
            });
          },
          items: ['String', 'Number', 'Boolean', 'Array'].map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Row(
                children: [
                  Icon(
                    type == 'String'
                        ? Icons.text_fields
                        : type == 'Number'
                            ? Icons.numbers
                            : type == 'Boolean'
                                ? Icons.check_circle_outline
                                : Icons.list_alt,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(type),
                ],
              ),
            );
          }).toList(),
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.primary),
          hint: const Text('Select Value Type'),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildArrayElementTypeSelector() {
    if (_selectedValueType != 'Array') return const SizedBox.shrink();

    return DropdownButton<String>(
      value: _selectedArrayElementType,
      onChanged: (value) {
        setState(() {
          _selectedArrayElementType = value!;
        });
      },
      items: ['String', 'int', 'double', 'bool'].map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      isExpanded: true,
      hint: const Text('Select Array Element Type'),
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
              decoration: InputDecoration(
                labelText: 'Key',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: theme.colorScheme.primary.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                prefixIcon: Icon(Icons.key,
                    color: theme.colorScheme.primary.withOpacity(0.7)),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Key is required' : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: _valueController,
              decoration: InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: theme.colorScheme.primary.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                prefixIcon: Icon(Icons.data_object,
                    color: theme.colorScheme.primary.withOpacity(0.7)),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Value is required' : null,
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _addPair();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
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
