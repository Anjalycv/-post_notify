import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Data carried inside the local notification: post title + post ID.
class NotificationPayload extends Equatable {
  final int postId;
  final String title;

  const NotificationPayload({required this.postId, required this.title});

  String encode() => jsonEncode({'postId': postId, 'title': title});

  static NotificationPayload? tryDecode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return NotificationPayload(
        postId: map['postId'] as int,
        title: map['title'] as String,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [postId, title];
}
