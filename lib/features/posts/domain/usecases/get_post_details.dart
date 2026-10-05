import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class GetPostDetails implements UseCase<Post, int> {
  final PostRepository repository;
  GetPostDetails(this.repository);

  @override
  Future<Either<Failure, Post>> call(int postId) =>
      repository.getPostById(postId);
}
