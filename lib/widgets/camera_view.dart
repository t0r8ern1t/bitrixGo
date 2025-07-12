import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraView extends StatelessWidget {
  final CameraController controller;
  final Future<void> initializeFuture;

  const CameraView({
    Key? key,
    required this.controller,
    required this.initializeFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initializeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(controller);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}