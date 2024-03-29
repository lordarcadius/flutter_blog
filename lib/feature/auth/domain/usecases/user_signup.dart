import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/feature/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<String, UserSignupParameters> {
  final AuthRepository authRepository;

  UserSignUp({required this.authRepository});
  @override
  Future<Either<Failure, String>> call(UserSignupParameters params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignupParameters {
  final String name;
  final String email;
  final String password;

  UserSignupParameters({
    required this.name,
    required this.email,
    required this.password,
  });
}
