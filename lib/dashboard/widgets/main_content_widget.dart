import 'package:flutter/material.dart';
import 'breadcrumbs_widget.dart';
import 'collections_panel_widget.dart';
import 'documents_panel_widget.dart';
import 'document_details_panel_widget.dart';

class MainContentWidget extends StatelessWidget {
  final String selectedSection;
  final String selectedCollection;
  final String? selectedDocId;
  final Map<String, List<Map<String, dynamic>>> mockFirestore;
  final Function(String) onCollectionSelected;
  final Function(String) onDocumentSelected;
  final VoidCallback onDeleteCollection;
  final VoidCallback onDeleteDocument;

  const MainContentWidget({
    Key? key,
    required this.selectedSection,
    required this.selectedCollection,
    required this.selectedDocId,
    required this.mockFirestore,
    required this.onCollectionSelected,
    required this.onDocumentSelected,
    required this.onDeleteCollection,
    required this.onDeleteDocument,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: [
          BreadcrumbsWidget(selectedSection: selectedSection),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildDatabaseContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatabaseContent() {
    // Get the currently selected document
    Map<String, dynamic>? selectedDocument;
    if (selectedCollection.isNotEmpty && selectedDocId != null) {
      final documents = mockFirestore[selectedCollection];
      if (documents != null) {
        selectedDocument = documents.firstWhere(
          (doc) => doc['id'] == selectedDocId,
          orElse: () => {},
        );
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 1,
          child: CollectionsPanel(
            mockFirestore: mockFirestore,
            selectedCollection: selectedCollection,
            onCollectionSelected: onCollectionSelected,
            onDeleteCollection: onDeleteCollection,
          ),
        ),
        Expanded(
          flex: 1,
          child: DocumentsPanel(
            selectedCollection: selectedCollection,
            documents: selectedCollection.isNotEmpty
                ? mockFirestore[selectedCollection]
                : null,
            selectedDocId: selectedDocId,
            onDocumentSelected: onDocumentSelected,
            onDeleteDocument: onDeleteDocument,
          ),
        ),
        Expanded(
          flex: 1,
          child: DocumentDetailsPanel(
            selectedCollection: selectedCollection,
            selectedDocId: selectedDocId,
            document: selectedDocument,
          ),
        ),
      ],
    );
  }
}
