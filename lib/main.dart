import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert'; // Import for JSON decoding

void main() {
  runApp(TranslationApp());
}

class TranslationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Text Translation',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TranslationHome(),
    );
  }
}

class TranslationHome extends StatefulWidget {
  @override
  _TranslationHomeState createState() => _TranslationHomeState();
}

class _TranslationHomeState extends State<TranslationHome> {
  String _inputText = ''; // Text typed by the user
  String _translatedText = ''; // Translated text
  String _selectedLanguage = 'es'; // Default to Spanish

  // List of languages (code, name)
  final List<Map<String, String>> _languages = [
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
    {'code': 'it', 'name': 'Italian'},
    {'code': 'zh', 'name': 'Chinese (Simplified)'},
    {'code': 'en', 'name': 'English'},
  ];

  // Function to handle translation using Google Translate API
  Future<void> translateText() async {
    final response = await http.post(
      Uri.parse('https://translation.googleapis.com/language/translate/v2?key=API_KEY'), // Replace with your actual API key
      body: {
        'q': _inputText,
        'target': _selectedLanguage,
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _translatedText = data['data']['translations'][0]['translatedText'];
      });
    } else {
      throw Exception('Failed to translate');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Translator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text Field for Input
            TextField(
              onChanged: (value) {
                _inputText = value;
              },
              decoration: InputDecoration(
                labelText: 'Enter text',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            
            // Dropdown for Language Selection
            DropdownButton<String>(
              value: _selectedLanguage,
              icon: Icon(Icons.arrow_downward),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
              items: _languages.map<DropdownMenuItem<String>>((Map<String, String> language) {
                return DropdownMenuItem<String>(
                  value: language['code'],
                  child: Text(language['name']!),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Translate Button
            ElevatedButton(
              onPressed: translateText, // Call the translateText function here
              child: Text('Translate'),
            ),

            SizedBox(height: 24),

            // Display Translated Text
            Text(
              'Translated Text:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _translatedText,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
