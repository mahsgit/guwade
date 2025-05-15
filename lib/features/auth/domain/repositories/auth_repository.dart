import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login(String username, String password);
  Future<Either<Failure, AuthUser>> getProfile();
}
