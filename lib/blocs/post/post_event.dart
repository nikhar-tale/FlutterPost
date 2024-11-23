import 'package:equatable/equatable.dart';
import 'package:flutter_post/models/post_model.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPostsEvent extends PostEvent {}

class AddPostEvent extends PostEvent {
  final String message;
  final String username;

  AddPostEvent({required this.message, required this.username});

  @override
  List<Object?> get props => [message, username];
}

class PostsUpdatedEvent extends PostEvent {
  final List<PostModel> posts;  // Use PostModel here

  PostsUpdatedEvent(this.posts);

  @override
  List<Object?> get props => [posts];
}
