import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/post.dart';

abstract class PostRepository {
  Future<Either<Failure, List<Post>>> getPosts({
    required int start,
    required int limit,
  });

  Future<Either<Failure, Post>> getPostById(int id);
}
