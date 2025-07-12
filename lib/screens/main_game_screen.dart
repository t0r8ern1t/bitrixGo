import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../widgets/camera_view.dart';
import '../widgets/game_ui.dart';

class MainGameScreen extends StatefulWidget {
  final CameraDescription camera;

  const MainGameScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CameraView(
            controller: _controller,
            initializeFuture: _initializeControllerFuture,
          ),
          const GameUI(),
        ],
      ),
    );
  }
}