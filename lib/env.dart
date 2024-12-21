import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env') // Annotation pointing to the .env file
class Env {
  @EnviedField(varName: 'BACKEND_URL') // Field maps to a variable in the .env file
  static const String backendUrl = _Env.backendUrl; // References the generated class
}
