import 'package:dio/dio.dart';
import 'package:gyaanbot/model/chatmodel.dart';

class ChatRepo {
  // Replace with your actual API key
  static const String _apiKey = 'AIzaSyB6dkwGn0ojUDXuQUORu5qDxruBUEhxHC0'; // Get from https://aistudio.google.com/app/apikey
  
  static final Dio _dio = Dio();

  static Future<String?> chatTextGenerationRepo(List<Chatmodel> messages) async {
    // Use the correct endpoint for Gemini 1.5 Flash (current recommended model)
    const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
    const String model = 'gemini-1.5-flash'; // Updated model name
    
    try {
      // Validate messages
      if (messages.isEmpty || messages.any((m) => m.role != 'user' && m.role != 'model')) {
        throw Exception('Invalid message format');
      }

      final response = await _dio.post(
        '$baseUrl/$model:generateContent',
        queryParameters: {'key': _apiKey}, // Pass key as query parameter
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: {
          'contents': messages.map((msg) => msg.toMap()).toList(),
          'generationConfig': {
            'temperature': 0.7,
            'topK': 1,
            'topP': 1.0,
            'maxOutputTokens': 1000,
          },
          'safetySettings': [
            {
              'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
              'threshold': 'BLOCK_ONLY_HIGH'
            }
          ]
        },
      );

      // Parse response
      final text = response.data['candidates']?[0]['content']?['parts']?[0]['text'];
      return text?.toString();
      
    } on DioException catch (e) {
      print('❌ Gemini API Error: ${e.response?.data ?? e.message}');
      return null;
    } catch (e) {
      print('❌ Unexpected error: $e');
      return null;
    }
  }
}