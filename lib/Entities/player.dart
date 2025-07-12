
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bitrix_go/Entities/item.dart';

class Player {
  final String id;
  final String name;
  final int score;
  late final int rank;
  final String avatar;
  final bool isCurrentUser;
  final Map<Item, int> inventory;

  Player({
    required this.id,
    required this.name,
    required this.score,
    required this.avatar,
    this.inventory = const {},
    this.isCurrentUser = false,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'rank': rank,
      'avatar': avatar,
      'isCurrentUser': isCurrentUser,
      'timestamp': ServerValue.timestamp, // Firebase server timestamp
    };
  }

  // Create Player from Map
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map["id"] ?? '',
      name: map['name'] ?? '',
      score: map['score']?.toInt() ?? 0,
      avatar: map['avatar'] ?? '👤',
      isCurrentUser: map['isCurrentUser'] ?? false,
    );
  }
  // Factory constructor to create a Player from a Firestore document
  factory Player.fromFirestore(DocumentSnapshot doc, {String? currentUserId}) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Player(
      id: doc.id,
      name: data['name'] ?? 'Anonymous',
      score: data['score'] ?? 0,
      avatar: data['avatar'] ?? '👤', // Fetch avatar from Firestore or use default
      isCurrentUser: currentUserId != null && doc.id == currentUserId, // Check if this player is the current user
    );
  }

  // Method to set rank after sorting
  void setRank(int newRank) {
    rank = newRank;
  }
}