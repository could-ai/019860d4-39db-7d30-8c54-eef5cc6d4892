import 'package:flutter/material.dart';
import 'package:couldai_user_app/main.dart';

class AddPasswordScreen extends StatefulWidget {
  const AddPasswordScreen({super.key});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final _websiteController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _savePassword() {
    if (_websiteController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      final newEntry = PasswordEntry(
        website: _websiteController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );
      Navigator.pop(context, newEntry);
    }
  }

  @override
  void dispose() {
    _websiteController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Password'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _savePassword,
            tooltip: 'Save',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _websiteController,
              decoration: const InputDecoration(
                labelText: 'Website / Service',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username / Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
