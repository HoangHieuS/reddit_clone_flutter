import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/features/post/widgets/comment_card.dart';
import 'package:reddit_clone/responsive/responsive.dart';

import '../../../core/common/common.dart';
import '../../../models/post_model.dart';
import '../../auth/controller/auth_controller.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
        appBar: AppBar(),
        body: ref.watch(getPostByIdProvider(widget.postId)).when(
              data: (data) {
                return Column(
                  children: [
                    PostCard(post: data),
                    if (!isGuest)
                      Responsive(
                        child: TextField(
                          onSubmitted: (value) => addComment(data),
                          controller: commentController,
                          decoration: const InputDecoration(
                            hintText: 'What are tour thoughts?',
                            filled: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ref.watch(getPostCommentsProvider(widget.postId)).when(
                          data: (data) {
                            return Expanded(
                              child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final comment = data[index];
                                  return CommentCard(comment: comment);
                                },
                              ),
                            );
                          },
                          error: (error, stackTrace) =>
                              ErrorText(error: error.toString()),
                          loading: () => const Loader(),
                        ),
                  ],
                );
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            ));
  }
}
