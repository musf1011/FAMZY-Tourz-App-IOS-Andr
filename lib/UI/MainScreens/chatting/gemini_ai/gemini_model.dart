// coded by FAMZY CodeWorks
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAIService {
  // static const String _apiKey =
  //     'AIzaSyBHOVW3Ep7ktM6A6h8jZk08IQ2pBNwRaJg'; //old api key
  static const String _apiKey =
      'AIzaSyBHOVW3Ep7ktM6A6h8jZk08IQ2pBNwRaJg'; //new api key
  late final GenerativeModel _model;

  GeminiAIService() {
    _model = GenerativeModel(
      // model: 'gemini-2.0-flash', //old model
      model: 'gemini-2.5-flash-lite', //one of new model
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7, // shows creativity
      ),
    );
  }

////only one time request send
  // Future<String> generateResponse(String prompt) async {
  //   try {
  //     final response = await _model.generateContent([Content.text(prompt)]);
  //     print('response: ${response.text}');
  //     return response.text ?? "I couldn't generate a response";
  //   } catch (e) {
  //     print('Gemini AI Error: $e');
  //     return "Sorry, I'm having trouble responding right now";
  //   }
  // }

  // retry more than one time if failed for the 1st time
  Future<String> generateResponse(String prompt) async {
    final int maxRetries = 3; //retries
    final Duration delay =
        Duration(seconds: 10); // Wait 10 seconds before retrying

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final response = await _model.generateContent([Content.text(prompt)]);
        return response.text ?? "I couldn't generate a response";
      } catch (e) {
        // Check for the Quota Exceeded or the Rate Limit error message
        if (e.toString().contains('Quota exceeded') &&
            attempt < maxRetries - 1) {
          print(
              'Retrying in ${delay.inSeconds} seconds (Attempt ${attempt + 1}/$maxRetries)...');
          await Future.delayed(delay); // Wait for the rate limit to reset
          continue; // retry again for API call
        }

        // If there is any error of any kind
        return "Sorry, I'm having trouble responding right now";
      }
    }
    return "Sorry, I'm having trouble responding right now"; // Fallback after all retries fail
  }
}
