import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  final String serviceId = 'service_kn26oub'; // EmailJS Service ID
  final String templateId = 'template_61z8r2t'; // EmailJS Template ID
  final String userId = 'KZahLUtMnt1pP_JJI'; // EmailJS User ID (public key)
  final String apiKey =
      'LvXlNw-XWRjpl8b-XnwR4'; // EmailJS Private Key (private)

  Future<void> sendEmail({
    required String ownerName,
    required String username,
    required String password,
    required String email,
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'accessToken': apiKey,
        'template_params': {
          'owner_name': ownerName,
          'username': username,
          'password': password,
          'email': email,
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send email: ${response.body}');
    }
  }
}
