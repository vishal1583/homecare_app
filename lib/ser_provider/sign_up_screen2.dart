import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/services/api_config.dart';
import 'package:flutter_application_7/utils/form_validators.dart';
import 'package:flutter_application_7/widgets/app_form_page.dart';
import 'package:flutter_application_7/widgets/password_field.dart';
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
    if (!mounted) return;
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

    if (password == confirmedpassword) {
      final url = ApiConfig.endpoint(ip, 'providersignup.php');

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
        if (!mounted) return;

        var jsonString = jsonDecode(response.body);
        if (jsonString['message'] == 'success') {
          context.navigator.pop();
          context.scaffoldMessenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Registration Successful')));
        } else {
          context.scaffoldMessenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
                const SnackBar(content: Text('Registration Failed')));
        }
      } catch (e) {
        if (!mounted) return;
        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } else {
      context.scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text('Password doesn\'t match')));
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
    return AppFormPage(
      title: 'Service Provider Registration',
      heading: 'Bring your skills home.',
      description:
          'Create a provider account and let customers find your services.',
      icon: Icons.handyman_outlined,
      formKey: _signUpKey,
      isLoading: isLoading,
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          validator: FormValidators.required('invalid input'),
          controller: _emailController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: 'Email address'),
        ),
        const SizedBox(height: 15),
        PasswordField(
            controller: _passwordController,
            label: 'Password',
            validator: FormValidators.required('invalid input')),
        const SizedBox(height: 15),
        PasswordField(
            controller: _confirmedPasswordController,
            label: 'Confirm password',
            validator: FormValidators.required('invalid input')),
        const SizedBox(height: 15),
        TextFormField(
          textInputAction: TextInputAction.next,
          validator: FormValidators.required('invalid input'),
          controller: _usernameController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline_rounded),
              labelText: 'Full name'),
        ),
        const SizedBox(height: 15),
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          validator: FormValidators.required('invalid input'),
          controller: _phoneController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone_outlined),
              labelText: 'Phone number'),
        ),
        const SizedBox(height: 15),
        TextFormField(
          textInputAction: TextInputAction.next,
          validator: FormValidators.required('invalid input'),
          controller: _skillsController,
          decoration: const InputDecoration(labelText: 'Your skills'),
        ),
        const SizedBox(height: 15),
        TextFormField(
          textInputAction: TextInputAction.next,
          validator: FormValidators.required('invalid input'),
          controller: _locationController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.location_on_outlined),
              labelText: 'Service location'),
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
    );
  }
}
