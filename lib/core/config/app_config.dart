import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final String apiUrl = dotenv.env['API_URL'] ?? '';
}
