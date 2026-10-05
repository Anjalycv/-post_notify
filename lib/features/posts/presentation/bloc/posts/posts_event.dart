import 'dart:async';
import 'package:equatable/equatable.dart';

sealed class PostsEvent extends Equatable {
  const PostsEvent();
  @override
  List<Object?> get props => [];
}

class PostsFetched extends PostsEvent {
  const PostsFetched();
}

class PostsRefreshed extends PostsEvent {
  final Completer<void>? completer;
  const PostsRefreshed([this.completer]);
}

class PostsNextPageRequested extends PostsEvent {
  const PostsNextPageRequested();
}
