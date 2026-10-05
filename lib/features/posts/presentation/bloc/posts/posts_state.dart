import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/post.dart';

enum PostsStatus { initial, loading, success, failure }

class PostsState extends Equatable {
  final PostsStatus status;
  final List<Post> posts;
  final bool hasReachedMax;
  final bool isLoadingMore;

  /// Full-screen failure (nothing to show).
  final Failure? failure;

  /// Failure while loading more / refreshing when posts are already on screen.
  final Failure? pageFailure;

  const PostsState({
    this.status = PostsStatus.initial,
    this.posts = const [],
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.failure,
    this.pageFailure,
  });

  PostsState copyWith({
    PostsStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
    bool? isLoadingMore,
    Failure? failure,
    Failure? pageFailure,
    bool clearFailure = false,
    bool clearPageFailure = false,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: clearFailure ? null : (failure ?? this.failure),
      pageFailure: clearPageFailure ? null : (pageFailure ?? this.pageFailure),
    );
  }

  @override
  List<Object?> get props =>
      [status, posts, hasReachedMax, isLoadingMore, failure, pageFailure];
}
