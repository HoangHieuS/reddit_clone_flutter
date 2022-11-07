import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/common.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/models/community_model.dart';

import '../../../core/utils.dart';
import '../../../theme/pallete.dart';
import '../widgets/custom_text_field.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  ConsumerState<AddPostTypeScreen> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  List<Community> communties = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titleController.text.isNotEmpty &&
        selectedCommunity != null) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communties[0],
            file: bannerFile,
          );
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communties[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communties[0],
            link: linkController.text.trim(),
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text('Share'),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTextField(
                    controller: titleController,
                    hintText: 'Enter Title here',
                    isTitle: true,
                  ),
                  const SizedBox(height: 10),
                  if (isTypeImage) imageTypeWidget(currentTheme),
                  if (isTypeText)
                    CustomTextField(
                      controller: descriptionController,
                      hintText: 'Enter Description here',
                      isDescription: true,
                    ),
                  if (isTypeLink)
                    CustomTextField(
                      controller: linkController,
                      hintText: 'Enter Link here',
                    ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Select Community'),
                  ),
                  ref.watch(userCommunitiesProvider).when(
                        data: (data) {
                          communties = data;

                          if (data.isEmpty) {
                            return const SizedBox();
                          }
                          return DropdownButton(
                            value: selectedCommunity ?? data[0],
                            items: data
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedCommunity = val;
                              });
                            },
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () => const Loader(),
                      )
                ],
              ),
            ),
    );
  }

  Widget imageTypeWidget(ThemeData currentTheme) {
    return GestureDetector(
      onTap: selectBannerImage,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [10, 4],
        strokeCap: StrokeCap.round,
        color: currentTheme.textTheme.bodyText2!.color!,
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: bannerFile != null
              ? Image.file(
                  bannerFile!,
                  fit: BoxFit.cover,
                )
              : const Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                  ),
                ),
        ),
      ),
    );
  }
}
