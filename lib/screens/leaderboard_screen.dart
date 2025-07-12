import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bitrix_go/Entities/player.dart';

class LeaderboardScreen extends StatelessWidget {
  // Mock data - replace with your actual data source
  final List<Player> players = [
    Player(name: 'Alex', score: 950, rank: 1, avatar: '👑'),
    Player(name: 'Jamie', score: 875, rank: 2, avatar: '🥈'),
    Player(name: 'Taylor', score: 820, rank: 3, avatar: '🥉'),
    Player(name: 'Morgan', score: 795, rank: 4, avatar: '🎯'),
    Player(name: 'Casey', score: 760, rank: 5, avatar: '🏹'),
    Player(name: 'You', score: 680, rank: 6, avatar: '😊', isCurrentUser: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaderboard',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildTopThreePlayers(),
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) => _buildPlayerCard(players[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopThreePlayers() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade400],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPodiumPlayer(players[1]), // 2nd place
          _buildPodiumPlayer(players[0]), // 1st place
          _buildPodiumPlayer(players[2]), // 3rd place
        ],
      ),
    );
  }

  Widget _buildPodiumPlayer(Player player) {
    return Column(
      children: [
        Text(
          '#${player.rank}',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        CircleAvatar(
          radius: 30,
          backgroundColor: _getRankColor(player.rank),
          child: Text(
            player.avatar,
            style: TextStyle(fontSize: 30),
          ),
        ),
        SizedBox(height: 8),
        Text(
          player.name,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '${player.score} pts',
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCard(Player player) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: player.isCurrentUser ? Colors.blue.shade50 : null,
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRankColor(player.rank),
          child: Text(player.avatar),
        ),
        title: Text(
          player.name,
          style: GoogleFonts.poppins(
            fontWeight: player.isCurrentUser ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${player.score} pts',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade800,
            ),
          ),
        ),
        subtitle: Text(
          'Rank #${player.rank}',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1: return Colors.amber.shade300;
      case 2: return Colors.grey.shade300;
      case 3: return Colors.brown.shade300;
      default: return Colors.blue.shade100;
    }
  }
}