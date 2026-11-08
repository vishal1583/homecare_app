import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/services/api_config.dart';
import 'package:flutter_application_7/utils/form_validators.dart';
import 'package:flutter_application_7/widgets/app_form_page.dart';
import 'package:flutter_application_7/widgets/password_field.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen1 extends StatefulWidget {
  const SignUpScreen1({super.key});

  @override
  State<SignUpScreen1> createState() => _SignUpScreen1State();
}

class _SignUpScreen1State extends State<SignUpScreen1> {
  final _signUpKey = GlobalKey<FormState>();

  SharedPreferences? prefObj;
  String ip = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  // load the IP address
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
  final _addressController = TextEditingController();

  void signUp() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmedpassword = _confirmedPasswordController.text.trim();
    String phoneno = _phoneController.text.trim();
    String address = _addressController.text.trim();

    if (password == confirmedpassword) {
      setState(() {
        isLoading = true;
      });

      final url = ApiConfig.endpoint(ip, 'usersignup.php');

      try {
        var response = await http.post(
          Uri.parse(url),
          body: {
            'username': username,
            'email': email,
            'password': password,
            'phone_no': phoneno,
            'address': address,
          },
        );
        if (!mounted) return;

        if (response.statusCode == 200) {
          var jsonString = jsonDecode(response.body);
          setState(() {
            isLoading = false;
          });

          if (jsonString['message'] == 'success') {
            _emailController.clear();
            _passwordController.clear();
            _confirmedPasswordController.clear();
            _usernameController.clear();
            _phoneController.clear();
            _addressController.clear();

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
        } else {
          setState(() {
            isLoading = false;
          });
          context.scaffoldMessenger
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(
                content: Text('Server error, please try again later')));
        }
      } catch (e) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    } else {
      context.scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Passwords don\'t match')));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmedPasswordController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormPage(
      title: 'User Registration',
      heading: 'Make yourself at home.',
      description:
          'Create your account and connect with local service providers.',
      icon: Icons.person_add_alt_1_outlined,
      formKey: _signUpKey,
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
          controller: _addressController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.location_on_outlined),
              labelText: 'Address'),
        ),
        const SizedBox(height: 30),
        isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (_signUpKey.currentState!.validate()) {
                    signUp();
                  }
                },
                child: const Text('Register'),
              ),
      ],
    );
  }
}
