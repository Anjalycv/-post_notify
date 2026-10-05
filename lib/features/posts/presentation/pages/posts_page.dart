import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../injection_container.dart';
import '../../../notifications/presentation/cubit/notification_cubit.dart';
import '../bloc/posts/posts_bloc.dart';
import '../bloc/posts/posts_event.dart';
import '../bloc/posts/posts_state.dart';
import '../widgets/post_card.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PostsBloc>()..add(const PostsFetched()),
      child: const _PostsView(),
    );
  }
}

class _PostsView extends StatefulWidget {
  const _PostsView();

  @override
  State<_PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<_PostsView> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final pos = _controller.position;
    if (pos.pixels >= pos.maxScrollExtent - 300) _loadMore();
  }

  void _loadMore() {
    final bloc = context.read<PostsBloc>();
    final s = bloc.state;
    if (s.status == PostsStatus.success &&
        !s.hasReachedMax &&
        !s.isLoadingMore &&
        s.pageFailure == null) {
      bloc.add(const PostsNextPageRequested());
    }
  }

  Future<void> _onRefresh() {
    final completer = Completer<void>();
    context.read<PostsBloc>().add(PostsRefreshed(completer));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationCubit, NotificationState>(
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
        if (state is NotificationPermissionDenied) {
          messenger.showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is NotificationError) {
          messenger.showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Posts')),
        body: BlocConsumer<PostsBloc, PostsState>(
          listener: (context, state) {
            // Short list that doesn't fill the screen -> keep loading.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted &&
                  _controller.hasClients &&
                  _controller.position.maxScrollExtent <= 0) {
                _loadMore();
              }
            });
            if (state.pageFailure != null && state.posts.isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.pageFailure!.message)));
            }
          },
          builder: (context, state) {
            if (state.posts.isEmpty) {
              if (state.status == PostsStatus.failure && state.failure != null) {
                return ErrorView(
                  failure: state.failure!,
                  onRetry: () =>
                      context.read<PostsBloc>().add(const PostsFetched()),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.separated(
                controller: _controller,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: state.posts.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == state.posts.length) {
                    return _Footer(state: state);
                  }
                  final post = state.posts[index];
                  return PostCard(
                    post: post,
                    onTap: () => Navigator.of(context)
                        .pushNamed(AppRouter.postDetails, arguments: post.id),
                    onNotify: () => context
                        .read<NotificationCubit>()
                        .notify(postId: post.id, title: post.title),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final PostsState state;
  const _Footer({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
      );
    }

    if (state.pageFailure != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(
              state.pageFailure!.message,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            TextButton.icon(
              onPressed: () =>
                  context.read<PostsBloc>().add(const PostsNextPageRequested()),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.hasReachedMax) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            "You've reached the end · ${state.posts.length} posts",
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    return const SizedBox(height: 8);
  }
}
