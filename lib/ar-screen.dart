import 'package:ar_flutter_plugin_2/models/ar_anchor.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin_2/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin_2/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin_2/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_2/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_2/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_2/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin_2/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart' as Math;
import 'package:cloud_firestore/cloud_firestore.dart';

class ARGameScreen extends StatefulWidget {
  final CameraDescription camera;

  const ARGameScreen({super.key, required this.camera});

  @override
  _ARGameScreenState createState() => _ARGameScreenState();
}

class _ARGameScreenState extends State<ARGameScreen> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  late ARAnchorManager arAnchorManager;
  List<Map<String, dynamic>> creatures = [];
  int selectedFloor = 1;

  @override
  void initState() {
    super.initState();
    loadCreatures();
  }

  Future<void> loadCreatures() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('creatures')
        .where('floor', isEqualTo: selectedFloor)
        .get();
    setState(() {
      creatures = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;
    arAnchorManager = anchorManager;

    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: true,
    );

    arSessionManager.onPlaneOrPointTap = (List<ARHitTestResult> hits) {
      if (hits.isNotEmpty) {
        final hit = hits.firstWhere(
          (hit) => hit.type == ARHitTestResultType.plane,
        );
        placeCreatures(hit);
      }
    };
  }

  void placeCreatures(ARHitTestResult hit) async {
    for (var creature in creatures) {
      final position = creature['position'] as Map<String, dynamic>;
      final transformation = Math.Matrix4.identity()
        ..translate(
          position['x'].toDouble(),
          position['y'].toDouble(),
          position['z'].toDouble(),
        );

      final anchor = ARPlaneAnchor(
        name: creature['id'],
        transformation: transformation,
      );

      final added = await arAnchorManager.addAnchor(anchor);
      if (added == true) {
        final node = ARNode(
          type: NodeType.localGLTF2,
          uri: creature['modelPath'],
          scale: Math.Vector3(0.2, 0.2, 0.2),
          transformation:
              transformation, // Use transformation directly in the node
        );
        await arObjectManager.addNode(node);
      }
    }
  }

  void changeFloor(int floor) {
    setState(() {
      selectedFloor = floor;
      creatures.clear();
    });
    loadCreatures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ARView(onARViewCreated: onARViewCreated),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/inventory');
                  },
                  child: const Text('Профиль'),
                ),
                DropdownButton<int>(
                  value: selectedFloor,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Этаж 1')),
                    DropdownMenuItem(value: 2, child: Text('Этаж 2')),
                    DropdownMenuItem(value: 3, child: Text('Этаж 3')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      changeFloor(value);
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/leaderboard');
                  },
                  child: const Text('Таблица лидеров'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
