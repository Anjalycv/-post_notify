import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_post_details.dart';
import 'post_details_event.dart';
import 'post_details_state.dart';

class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState> {
  final GetPostDetails _getPostDetails;

  PostDetailsBloc({required GetPostDetails getPostDetails})
      : _getPostDetails = getPostDetails,
        super(const PostDetailsState()) {
    on<PostDetailsRequested>(_onRequested, transformer: droppable());
  }

  Future<void> _onRequested(
    PostDetailsRequested event,
    Emitter<PostDetailsState> emit,
  ) async {
    emit(const PostDetailsState(status: PostDetailsStatus.loading));
    final result = await _getPostDetails(event.postId);
    result.fold(
      (failure) => emit(PostDetailsState(
        status: PostDetailsStatus.failure,
        failure: failure,
      )),
      (post) => emit(PostDetailsState(
        status: PostDetailsStatus.success,
        post: post,
      )),
    );
  }
}
