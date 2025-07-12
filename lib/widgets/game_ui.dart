import 'package:flutter/material.dart';

class GameUI extends StatelessWidget {
  const GameUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top bar
        _buildTopBar(context),

        // Spacer to push bottom controls down
        const Expanded(child: SizedBox()),

        // Bottom controls
        _buildBottomControls(context),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPlayerInfo(context),
          _buildMenuButton(),
        ],
      ),
    );
  }

  Widget _buildPlayerInfo(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        const SizedBox(height: 4),
        Text(
          "Trainer",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          "Lv. 5",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildMenuButton() {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        // TODO: Open menu
      },
    );
  }

  Widget _buildBottomControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(Icons.ac_unit, "Leaderboard", context, () {
            Navigator.pushNamed(context, '/leaderboard'); // Navigate to LeaderboardScreen
          }),
          _buildActionButton(Icons.backpack, "Inventory", context, () {
            Navigator.pushNamed(context, '/inventory'); // Navigate to ItemsScreen
          }),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, BuildContext context, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}