import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String message;
  final String username;
  final DateTime timestamp;

  PostModel({
    required this.id,
    required this.message,
    required this.username,
    required this.timestamp,
  });

  // Factory method to create a PostModel from Firestore data
  factory PostModel.fromFirestore(String id, Map<String, dynamic> data) {
    return PostModel(
      id: id,
      message: data['message'] as String,
      username: data['username'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Method to convert a PostModel to a Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'message': message,
      'username': username,
      'timestamp': timestamp,
    };
  }
}
