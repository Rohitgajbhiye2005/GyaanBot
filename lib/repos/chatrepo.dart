import 'package:dio/dio.dart';
import 'package:gyaanbot/model/chatmodel.dart';

class ChatRepo {

  static const String _apiKey = 'YOUR_API_KEY'; 
  
  static final Dio _dio = Dio();

  static Future<String?> chatTextGenerationRepo(List<Chatmodel> messages) async {
  
    const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
    const String model = 'gemini-1.5-flash';
    
    try {
      if (messages.isEmpty || messages.any((m) => m.role != 'user' && m.role != 'model')) {
        throw Exception('Invalid message format');
      }

      final response = await _dio.post(
        '$baseUrl/$model:generateContent',
        queryParameters: {'key': _apiKey},
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
