import 'package:bitrix_go/screens/inventory_screen.dart';
import 'package:bitrix_go/screens/leaderboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ar-screen.dart';
import 'firebase_options.dart';
import 'screens/main_game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await requestAppPermissions();

  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitrix Go',
      theme: ThemeData.dark(),
      home: ARGameScreen(camera: camera), // Update to use ARGameScreen
      routes: {
        '/inventory': (context) => InventoryScreen(),
        '/leaderboard': (context) => LeaderboardScreen(),
      },
    );
  }
}

Future<void> requestAppPermissions() async {
  await Permission.camera.request();
  await Permission.location.request();
  // Add other permissions as needed
}
