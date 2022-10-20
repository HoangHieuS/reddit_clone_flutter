import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/repository/auth_repo.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepo: ref.read(authRepoProvider),
  ),
);

class AuthController {
  final AuthRepo _authRepo;
  AuthController({required AuthRepo authRepo}) : _authRepo = authRepo;

  void signInWithGoogle() {
    _authRepo.signInWithGoogle();
  }
}
