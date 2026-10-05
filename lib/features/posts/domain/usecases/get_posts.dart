import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/post.dart';
import '../repositories/post_repository.dart';

class PageParams extends Equatable {
  final int start;
  final int limit;
  const PageParams({required this.start, required this.limit});

  @override
  List<Object?> get props => [start, limit];
}

class GetPosts implements UseCase<List<Post>, PageParams> {
  final PostRepository repository;
  GetPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(PageParams params) =>
      repository.getPosts(start: params.start, limit: params.limit);
}
