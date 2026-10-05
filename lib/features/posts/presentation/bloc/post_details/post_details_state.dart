import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/post.dart';

enum PostDetailsStatus { loading, success, failure }

class PostDetailsState extends Equatable {
  final PostDetailsStatus status;
  final Post? post;
  final Failure? failure;

  const PostDetailsState({
    this.status = PostDetailsStatus.loading,
    this.post,
    this.failure,
  });

  @override
  List<Object?> get props => [status, post, failure];
}
