import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen2 extends StatefulWidget {
  const SignUpScreen2({super.key});

  @override
  State<SignUpScreen2> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen2> {
  final _signUpKey = GlobalKey<FormState>();

  SharedPreferences? prefObj;

  String ip = '';
  bool isLoading = false; // To track loading state

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  Future<void> loadPref() async {
    prefObj = await SharedPreferences.getInstance();
    setState(() {
      ip = prefObj?.getString('ip') ?? 'No IP Address';
    });
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmedPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _skillsController = TextEditingController();

  void signUp() async {
    setState(() {
      isLoading = true; // Start loading
    });

    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmedpassword = _confirmedPasswordController.text.trim();
    String phoneno = _phoneController.text.trim();
    String location = _locationController.text.trim();
    String skills = _skillsController.text.trim();

    if (password == confirmedpassword) 
    {
      String url = 'http://$ip/homecare_app/providersignup.php';

      try {
        var response = await http.post(
          Uri.parse(url),
          body: {
            'username': username,
            'email': email,
            'password': password,
            'phone_no': phoneno,
            'location': location,
            'skills': skills,
          },
        );

        var jsonString = jsonDecode(response.body);
        if (jsonString['message'] == 'success') {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration Successful')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration Failed')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } else 
    {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password doesn\'t match')));
    }

    setState(() {
      isLoading = false; // Stop loading
    });
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmedPasswordController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _skillsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Provider Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Form(
          key: _signUpKey,
          child: isLoading
              ? const Center(child: CircularProgressIndicator()) // Show loader when isLoading is true
              : Column(
                  children: [
                    const SizedBox(height: 75),
                    TextFormField(
                      validator: (value) =>
                          (value!.isEmpty) ? 'invalid input' : null,
                      controller: _emailController,
                      decoration:
                          const InputDecoration(labelText: 'Enter your E-Mail'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) =>
                          (value!.isEmpty) ? 'invalid input' : null,
                      controller: _passwordController,
                      decoration:
                          const InputDecoration(labelText: 'Enter your Password :'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) =>
                          (value!.isEmpty) ? 'invalid input' : null,
                      controller: _confirmedPasswordController,
                      decoration: const InputDecoration(
                          labelText: 'Enter your Password again'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) =>
                          (value!.isEmpty) ? 'invalid input' : null,
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Enter your Name'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) =>
                          (value!.isEmpty) ? 'invalid input' : null,
                      controller: _phoneController,
                      decoration:
                          const InputDecoration(labelText: 'Enter your Phone number'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) =>
                          (value!.isEmpty) ? 'invalid input' : null,
                      controller: _skillsController,
                      decoration:
                          const InputDecoration(labelText: 'Enter your Skills'),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      validator: (value) =>
                          (value!.isEmpty) ? 'invalid input' : null,
                      controller: _locationController,
                      decoration:
                          const InputDecoration(labelText: 'Enter your Address'),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (_signUpKey.currentState!.validate()) {
                          signUp();
                        }
                      },
                      child: const Text('Register'),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
