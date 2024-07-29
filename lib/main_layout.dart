import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  final Widget body;
  final Widget title;
  final Widget? floatActionButton;
  final FirebaseAuth auth;
  const MainLayout({super.key, required this.title, required this.body,
    this.floatActionButton, required this.auth});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(child: Image.asset('assets/images/modern-turkmen-logo.png')),
        ListTile(title: const Text('Tutorials'), onTap: () => context.go(
            '/tutorials'
        ),
        selected: GoRouter.of(context).routeInformationProvider.value.uri.path.startsWith('/tutorials'),
        ),
      ],),),
      appBar: AppBar(
        title: Row(
          children: [
            widget.title
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () => _logOut(),
              child: const Text('Sign Out'),
            ),
          )
        ],
      ),
      body: widget.body,
      floatingActionButton: widget.floatActionButton,
    );
  }

  void _logOut() async {
    await widget.auth.signOut();
    if(mounted) {
      context.push('/login');
    }
  }
}
