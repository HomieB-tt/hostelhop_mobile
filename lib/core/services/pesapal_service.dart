import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;

class PesaPalService {
  final String _consumerKey = dotenv.get('PESAPAL_CONSUMER_KEY', fallback: '');
  final String _consumerSecret = dotenv.get('PESAPAL_CONSUMER_SECRET', fallback: '');
  final String _baseUrl = dotenv.get('PESAPAL_API_URL', fallback: 'https://cybqa.pesapal.com/pesapalv3/api');

  PesaPalService();

  Future<String?> getAccessToken() async {
    final url = '$_baseUrl/Auth/RequestToken';
    final body = {
      'consumer_key': _consumerKey,
      'consumer_secret': _consumerSecret,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['token'] as String?;
      }
    } catch (e) {
      developer.log('PesaPal Auth Error: $e');
    }
    return null;
  }

  Future<String?> registerIpn(String token, String ipnUrl) async {
    final url = '$_baseUrl/URLSetup/RegisterIPN';
    final body = {
      'url': ipnUrl,
      'ipn_notification_type': 'GET',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['ipn_id'] as String?;
      }
    } catch (e) {
      developer.log('PesaPal IPN Error: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> submitOrder({
    required String token,
    required String ipnId,
    required String orderId,
    required double amount,
    required String description,
    required String email,
    required String phoneNumber,
    required String firstName,
    required String lastName,
  }) async {
    final url = '$_baseUrl/Transactions/SubmitOrderRequest';
    final body = {
      'id': orderId,
      'currency': 'UGX',
      'amount': amount,
      'description': description,
      'callback_url': 'https://hostelhop.ug/callback',
      'notification_id': ipnId,
      'billing_address': {
        'email_address': email,
        'phone_number': phoneNumber,
        'country_code': 'UG',
        'first_name': firstName,
        'last_name': lastName,
      }
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      developer.log('PesaPal Order Error: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getTransactionStatus(
    String token,
    String orderTrackingId,
  ) async {
    final url = '$_baseUrl/Transactions/GetTransactionStatus?orderTrackingId=$orderTrackingId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      developer.log('PesaPal Status Error: $e');
    }
    return null;
  }
}
