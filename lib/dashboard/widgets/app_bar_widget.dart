import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget {
  final String selectedValue;
  final List<String> options;
  final Function(String?) onValueChanged;

  const DashboardAppBar({
    Key? key,
    required this.selectedValue,
    required this.options,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Image.network(
            'https://static.vecteezy.com/system/resources/previews/004/657/673/non_2x/database-line-style-icon-vector.jpg',
            height: 32,
          ),
          const SizedBox(width: 8),
          const Text(
            'Demo Database',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 24),
          _buildDropdownButton(),
          const SizedBox(width: 16),
          const Spacer(),
          CircleAvatar(
            backgroundColor: Colors.orange.shade100,
            child: const Icon(Icons.person, color: Colors.deepOrange),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownButton() {
    return Container(
      height: 32,
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
        
          value: selectedValue,
          icon: const Icon(Icons.arrow_drop_down, size: 18),
          style: const TextStyle(fontSize: 14, color: Colors.black),
          onChanged: onValueChanged,
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
