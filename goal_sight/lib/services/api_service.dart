import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Using a free public API for demonstration
  // You can replace this with your own API endpoint
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  // For demo purposes, we'll use a simple endpoint
  // In production, replace with actual football API
  Future<Map<String, dynamic>> fetchMatchData() async {
    try {
      // Using a mock endpoint - replace with actual football API
      final response = await http.get(
        Uri.parse('$baseUrl/posts/1'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Transform the mock data into match-like structure
        // In production, this would be actual match data from your API
        return {
          'id': data['id'],
          'title': data['title'],
          'body': data['body'],
          'userId': data['userId'],
          'fetchedAt': DateTime.now().toIso8601String(),
        };
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Alternative: Fetch from a football API (example structure)
  // Uncomment and modify when you have a real API endpoint
  /*
  Future<Map<String, dynamic>> fetchFootballMatchData() async {
    final response = await http.get(
      Uri.parse('YOUR_FOOTBALL_API_ENDPOINT'),
      headers: {
        'Content-Type': 'application/json',
        // Add API key if needed
        // 'Authorization': 'Bearer YOUR_API_KEY',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load match data');
    }
  }
  */
}

