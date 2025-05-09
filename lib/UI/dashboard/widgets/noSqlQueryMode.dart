import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../screens/dashboard.dart';

class NoSqlQueryMode extends StatefulWidget {
  @override
  State<NoSqlQueryMode> createState() => _NoSqlQueryModeState();
}

class _NoSqlQueryModeState extends State<NoSqlQueryMode> {
  String selectedCollection = '';
  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  List<Map<String, dynamic>> queryResults = [];
  bool isLoading = false;
  bool hasExecutedQuery = false;
  // List of supported operators
  final List<String> operators = [
    '==',
    '>',
    '>=',
    '<',
    '<=',
    'contains',
    'startsWith',
    'endsWith',
    'hasKey',
    'hasLength'
  ];

  String selectedOperator = '==';

  // For advanced query options
  bool useLimit = false;
  bool sortResults = false;
  String sortField = '';
  bool sortAscending = true;

  // For combined queries
  List<Map<String, dynamic>> queryConditions = [];

  @override
  void dispose() {
    _fieldNameController.dispose();
    _valueController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  void addQueryCondition() {
    if (_fieldNameController.text.isEmpty || _valueController.text.isEmpty) {
      _showSnackBar('Please fill all fields for the query condition');
      return;
    }

    final condition = {
      'field': _fieldNameController.text.trim(),
      'operator': selectedOperator,
      'value': _parseValue(_valueController.text.trim()),
    };

    setState(() {
      queryConditions.add(condition);
      _fieldNameController.clear();
      _valueController.clear();
    });

    HapticFeedback.lightImpact();
  }

  void removeCondition(int index) {
    setState(() {
      queryConditions.removeAt(index);
    });
    HapticFeedback.lightImpact();
  }

  // Parse the value based on likely type
  dynamic _parseValue(String value) {
    // Check if value is a number
    if (RegExp(r'^-?\d+(\.\d+)?$').hasMatch(value)) {
      return value.contains('.') ? double.parse(value) : int.parse(value);
    }

    // Check if value is a boolean
    if (value.toLowerCase() == 'true') return true;
    if (value.toLowerCase() == 'false') return false;

    // Check if value is a list (comma-separated values)
    if (value.startsWith('[') && value.endsWith(']')) {
      final listContent = value.substring(1, value.length - 1);
      return listContent.split(',').map((e) => e.trim()).toList();
    }

    // Check if value is a map/object (JSON-like format)
    if (value.startsWith('{') && value.endsWith('}')) {
      try {
        final mapContent = value.substring(1, value.length - 1);
        final pairs = mapContent.split(',');
        final resultMap = <String, dynamic>{};

        for (var pair in pairs) {
          final keyValue = pair.split(':');
          if (keyValue.length == 2) {
            final key = keyValue[0].trim();
            final val = _parseValue(
                keyValue[1].trim()); // Recursive parsing for nested values
            resultMap[key] = val;
          }
        }
        return resultMap;
      } catch (e) {
        // If there's an error parsing as map, return as string
        return value;
      }
    }

    // Default to string
    return value;
  }

  void executeQuery() {
    if (selectedCollection.isEmpty) {
      _showSnackBar('Please select a collection');
      return;
    }

    // Removed the condition check to allow querying without conditions

    setState(() {
      isLoading = true;
      hasExecutedQuery = true;
    });

    // Delay to show loading animation
    Future.delayed(const Duration(milliseconds: 300), () {
      final collection = mockFirestore[selectedCollection] ?? [];
      final results = _executeQueryOnCollection(collection);

      setState(() {
        queryResults = results;
        isLoading = false;
      });

      HapticFeedback.mediumImpact();
    });
  }

  List<Map<String, dynamic>> _executeQueryOnCollection(
      List<Map<String, dynamic>> collection) {
    List<Map<String, dynamic>> results = List.from(collection);

    // Apply all conditions if there are any
    if (queryConditions.isNotEmpty) {
      for (var condition in queryConditions) {
        final field = condition['field'] as String;
        final operator = condition['operator'] as String;
        final value = condition['value'];

        results = results.where((doc) {
          // Handle nested fields with dot notation
          final fieldParts = field.split('.');
          dynamic fieldValue = doc;

          for (var part in fieldParts) {
            if (fieldValue is Map) {
              fieldValue = fieldValue[part];
            } else {
              return false; // Field path doesn't exist
            }
          } // Apply the operator
          switch (operator) {
            case '==':
              return fieldValue == value;
            case '>':
              return fieldValue != null && fieldValue > value;
            case '>=':
              return fieldValue != null && fieldValue >= value;
            case '<':
              return fieldValue != null && fieldValue < value;
            case '<=':
              return fieldValue != null && fieldValue <= value;
            case 'contains':
              if (fieldValue is String && value is String) {
                // String contains text
                return fieldValue.contains(value);
              } else if (fieldValue is List) {
                // List contains element or at least one matching item
                if (value is List) {
                  // Check if any item in value list exists in fieldValue list
                  return value.any((item) => fieldValue.contains(item));
                } else {
                  // Check if single value exists in list
                  return fieldValue.contains(value);
                }
              } else if (fieldValue is Map) {
                // Map contains key
                if (value is String) {
                  return fieldValue.containsKey(value);
                } else if (value is Map) {
                  // Check if map contains all key-value pairs in value map
                  return value.entries.every((entry) =>
                      fieldValue.containsKey(entry.key) &&
                      fieldValue[entry.key] == entry.value);
                }
              }
              return false;
            case 'startsWith':
              if (fieldValue is String && value is String) {
                return fieldValue.startsWith(value);
              } else if (fieldValue is List && fieldValue.isNotEmpty) {
                // Check if first element matches (for list)
                return fieldValue.first.toString().startsWith(value.toString());
              }
              return false;
            case 'endsWith':
              if (fieldValue is String && value is String) {
                return fieldValue.endsWith(value);
              } else if (fieldValue is List && fieldValue.isNotEmpty) {
                // Check if last element matches (for list)
                return fieldValue.last.toString().endsWith(value.toString());
              }
              return false;
            case 'hasKey':
              // Special operator for Maps
              if (fieldValue is Map && value is String) {
                return fieldValue.containsKey(value);
              }
              return false;
            case 'hasLength':
              // For checking length of lists or maps
              if (value is int) {
                if (fieldValue is List) {
                  return fieldValue.length == value;
                } else if (fieldValue is Map) {
                  return fieldValue.length == value;
                } else if (fieldValue is String) {
                  return fieldValue.length == value;
                }
              }
              return false;
            default:
              return false;
          }
        }).toList();
      }
    }

    // Apply sorting if needed
    if (sortResults && sortField.isNotEmpty) {
      results.sort((a, b) {
        final aValue = a[sortField];
        final bValue = b[sortField];

        if (aValue == null && bValue == null) return 0;
        if (aValue == null) return sortAscending ? -1 : 1;
        if (bValue == null) return sortAscending ? 1 : -1;

        int comparison;
        if (aValue is num && bValue is num) {
          comparison = aValue.compareTo(bValue);
        } else if (aValue is String && bValue is String) {
          comparison = aValue.compareTo(bValue);
        } else if (aValue is bool && bValue is bool) {
          comparison = aValue == bValue ? 0 : (aValue ? 1 : -1);
        } else {
          comparison = 0;
        }

        return sortAscending ? comparison : -comparison;
      });
    }

    // Apply limit
    if (useLimit && _limitController.text.isNotEmpty) {
      final limit = int.tryParse(_limitController.text) ?? results.length;
      if (limit < results.length) {
        results = results.take(limit).toList();
      }
    }

    return results;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildQueryBuilder(context),
              const SizedBox(height: 16),
              _buildQueryConditions(context),
              const SizedBox(height: 16),
              _buildAdvancedOptions(context),
              const SizedBox(height: 16),
              _buildExecuteQueryButton(context),
              const SizedBox(height: 24),
              const Text('Query Results:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(height: 16),
              _buildResults(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.indigo,
                    Colors.purple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NoSQL Query Mode',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                Text(
                  'Build and execute custom queries',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
        _buildCollectionSelector(context),
      ],
    );
  }

  Widget _buildCollectionSelector(BuildContext context) {
    final collections = mockFirestore.keys.toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCollection.isEmpty ? null : selectedCollection,
          hint: const Text('Select Collection'),
          items: collections.map((String collection) {
            return DropdownMenuItem<String>(
              value: collection,
              child: Row(
                children: [
                  Icon(
                    Icons.folder_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(collection),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedCollection = newValue;
                // Reset results when collection changes
                queryResults = [];
                hasExecutedQuery = false;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildQueryBuilder(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Build Query',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Tooltip(
                  message:
                      'For map fields, use profile.bio syntax.\nFor list fields, use contains or hasLength operator.\nFor map fields, use hasKey operator.',
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Query Help'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildHelpSection('Map Fields',
                                    'Use dot notation (e.g., profile.bio) to query nested fields in maps.\nUse hasKey operator to check if a map contains a specific key.'),
                                const Divider(),
                                _buildHelpSection('List Fields',
                                    'Use contains operator to check if a list contains a value.\nUse hasLength to check list length.\nUse startsWith/endsWith to check first/last item.'),
                                const Divider(),
                                _buildHelpSection('Advanced',
                                    'For map values, enter in format: {key:value,key2:value2}\nFor list values, enter in format: [item1,item2,item3]'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.help_outline, size: 18),
                    label: const Text('Help'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _fieldNameController,
                    decoration: InputDecoration(
                      labelText: 'Field Name',
                      hintText: 'e.g., username or profile.bio',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.label_outline),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 140,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedOperator,
                      items: operators.map((String op) {
                        return DropdownMenuItem<String>(
                          value: op,
                          child: Text(op),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedOperator = newValue;
                          });
                        }
                      },
                      isExpanded: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _valueController,
                    decoration: InputDecoration(
                      labelText: 'Value',
                      hintText: 'Enter value to compare',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.compare),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: addQueryCondition,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text('Add Condition'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueryConditions(BuildContext context) {
    if (queryConditions.isEmpty) {
      return Card(
        elevation: 1,
        color: Theme.of(context).colorScheme.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Text(
            'No query conditions added yet',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Active Conditions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: List.generate(queryConditions.length, (index) {
                final condition = queryConditions[index];
                final field = condition['field'];
                final operator = condition['operator'];
                final value = condition['value'];

                return Chip(
                  label: Text('$field $operator $value'),
                  deleteIcon: const Icon(Icons.close_rounded, size: 18),
                  onDeleted: () => removeCondition(index),
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 1,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedOptions(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Text(
          'Advanced Options',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        leading: const Icon(Icons.tune),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Row(
            children: [
              // Limit results option
              Expanded(
                child: CheckboxListTile(
                  value: useLimit,
                  title: const Text('Limit Results'),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? value) {
                    setState(() {
                      useLimit = value ?? false;
                    });
                  },
                ),
              ),
              // Limit input field
              if (useLimit) ...[
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: _limitController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Limit',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],

              // Sort results option
              Expanded(
                child: CheckboxListTile(
                  value: sortResults,
                  title: const Text('Sort Results'),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? value) {
                    setState(() {
                      sortResults = value ?? false;
                    });
                  },
                ),
              ),
            ],
          ),
          if (sortResults) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Sort by Field',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        sortField = value.trim();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<bool>(
                  value: sortAscending,
                  items: const [
                    DropdownMenuItem(
                      value: true,
                      child: Text('Ascending'),
                    ),
                    DropdownMenuItem(
                      value: false,
                      child: Text('Descending'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      sortAscending = value!;
                    });
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExecuteQueryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: executeQuery, // Allow execution without conditions
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.play_arrow_rounded),
        label: Text(
          isLoading ? 'Processing...' : 'Execute Query',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!hasExecutedQuery) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search,
                size: 50,
                color: Colors.indigo.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Build and execute a query to see results',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    if (queryResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 50,
                color: Colors.orange.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No results match your query',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${queryResults.length} Results',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Export results or copy to clipboard functionality
                    final resultsStr =
                        queryResults.map((e) => e.toString()).join('\n\n');
                    Clipboard.setData(ClipboardData(text: resultsStr));
                    _showSnackBar('Results copied to clipboard');
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy'),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            ...queryResults.asMap().entries.map((entry) {
              final index = entry.key;
              final doc = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: index % 2 == 0
                      ? Colors.grey.withOpacity(0.05)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
                child: ExpansionTile(
                  title: Text(
                    doc['id'] != null
                        ? 'Document: ${doc['id']}'
                        : 'Document #${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    doc.keys
                        .take(3)
                        .map((k) => '$k: ${_formatValue(doc[k])}')
                        .join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                              .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: doc.entries.map<Widget>((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    '${entry.key}:',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 3,
                                  child: _buildValueWidget(entry.value),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  String _formatValue(dynamic value) {
    if (value is DateTime) {
      return value.toString().split('.').first;
    }
    if (value is List) {
      return '[...]';
    }
    if (value is Map) {
      return '{...}';
    }
    return value.toString();
  }

  Widget _buildValueWidget(dynamic value) {
    if (value == null) {
      return const Text('null',
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey));
    }

    if (value is String) {
      return Text('"$value"');
    }

    if (value is DateTime) {
      return Text(
        value.toString().split('.').first,
        style: TextStyle(color: Colors.green.shade800),
      );
    }

    if (value is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('['),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: value
                  .map<Widget>((item) => Text(_formatValue(item)))
                  .toList(),
            ),
          ),
          const Text(']'),
        ],
      );
    }

    if (value is Map) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('{'),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: value.entries
                  .map<Widget>(
                      (e) => Text('${e.key}: ${_formatValue(e.value)}'))
                  .toList(),
            ),
          ),
          const Text('}'),
        ],
      );
    }

    // Numbers and booleans
    if (value is num) {
      return Text(value.toString(),
          style: TextStyle(color: Colors.blue.shade800));
    }

    if (value is bool) {
      return Text(
        value.toString(),
        style: TextStyle(
          color: value ? Colors.green.shade800 : Colors.red.shade800,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Text(value.toString());
  }
}
