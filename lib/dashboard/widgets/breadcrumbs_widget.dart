import 'package:flutter/material.dart';

class BreadcrumbsWidget extends StatelessWidget {
  final String selectedSection;

  const BreadcrumbsWidget({
    Key? key,
    required this.selectedSection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedSection,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
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
      ),
    );
  }
}
