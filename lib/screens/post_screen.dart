import 'package:flutter/material.dart';
import 'package:flutter_post/blocs/auth/auth_state.dart';
import 'package:flutter_post/services/theme.dart';
import 'package:intl/intl.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/post/post_bloc.dart';
import '../blocs/post/post_event.dart';
import '../blocs/post/post_state.dart';
import 'package:google_fonts/google_fonts.dart';

class PostScreen extends StatefulWidget {
  final AuthBloc authBloc;
  final PostBloc postBloc;

  const PostScreen({Key? key, required this.authBloc, required this.postBloc})
      : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _postController = TextEditingController();
  late final Stream<PostState> _postStream;

  @override
  void initState() {
    super.initState();
    _postStream = widget.postBloc.stream;
    widget.postBloc.add(LoadPostsEvent());
  }

  @override
  void dispose() {
    _postController.dispose();
    widget.postBloc.close();
    super.dispose();
  }

  void _addPost() {
    final message = _postController.text.trim();

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post cannot be empty. Please write something!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      widget.postBloc.add(AddPostEvent(
        message: message,
        username: widget.authBloc.state is AuthAuthenticated
            ? (widget.authBloc.state as AuthAuthenticated).username
            : 'Anonymous',
      ));

      _postController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post added successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add post: $error'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FlutterPost',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              size: 30,
            ),
            onPressed: () {
              widget.authBloc.add(LogOutEvent());
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: InputDecoration(
                      labelText: 'Write a post...',
                      hintText: 'Share your thoughts',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addPost,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ), // App primary color
                  ),
                  child: Text(
                    'Post',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<PostState>(
              stream: _postStream,
              builder: (context, snapshot) {
                final state = snapshot.data;

                if (state is PostLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PostsLoaded) {
                  final posts = state.posts;

                  if (posts.isEmpty) {
                    return const Center(
                        child: Text('No posts yet. Start the conversation!'));
                  }

                  return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.username,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(post.message),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'Posted on ${DateFormat.yMMMd().add_jm().format(post.timestamp)}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state is PostError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return const Center(child: Text('No posts yet.'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPost,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }
}
