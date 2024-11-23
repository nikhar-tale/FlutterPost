import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_event.dart';
import 'post_state.dart';
import '../../repositories/post_repository.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc(this.postRepository) : super(PostInitial()) {
    // Load posts
    on<LoadPostsEvent>((event, emit) async {
      emit(PostLoading());
      try {
        postRepository.getPostsStream().listen((posts) {
          add(PostsUpdatedEvent(posts)); // Now we're passing a List<PostModel>
        });
      } catch (e) {
        emit(PostError(e.toString()));
      }
    });

    // Add a new post
    on<AddPostEvent>((event, emit) async {
      try {
        await postRepository.addPost(event.message, event.username);
      } catch (e) {
        emit(PostError('Failed to add post: ${e.toString()}'));
      }
    });

    // Update posts when Firestore changes
    on<PostsUpdatedEvent>((event, emit) {
      emit(PostsLoaded(event.posts)); // Now event.posts is List<PostModel>
    });
  }
}
