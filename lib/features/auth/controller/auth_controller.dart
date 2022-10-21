import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repository/auth_repo.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepo: ref.read(authRepoProvider),
  ),
);

class AuthController {
  final AuthRepo _authRepo;
  AuthController({required AuthRepo authRepo}) : _authRepo = authRepo;

  void signInWithGoogle(BuildContext context) async {
    final user = await _authRepo.signInWithGoogle();
    user.fold(
        (l) => showSnackBar(
              context,
              l.message,
            ),
        (r) => null);
  }
}
