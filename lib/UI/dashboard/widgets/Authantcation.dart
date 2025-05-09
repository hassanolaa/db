import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class User {
  final String identifier;
  final String provider;
  final String created;
  final String signedIn;
  final String userUID;
  final String? hashedPassword;

  User({
    required this.identifier,
    required this.provider,
    required this.created,
    required this.signedIn,
    required this.userUID,
    this.hashedPassword,
  });
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final List<User> _users = [
    User(
      identifier: 'hssanabdi975@gmail.com',
      provider: 'google',
      created: 'May 6, 2025',
      signedIn: 'May 6, 2025',
      userUID: 'e2Ug2tXfo7ckh1ywq1I7L45mr...',
      hashedPassword: 'hashed_password_1',
    ),
  ];

  TextEditingController searchController = TextEditingController();
  bool isAscending = true;
  List<User> _filteredUsers = [];





  // Hash password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
   // Show add user dialog with modern UI
  void _showAddUserDialog() {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _isPasswordVisible = false;
    String? _selectedProvider = 'email';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return  AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.person_add, color: Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  const Text('Add New User'),
                ],
              ),
              content: Container(
                width: 400,
                constraints: const BoxConstraints(maxHeight: 400),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Authentication Provider',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade100,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Row(
                                    children: [
                                      Icon(Icons.email, color: Colors.grey.shade600, size: 18),
                                      const SizedBox(width: 8),
                                      const Text('Email', style: TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                  value: 'email',
                                  groupValue: _selectedProvider,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedProvider = value;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Row(
                                    children: [
                                      const Icon(Icons.g_mobiledata, color: Colors.red, size: 22),
                                      const SizedBox(width: 8),
                                      const Text('Google', style: TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                  value: 'google',
                                  groupValue: _selectedProvider,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedProvider = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email_outlined, color: Colors.grey.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final hashedPassword = _hashPassword(passwordController.text);
                              
                              setState(() {
                                _users.add( User(
                                identifier: emailController.text,
                                provider: _selectedProvider!,
                                created: DateFormat('MMM d, yyyy').format(DateTime.now()),
                                signedIn: DateFormat('MMM d, yyyy').format(DateTime.now()),
                                userUID: '${DateTime.now().millisecondsSinceEpoch}',
                                hashedPassword: hashedPassword,
                              ));
                                _searchUsers(searchController.text);
                                
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Add User'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      
  }
  

  void _searchUsers(String query) {
  final lowercaseQuery = query.toLowerCase();
  setState(() {
    _filteredUsers = _users.where((user) {
      return user.identifier.toLowerCase().contains(lowercaseQuery) ||
             user.userUID.toLowerCase().contains(lowercaseQuery);
    }).toList();
  });
}

  @override
void initState() {
  super.initState();
  _filteredUsers = List.from(_users);
}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 16),
            _buildUserTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: searchController,
              onChanged: _searchUsers,
              decoration: const InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.search),
                hintText: 'Search by email, UID...',
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: _showAddUserDialog,
          icon: const Icon(Icons.person_add),
          label: const Text('Add User'),
        ),
        const SizedBox(width: 8),
        IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  Widget _buildUserTable() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            _buildHeaderRow(),
            const Divider(height: 0),
            Expanded(
              child: searchController.text.isEmpty? ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return _buildUserRow(user);
                },
              ): ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return _buildUserRow(user);
                },
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          _buildHeaderCell('Identifier', flex: 3),
          _buildHeaderCell('Provider', flex: 2),
          _buildHeaderCell('Created', flex: 2, withSort: true),
          _buildHeaderCell('Signed In', flex: 2),
          _buildHeaderCell('User UID', flex: 3),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1, bool withSort = false}) {
    return Expanded(
      flex: flex,
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          if (withSort)
            IconButton(
              icon: Icon(isAscending ? Icons.arrow_downward : Icons.arrow_upward),
              iconSize: 16,
              onPressed: () {
                setState(() {
                  isAscending = !isAscending;
                  _users.sort((a, b) => isAscending
                      ? a.created.compareTo(b.created)
                      : b.created.compareTo(a.created));
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildUserRow(User user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(user.identifier)),
          Expanded(flex: 2, child: _buildProviderIcon(user.provider)),
          Expanded(flex: 2, child: Text(user.created)),
          Expanded(flex: 2, child: Text(user.signedIn)),
          Expanded(
            flex: 3,
            child: Text(user.userUID, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderIcon(String provider) {
    switch (provider) {
      case 'google':
        return const Icon(Icons.g_mobiledata, color: Colors.red, size: 28);
      case 'email':
        return const Icon(Icons.email, color: Colors.blueGrey);
      default:
        return const Icon(Icons.account_circle, color: Colors.grey);
    }
  }
}
