import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../view_model/main_layout_view_model.dart';

class MainLayout extends ConsumerStatefulWidget {
  final Widget body;
  final Widget title;
  final Widget? floatActionButton;
  const MainLayout({super.key, required this.title, required this.body,
    this.floatActionButton});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {

  @override
  Widget build(BuildContext context) {
    ref.watch(mainLayoutViewModelProvider);
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
    await ref.read(mainLayoutViewModelProvider.notifier).signOut();
    if(mounted) {
      context.push('/login');
    }
  }
}
