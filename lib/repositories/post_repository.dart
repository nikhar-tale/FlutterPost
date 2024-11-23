import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<PostModel>> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              // Convert Firestore data to PostModel
              return PostModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
            }).toList());
  }

  Future<void> addPost(String message, String username) async {
    // Create a new PostModel before saving to Firestore
    final post = PostModel(
      id: '', // Firestore will generate the ID
      message: message,
      username: username,
      timestamp: DateTime.now(),
    );

    await _firestore.collection('posts').add(post.toFirestore());
  }
}
