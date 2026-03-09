import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/shared/auth_providers.dart';
import '../../../shared/theme/theme_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading:
                        const CircleAvatar(child: Icon(Icons.person_outline)),
                    title: Text(user?.email ?? 'Unknown user'),
                    subtitle: Text('UID: ${user?.uid ?? '-'}'),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: Icon(
                      user?.emailVerified == true
                          ? Icons.verified_outlined
                          : Icons.error_outline,
                      color: user?.emailVerified == true
                          ? Colors.green
                          : Colors.orange,
                    ),
                    title: Text(
                      user?.emailVerified == true
                          ? 'Email verified'
                          : 'Email not verified',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Preferences',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Location-based notifications'),
              subtitle: const Text('Simulated locally (no real push yet)'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Dark mode'),
              subtitle: Text(
                themeMode == ThemeMode.dark
                    ? 'Dark theme enabled'
                    : 'Light theme enabled',
              ),
              value: themeMode == ThemeMode.dark,
              onChanged: (value) {
                ref
                    .read(themeModeProvider.notifier)
                    .state = value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).signOut(),
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

