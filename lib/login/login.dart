// lib/login/login.dart
import 'dart:convert'; // Add this import for jsonDecode
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import for rootBundle
import 'package:myapp/common/translator.dart';
import 'package:myapp/gallery/gallery_page.dart'; // Updated import
import 'package:myapp/signup/signup_page.dart'; // Ensure this import is present

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  bool _showLoginForm = false;
  String? _selectedLanguageCode;
  Map<String, String> _languageMap = {};

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Set'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/superset-logo.png',
                    height: 200, // Increased the height
                  ),
                  const SizedBox(height: 20),
                  if (!_showLoginForm && _languageMap.isNotEmpty) ...[
                    DropdownButtonFormField<String>(
                      value: _selectedLanguageCode,
                      decoration: InputDecoration(
                        labelText: Translator.translate('select_language'),
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      onChanged: (String? newValue) async {
                        if (newValue != null) {
                          await Translator.setCurrentLanguage(newValue);
                          setState(() {
                            _selectedLanguageCode = newValue;
                          });
                        }
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
                      onPressed: () {
                        setState(() {
                          _showLoginForm = true;
                        });
                      },
                      child: Text(Translator.translate('continue_to_login')),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                  if (_showLoginForm) ...[
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
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: Translator.translate('password'),
                        border: OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                // Bypass authentication and navigate to GalleryPage
                                navigateToGallery();
                              },
                              child: Text(Translator.translate('login')),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupPage()),
                              );
                            },
                            child: Text(Translator.translate('sign_up')),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {},
                      child: Text(Translator.translate('forgot_password')),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
