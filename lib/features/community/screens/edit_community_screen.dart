import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/common.dart';
import 'package:reddit_clone/core/constants/app_constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/responsive/responsive.dart';
import 'package:reddit_clone/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<EditCommunityScreen> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;
  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      }
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          profileWebFile = res.files.first.bytes;
        });
      }
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          profileFile: profileFile,
          bannerFile: bannerFile,
          community: community,
          context: context,
          bannerWebFile: bannerWebFile,
          profileWebFile: profileWebFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            backgroundColor: currentTheme.backgroundColor,
            appBar: AppBar(
              title: const Text('Edit Community'),
              actions: [
                TextButton(
                  onPressed: () => save(community),
                  child: const Text('Save'),
                ),
              ],
            ),
            body: isLoading
                ? const Loader()
                : Responsive(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                editBannerImage(currentTheme, community),
                                editProfileImage(community),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }

  Widget editProfileImage(Community community) {
    return Positioned(
      bottom: 20,
      left: 20,
      child: GestureDetector(
        onTap: selectProfileImage,
        child: profileWebFile != null
            ? CircleAvatar(
                backgroundImage: MemoryImage(profileWebFile!),
                radius: 32,
              )
            : profileFile != null
                ? CircleAvatar(
                    backgroundImage: FileImage(profileFile!),
                    radius: 32,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(community.avatar),
                    radius: 32,
                  ),
      ),
    );
  }

  Widget editBannerImage(ThemeData currentTheme, Community community) {
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: bannerWebFile != null
              ? Image.memory(bannerWebFile!)
              : bannerFile != null
                  ? Image.file(
                      bannerFile!,
                      fit: BoxFit.cover,
                    )
                  : community.banner.isEmpty ||
                          community.banner == AppConstants.bannerDefault
                      ? const Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 40,
                          ),
                        )
                      : Image.network(
                          community.banner,
                          fit: BoxFit.cover,
                        ),
        ),
      ),
    );
  }
}
