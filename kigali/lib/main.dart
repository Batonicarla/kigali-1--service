import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app_root.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes Firebase using the native Android configuration from
  // google-services.json (no firebase_options.dart needed).
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: KigaliApp()));
}

