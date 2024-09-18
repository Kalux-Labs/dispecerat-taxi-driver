import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY')
  static const String googleMapsAPIKey = _Env.googleMapsAPIKey;
}
