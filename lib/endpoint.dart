class Endpoint {
  static String baseUrl = 'tell-me-everything.herokuapp.com';

  static Uri getAuth() {
    return Uri.https(baseUrl, "authentication");
  }
}
