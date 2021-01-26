class Endpoint {
  static String baseUrl = 'https://tell-me-everything.herokuapp.com';

  static String getAuth() {
    return "$baseUrl/authentication";
  }
}
