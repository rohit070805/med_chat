import 'dart:io';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final model = GenerativeModel(
    model: 'models/gemini-2.5-flash-image',
    apiKey: dotenv.env['API_KEY']!,
  );

  Future<Map<String, dynamic>> getMedicineDetails(File imageFile) async {
    final prompt = "Analyze this medicine label. Identify the name of the medicine. Then, for the 'dosage_adults', 'dosage_children', and 'side_effects' fields, provide general medical information about this drug. Only use text from the image for the 'name' and 'description' fields. Format the response as a JSON object. If the image is not a clear medicine label, respond with the string 'INVALID_IMAGE' only.";
    final imagePart = DataPart('image/jpeg', await imageFile.readAsBytes());

    final content = [
      Content.multi([
        TextPart(prompt),
        imagePart,
      ]),
    ];

    try {
      final response = await model.generateContent(content);
      final responseText = response.text?.trim() ?? '';

      if (responseText.contains('INVALID_IMAGE')) {
        return {'error': 'The image is not a clear medicine label. Please try again.'};
      }

      // Sometimes the model adds extra characters like ` ` around the JSON, so we trim them
      final cleanJson = responseText.replaceAll('```json', '').replaceAll('```', '').trim();
      final Map<String, dynamic> jsonResponse = jsonDecode(cleanJson);
      return jsonResponse;
    } catch (e) {
      print('API Error: $e');
      return {'error': 'An error occurred while processing the image. Please try again.'};
    }
  }
}