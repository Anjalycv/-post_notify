import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../domain/usecases/get_posts.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPosts _getPosts;

  PostsBloc({required GetPosts getPosts})
      : _getPosts = getPosts,
        super(const PostsState()) {
    on<PostsFetched>(_onFetched, transformer: droppable());
    on<PostsRefreshed>(_onRefreshed, transformer: droppable());
    on<PostsNextPageRequested>(_onNextPage, transformer: droppable());
  }

  bool _reachedMax(int total, int returned, int requested) =>
      total >= ApiConstants.totalPosts || returned < requested;

  Future<void> _onFetched(PostsFetched event, Emitter<PostsState> emit) async {
    emit(state.copyWith(
      status: PostsStatus.loading,
      clearFailure: true,
      clearPageFailure: true,
    ));

    const requested = ApiConstants.initialPostsCount;
    final result =
        await _getPosts(const PageParams(start: 0, limit: requested));

    result.fold(
      (failure) => emit(state.copyWith(status: PostsStatus.failure, failure: failure)),
      (posts) => emit(PostsState(
        status: PostsStatus.success,
        posts: posts,
        hasReachedMax: _reachedMax(posts.length, posts.length, requested),
      )),
    );
  }

  Future<void> _onRefreshed(
      PostsRefreshed event, Emitter<PostsState> emit) async {
    try {
      const requested = ApiConstants.initialPostsCount;
      final result =
          await _getPosts(const PageParams(start: 0, limit: requested));

      result.fold(
        (failure) {
          if (state.posts.isEmpty) {
            emit(state.copyWith(status: PostsStatus.failure, failure: failure));
          } else {
            // Keep what the user already sees; just tell them the refresh failed.
            emit(state.copyWith(pageFailure: failure, isLoadingMore: false));
          }
        },
        (posts) => emit(PostsState(
          status: PostsStatus.success,
          posts: posts,
          hasReachedMax: _reachedMax(posts.length, posts.length, requested),
        )),
      );
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onNextPage(
      PostsNextPageRequested event, Emitter<PostsState> emit) async {
    if (state.status != PostsStatus.success ||
        state.hasReachedMax ||
        state.isLoadingMore) {
      return;
    }

    final start = state.posts.length;
    final limit = (ApiConstants.totalPosts - start) < ApiConstants.pageSize
        ? ApiConstants.totalPosts - start
        : ApiConstants.pageSize;

    emit(state.copyWith(isLoadingMore: true, clearPageFailure: true));

    final result = await _getPosts(PageParams(start: start, limit: limit));

    // The list was replaced by a refresh while we were waiting - discard.
    if (state.posts.length != start) {
      emit(state.copyWith(isLoadingMore: false));
      return;
    }

    result.fold(
      (failure) =>
          emit(state.copyWith(isLoadingMore: false, pageFailure: failure)),
      (newPosts) {
        final all = [...state.posts, ...newPosts];
        emit(state.copyWith(
          posts: all,
          isLoadingMore: false,
          hasReachedMax: _reachedMax(all.length, newPosts.length, limit),
        ));
      },
    );
  }
}
