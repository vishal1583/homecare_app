/// Builds URLs for the configured Homecare server.
class ApiConfig {
  ApiConfig._();

  static String endpoint(String ipAddress, String path) =>
      'http://$ipAddress/homecare_app/$path';
}
