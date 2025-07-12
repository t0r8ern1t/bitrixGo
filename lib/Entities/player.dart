
import 'package:firebase_database/firebase_database.dart';
import 'package:bitrix_go/Entities/item.dart';

class Player {
  final String name;
  final int score;
  final int rank;
  final String avatar;
  final bool isCurrentUser;
  final Map<Item, int> inventory;

  Player({
    required this.name,
    required this.score,
    required this.rank,
    required this.avatar,
    this.inventory = const {},
    this.isCurrentUser = false,
  });
  Map<String, dynamic> toMap() {
    return {
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
      name: map['name'] ?? '',
      score: map['score']?.toInt() ?? 0,
      rank: map['rank']?.toInt() ?? 0,
      avatar: map['avatar'] ?? '👤',
      isCurrentUser: map['isCurrentUser'] ?? false,
    );
  }
}