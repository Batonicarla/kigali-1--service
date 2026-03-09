import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/shared/auth_providers.dart';
import '../../features/listings/presentation/directory_screen.dart';
import '../../features/listings/presentation/my_listings_screen.dart';
import '../../features/listings/presentation/map_view_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

class ScaffoldShell extends ConsumerStatefulWidget {
  const ScaffoldShell({super.key});

  @override
  ConsumerState<ScaffoldShell> createState() => _ScaffoldShellState();
}

class _ScaffoldShellState extends ConsumerState<ScaffoldShell> {
  int _currentIndex = 0;

  final _screens = [
    const DirectoryScreen(),
    const MyListingsScreen(),
    const MapViewScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final emailVerified = user?.emailVerified ?? false;

    if (!emailVerified) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Verify your email'),
          actions: [
            IconButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                await user?.sendEmailVerification();
                if (!mounted) return;
                messenger.showSnackBar(
                  const SnackBar(content: Text('Verification email sent')),
                );
              },
              icon: const Icon(Icons.mark_email_unread_outlined),
              tooltip: 'Resend verification email',
            ),
            IconButton(
              onPressed: () =>
                  ref.read(authControllerProvider.notifier).signOut(),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Check your email inbox and click the verification link.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'After you have verified, tap the button below to continue.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await user?.reload();
                  final refreshedUser = FirebaseAuth.instance.currentUser;
                  if (!mounted) return;
                  if (refreshedUser != null && refreshedUser.emailVerified) {
                    setState(() {
                      // Just rebuild; emailVerified will now be true
                    });
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Email still not verified. Please click the link in your email first.',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('I have verified my email'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey.shade100,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey.shade600,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Directory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'My Listings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}


