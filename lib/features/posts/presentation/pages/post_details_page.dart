import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/error_view.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/post.dart';
import '../bloc/post_details/post_details_bloc.dart';
import '../bloc/post_details/post_details_event.dart';
import '../bloc/post_details/post_details_state.dart';

class PostDetailsPage extends StatelessWidget {
  final int postId;
  const PostDetailsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PostDetailsBloc>()..add(PostDetailsRequested(postId)),
      child: Scaffold(
        appBar: AppBar(title: Text('Post #$postId')),
        body: BlocBuilder<PostDetailsBloc, PostDetailsState>(
          builder: (context, state) {
            switch (state.status) {
              case PostDetailsStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case PostDetailsStatus.failure:
                return ErrorView(
                  failure: state.failure!,
                  onRetry: () => context
                      .read<PostDetailsBloc>()
                      .add(PostDetailsRequested(postId)),
                );
              case PostDetailsStatus.success:
                return _Content(post: state.post!);
            }
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final Post post;
  const _Content({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.tag_rounded,
                label: 'Post ID',
                value: '${post.id}',
                background: scheme.primaryContainer,
                foreground: scheme.onPrimaryContainer,
              ),
              _InfoChip(
                icon: Icons.person_outline_rounded,
                label: 'User ID',
                value: '${post.userId}',
                background: scheme.secondaryContainer,
                foreground: scheme.onSecondaryContainer,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            post.title,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800, height: 1.25),
          ),
          const SizedBox(height: 16),
          Divider(color: scheme.outlineVariant),
          const SizedBox(height: 16),
          Text(post.body, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color background;
  final Color foreground;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: foreground),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(color: foreground.withOpacity(0.8)),
          ),
          Text(
            value,
            style: TextStyle(color: foreground, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
