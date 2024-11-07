import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String _baseUrl = 'http://brownonions-002-site1.ftempurl.com/api/ChefRegister';
  final int chefId = 3;
  final String apiKey = 'mobileapi19042024';
  final String currentPassword = '123';

  Future<bool> validatePassword() async {
    try {
      final url = Uri.parse(
          '$_baseUrl/ValidateChefPassword?ChefId=$chefId&CurrentPassword=$currentPassword&APIKey=$apiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if 'isAuthorized' is in the response data
        if (data.containsKey('isAuthorized')) {
          return data['isAuthorized'] == true;
        } else {
          throw Exception("Response does not contain 'isAuthorized' key.");
        }
      } else {
        // Log and throw an error if the status code is not 200
        throw Exception('Failed to validate password, status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions and rethrow with additional details
      print('Error in validatePassword: $e');
      throw Exception('Error in validatePassword: $e');
    }
  }
}
