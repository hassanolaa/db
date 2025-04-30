import 'package:db/core/shared/shareddata.dart';
import 'package:flutter/material.dart';

class SidebarWidget extends StatefulWidget {
   SidebarWidget({Key? key,this.onTap}) : super(key: key);
  Function ()? onTap;

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildSidebarItem('Project Overview', Icons.home, isSelected: false),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Project shortcuts',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        //  _buildSidebarItem('Authentication', Icons.security,
          //    isSelected: false),
          _buildSidebarItem('NoSQL Database', Icons.storage,
              isSelected: view==0,onTap:widget.onTap),
      //    _buildSidebarItem('Hosting', Icons.public, isSelected: false),
          _buildSidebarItem('Key-Value Database', Icons.location_searching, isSelected: view==1,onTap: widget.onTap,),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //   child: Text(
          //     'What\'s new',
          //     style: TextStyle(
          //       color: Colors.grey,
          //       fontSize: 12,
          //     ),
          //   ),
          // ),
          // _buildSidebarItem('App Distribution', Icons.get_app,
          //     isSelected: false, hasNew: true),
          // _buildSidebarItem('Genkit', Icons.code,
          //     isSelected: false, hasNew: true),
          // _buildSidebarItem('Vertex AI', Icons.psychology,
          //     isSelected: false, hasNew: true),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Product categories',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          _buildSidebarItem('Settings', Icons.settings,
              isSelected: false, showLabel: true),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, IconData icon,
      {required bool isSelected, bool showLabel = true, bool hasNew = false, Function()? onTap}) {
    return InkWell(
      onTap: onTap ,
      child:  Container(
      color: isSelected ? Colors.blue.shade50 : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.blue : Colors.grey.shade700,
            ),
            if (showLabel) const SizedBox(width: 12),
            if (showLabel)
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            if (hasNew) ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(fontSize: 10, color: Colors.blue),
                ),
              ),
            ],
          ],
        ),
      ),
      )
    );
  }
}
