import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/theme/pallete.dart';

import '../../models/post_model.dart';
import '../constants/app_constants.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;

    final currentTheme = ref.watch(themeNotifierProvider);

    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(color: currentTheme.drawerTheme.backgroundColor),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16)
                          .copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          postInfo(user),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  post.link!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          if (isTypeLink)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: AnyLinkPreview(
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                                link: post.link!,
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  post.description!,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          postActions(user),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget postInfo(UserModel user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(post.communityProfilePic),
              radius: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'r/${post.communityName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'u/${post.username}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (post.uid == user.uid)
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete,
              color: Pallete.redColor,
            ),
          ),
      ],
    );
  }

  Widget postActions(UserModel user) {
    return Row(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                AppConstants.up,
                size: 30,
                color:
                    post.upvotes.contains(user.uid) ? Pallete.redColor : null,
              ),
            ),
            Text(
              '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
              style: const TextStyle(fontSize: 17),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                AppConstants.down,
                size: 30,
                color: post.downvotes.contains(user.uid)
                    ? Pallete.blueColor
                    : null,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.comment),
            ),
            Text(
              '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
              style: const TextStyle(fontSize: 17),
            ),
          ],
        ),
      ],
    );
  }
}
