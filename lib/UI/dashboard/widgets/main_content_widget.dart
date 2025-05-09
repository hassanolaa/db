import 'package:db/UI/dashboard/widgets/noSqlQueryMode.dart';
import 'package:flutter/material.dart';
import 'breadcrumbs_widget.dart';
import 'collections_panel_widget.dart';
import 'documents_panel_widget.dart';
import 'document_details_panel_widget.dart';

class MainContentWidget extends StatefulWidget {
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
  State<MainContentWidget> createState() => _MainContentWidgetState();
}

class _MainContentWidgetState extends State<MainContentWidget> {
int noSqlView = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: [
         // BreadcrumbsWidget(selectedSection: selectedSection),
         Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.selectedSection,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () {
            setState(() {
              noSqlView=noSqlView==0?1:0;
            });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children:  [
                  Icon(Icons.search, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                  noSqlView==0?  'Switch to Query Mode':'Switch to NoSQL Mode',
                    style: TextStyle(color: Colors.white),
                  ),
              
                ],
              ),
            ),
          ),
        ],
      ),
    ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: noSqlView==0? _buildDatabaseContent():
              NoSqlQueryMode()
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatabaseContent() {
    // Get the currently selected document
    Map<String, dynamic>? selectedDocument;
    if (widget.selectedCollection.isNotEmpty && widget.selectedDocId != null) {
      final documents = widget.mockFirestore[widget.selectedCollection];
      if (documents != null) {
        selectedDocument = documents.firstWhere(
          (doc) => doc['id'] == widget.selectedDocId,
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
            mockFirestore: widget.mockFirestore,
            selectedCollection: widget.selectedCollection,
            onCollectionSelected: widget.onCollectionSelected,
            onDeleteCollection: widget.onDeleteCollection,
          ),
        ),
        Expanded(
          flex: 1,
          child: DocumentsPanel(
            selectedCollection: widget.selectedCollection,
            documents: widget.selectedCollection.isNotEmpty
                ? widget.mockFirestore[widget.selectedCollection]
                : null,
            selectedDocId: widget.selectedDocId,
            onDocumentSelected: widget.onDocumentSelected,
            onDeleteDocument: widget.onDeleteDocument,
          ),
        ),
        Expanded(
          flex: 1,
          child: DocumentDetailsPanel(
            selectedCollection: widget.selectedCollection,
            selectedDocId: widget.selectedDocId,
            document: selectedDocument,
          ),
        ),
      ],
    );
  }
}
