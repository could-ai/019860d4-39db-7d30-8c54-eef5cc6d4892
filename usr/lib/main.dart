import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:couldai_user_app/add_password_screen.dart';
import 'package:couldai_user_app/auth_screen.dart';
import 'package:couldai_user_app/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hottegpaveldxtburgal.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhvdHRlZ3BhdmVsZHh0YnVyZ2FsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI2NjY4NjQsImV4cCI6MjA2ODI0Mjg2NH0.19y0C925x_fXU8Nz5HfsZz-B7giIioa9Bmc4JutuVvU',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class PasswordEntry {
  final int id;
  final String website;
  final String username;
  final String password;

  PasswordEntry({required this.id, required this.website, required this.username, required this.password});

  factory PasswordEntry.fromMap(Map<String, dynamic> map) {
    return PasswordEntry(
      id: map['id'],
      website: map['website'],
      username: map['username'],
      password: map['password'],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pass Me!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.green.shade900,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const MyHomePage(title: 'Pass Me!'),
      },
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
  Future<List<PasswordEntry>>? _passwordEntriesFuture;

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  void _loadPasswords() {
    setState(() {
      _passwordEntriesFuture = _fetchPasswords();
    });
  }

  Future<List<PasswordEntry>> _fetchPasswords() async {
    try {
      final response = await supabase
          .from('passwords')
          .select()
          .order('created_at', ascending: false);
      final entries = (response as List)
          .map((data) => PasswordEntry.fromMap(data))
          .toList();
      return entries;
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching passwords: ${e.toString()}')),
        );
      }
      return [];
    }
  }

  void _navigateToAddPasswordScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPasswordScreen()),
    );

    if (result == true) {
      _loadPasswords();
    }
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign out failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: FutureBuilder<List<PasswordEntry>>(
        future: _passwordEntriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No passwords saved yet.'));
          }

          final passwordEntries = snapshot.data!;
          return ListView.builder(
            itemCount: passwordEntries.length,
            itemBuilder: (context, index) {
              final entry = passwordEntries[index];
              return ListTile(
                title: Text(entry.website),
                subtitle: Text(entry.username),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Implement password detail view
                },
              );
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
