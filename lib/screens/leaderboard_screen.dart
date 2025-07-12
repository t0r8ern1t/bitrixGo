import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bitrix_go/Entities/player.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  String? getCurrentUserId() {
    // ---- START: USER ID LOGIC ----
    // This is a placeholder. Replace with your actual user authentication logic.
    // Example using Firebase Auth (uncomment imports if you use this):
    // final user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //   return user.uid; // In Firestore, ensure your player documents use user.uid as their ID
    // }
    // return null;

    // For testing without Firebase Auth, you can hardcode a document ID
    // that you know exists in your 'players' collection to see the highlighting.
    // return "some_document_id_of_current_user_in_firestore";
    return "user_you_123"; // <<-- EXAMPLE: Replace or implement
    // ---- END: USER ID LOGIC ----
  }

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = getCurrentUserId();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaderboard',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Assuming a darker background for AppBar
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor, // Or a gradient
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('leaderboard')
            .orderBy('score', descending: true)
        // .limit(50) // Optional: limit the number of players fetched
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print("Firestore error: ${snapshot.error}");
            return Center(child: Text('Error loading leaderboard: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No players on the leaderboard yet.'));
          }

          List<Player> players = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            DocumentSnapshot doc = snapshot.data!.docs[i];
            Player player = Player.fromFirestore(doc, currentUserId: currentUserId);
            player.setRank(i + 1);
            players.add(player);
          }

          List<Player> topThreePlayers = players.length >= 3 ? players.sublist(0, 3) : [];
          List<Player> remainingPlayers = players.length >= 3 ? players.sublist(3) : (players.isEmpty ? [] : players);


          return Column(
            children: [
              if (topThreePlayers.length == 3)
                _buildTopThreePlayers(topThreePlayers, context),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8), // Add some padding if topThree is present
                  itemCount: (topThreePlayers.length == 3 ? remainingPlayers.length : players.length),
                  itemBuilder: (context, index) {
                    final player = (topThreePlayers.length == 3 ? remainingPlayers[index] : players[index]);
                    return _buildPlayerCard(player, context);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopThreePlayers(List<Player> topPlayers, BuildContext context) {
    if (topPlayers.length < 3) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColorLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end, // Align items to the bottom for podium effect
        children: [
          Flexible(child: _buildPodiumPlayer(topPlayers[1], context, rank: 2)), // 2nd
          Flexible(child: _buildPodiumPlayer(topPlayers[0], context, rank: 1)), // 1st
          Flexible(child: _buildPodiumPlayer(topPlayers[2], context, rank: 3)), // 3rd
        ],
      ),
    );
  }

  Widget _buildPodiumPlayer(Player player, BuildContext context, {required int rank}) {
    double avatarSize = (rank == 1) ? 50 : 40;
    double nameFontSize = (rank == 1) ? 18 : 16;
    FontWeight nameFontWeight = (rank == 1) ? FontWeight.bold : FontWeight.w600;
    double scoreFontSize = (rank == 1) ? 14 : 12;
    // Simple podium height effect
    EdgeInsets podiumPadding = (rank == 1)
        ? const EdgeInsets.only(bottom: 20.0)
        : (rank == 2 ? const EdgeInsets.only(bottom: 10.0) : EdgeInsets.zero);


    String rankEmoji = '';
    if (rank == 1)
      rankEmoji = '👑';
    else if (rank == 2)
      rankEmoji = '🥈';
    else if (rank == 3) rankEmoji = '🥉';


    return Padding(
      padding: podiumPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rankEmoji.isNotEmpty)
            Text(rankEmoji, style: const TextStyle(fontSize: 24)),
          CircleAvatar(
            radius: avatarSize,
            backgroundColor: _getRankColor(player.rank).withOpacity(0.8),
            child: Text(
              player.avatar, // Assuming avatar is a single emoji character
              style: TextStyle(fontSize: avatarSize * 0.7, color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            player.name,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: nameFontWeight,
              fontSize: nameFontSize,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${player.score} pts',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: scoreFontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(Player player, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: player.isCurrentUser ? 2 : 1,
      color: player.isCurrentUser ? Theme.of(context).primaryColorLight.withOpacity(0.3) : Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: player.isCurrentUser
            ? BorderSide(color: Theme.of(context).primaryColor, width: 1.5)
            : BorderSide.none,
      ),
      child: ListTile(
        leading: SizedBox(
          width: 55, // Fixed width for consistent rank + avatar display
          child: Row(
            children: [
              Text(
                '#${player.rank}',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: player.isCurrentUser ? Theme.of(context).primaryColor : Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 18,
                backgroundColor: _getRankColor(player.rank).withOpacity(0.7),
                child: Text(
                  player.avatar, // Assuming avatar is an emoji or a single character
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        title: Text(
          player.name,
          style: GoogleFonts.poppins(
            fontWeight: player.isCurrentUser ? FontWeight.bold : FontWeight.w500,
            color: player.isCurrentUser ? Theme.of(context).primaryColorDark : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getRankColor(player.rank).withOpacity(0.2), // Softer background for score
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${player.score} pts',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              // CHOOSE ONE OF THESE:
              // Option A: Specific dark color from theme for readability
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.9) ?? Colors.black87,
              // Option B: A fixed dark color
              // color: Colors.black.withOpacity(0.75),
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  // Color helper based on rank (from your original code, looks good)
  Color _getRankColor(int rank) {
    // You can adjust these colors to better match your app's theme
    switch (rank) {
      case 1:
        return Colors.amber.shade400; // Gold
      case 2:
        return Colors.grey.shade400;   // Silver
      case 3:
        return Colors.brown.shade400;  // Bronze
      default:
      // A neutral color for other ranks, or a color from your theme
        return Colors.blue.shade200;
    }
  }
}