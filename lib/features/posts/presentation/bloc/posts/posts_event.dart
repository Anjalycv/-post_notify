import 'dart:async';
import 'package:equatable/equatable.dart';

sealed class PostsEvent extends Equatable {
  const PostsEvent();
  @override
  List<Object?> get props => [];
}

/// Initial load (also used by the full-screen Retry button).
class PostsFetched extends PostsEvent {
  const PostsFetched();
}

/// Pull-to-refresh. The completer lets RefreshIndicator know when to stop spinning.
class PostsRefreshed extends PostsEvent {
  final Completer<void>? completer;
  const PostsRefreshed([this.completer]);
}

class PostsNextPageRequested extends PostsEvent {
  const PostsNextPageRequested();
}
