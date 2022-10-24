import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repo.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/constants/constants.dart';
import '../../../models/models.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepo = ref.watch(communityRepoProvider);
  return CommunityController(communityRepo: communityRepo, ref: ref);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepo _communityRepo;
  final Ref _ref;
  CommunityController({required CommunityRepo communityRepo, required Ref ref})
      : _communityRepo = communityRepo,
        _ref = ref,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';

    Community community = Community(
      id: name,
      name: name,
      banner: AppConstants.bannerDefault,
      avatar: AppConstants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepo.createCommunity(community);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, 'Community created successfully!');
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepo.getUserCommunities(uid);
  }
}
