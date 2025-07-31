import 'package:flutter/material.dart';
import 'package:couldai_user_app/add_password_screen.dart';

void main() {
  runApp(const MyApp());
}

class PasswordEntry {
  final String website;
  final String username;
  final String password;

  PasswordEntry({required this.website, required this.username, required this.password});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Password Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<PasswordEntry> _passwordEntries = [
    PasswordEntry(website: 'Google', username: 'user@gmail.com', password: 'password123'),
    PasswordEntry(website: 'Facebook', username: 'user@facebook.com', password: 'password456'),
    PasswordEntry(website: 'Twitter', username: 'user@twitter.com', password: 'password789'),
  ];

  void _navigateToAddPasswordScreen() async {
    final newEntry = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPasswordScreen()),
    );

    if (newEntry != null) {
      setState(() {
        _passwordEntries.add(newEntry);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _passwordEntries.length,
        itemBuilder: (context, index) {
          final entry = _passwordEntries[index];
          return ListTile(
            title: Text(entry.website),
            subtitle: Text(entry.username),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Implement password detail view
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPasswordScreen,
        tooltip: 'Add Password',
        child: const Icon(Icons.add),
      ),
    );
  }
}
