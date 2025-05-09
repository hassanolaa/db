import 'package:flutter/material.dart';

class DocumentDetailsPanel extends StatelessWidget {
  final String? selectedDocId;
  final String selectedCollection;
  final Map<String, dynamic>? document;

  const DocumentDetailsPanel({
    Key? key,
    required this.selectedDocId,
    required this.selectedCollection,
    required this.document,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (selectedCollection.isEmpty ||
        selectedDocId == null ||
        document == null ||
        document!.isEmpty) {
      return const Card(
        margin: EdgeInsets.only(right: 8),
        elevation: 0,
        child: Center(child: Text('Select a document')),
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
                const Icon(Icons.description, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedDocId!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: document!.entries.map((entry) {
                if (entry.key == 'id') return const SizedBox.shrink();
                return _buildFieldItem(entry.key, entry.value);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldItem(String key, dynamic value) {
    if (value is Map) {
      return _buildExpandableField(
          key,
          value.entries
              .map((e) => _buildNestedFieldItem(e.key, e.value))
              .toList());
    } else if (value is List) {
      return _buildExpandableField(
          key,
          value
              .asMap()
              .entries
              .map((e) => _buildNestedFieldItem(e.key.toString(), e.value))
              .toList());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$key: ', style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value.toString(),
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableField(String name, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.arrow_drop_down, size: 20),
            Text(
              name,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildNestedFieldItem(String index, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            index,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value.toString(),
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
