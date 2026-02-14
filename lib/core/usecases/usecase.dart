/// Base use case. [Type] is return type, [Params] is input.
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Use case with no parameters.
abstract class UseCaseNoParams<Type> {
  Future<Type> call();
}
