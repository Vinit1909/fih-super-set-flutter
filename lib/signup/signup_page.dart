// lib/signup/signup_page.dart
import 'dart:convert'; // Add this import
import 'package:flutter/material.dart';
import 'package:myapp/common/translator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myapp/gallery/gallery_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedLanguageCode;
  Map<String, String> _languageMap = {};

  @override
  void initState() {
    super.initState();
    loadLanguages();
  }

  void loadLanguages() async {
    final jsonString =
        await rootBundle.loadString('assets/language_options.json');
    final jsonResponse = jsonDecode(jsonString) as Map<String, dynamic>;
    List<dynamic> languages = jsonResponse['languages'];

    setState(() {
      _languageMap = {for (var lang in languages) lang['code']: lang['name']};
    });
  }

  void navigateToGallery() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GalleryPage()),
    );
  }

  Future<void> completeSignup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', _emailController.text);
    await prefs.setString('user_password', _passwordController.text);
    await prefs.setString('user_age', _ageController.text);
    await prefs.setString('selectedLanguage', _selectedLanguageCode ?? 'EN');

    // Proceed to the gallery page
    navigateToGallery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup Page')),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: Translator.translate('email'),
                      border: OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: Translator.translate('password'),
                      border: OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: Translator.translate('age'),
                      border: OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.cake),
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedLanguageCode,
                    decoration: InputDecoration(
                      labelText: Translator.translate('select_language'),
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguageCode = newValue;
                      });
                    },
                    items: _languageMap.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: completeSignup,
                    child: Text(Translator.translate('sign_up')),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
