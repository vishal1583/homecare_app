import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/services/api_config.dart';
import 'package:flutter_application_7/user/dashboard_screen1.dart';
import 'package:flutter_application_7/utils/form_validators.dart';
import 'package:flutter_application_7/widgets/app_form_page.dart';
import 'package:flutter_application_7/widgets/password_field.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'sign_up_screen1.dart';

class LoginScreen1 extends StatefulWidget {
  const LoginScreen1({super.key});

  @override
  State<LoginScreen1> createState() => _LoginScreen1State();
}

class _LoginScreen1State extends State<LoginScreen1> {
  final _loginKey = GlobalKey<FormState>();

  SharedPreferences? prefObj;
  String ip = '';
  bool isLoading = false; // State variable to manage loading state

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  // Load the IP address
  Future<void> loadPref() async {
    prefObj = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      ip = prefObj?.getString('ip') ?? 'No IP Address';
    });
  }

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Function to handle user login
  void login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      isLoading = true; // Show loading indicator
    });

    final url = ApiConfig.endpoint(ip, 'userlogin.php');

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
          'password': password,
        },
      );
      if (!mounted) return;

      var jsonString = jsonDecode(response.body);
      var jsonData = jsonString['message'];

      var id = jsonString['userInfo']['id'];
      var userName = jsonString['userInfo']['username'];
      var userEmail = jsonString['userInfo']['email'];
      var userPhone = jsonString['userInfo']['phone_no'];
      var userAddress = jsonString['userInfo']['address'];

      if (jsonData == 'success') {
        SharedPreferences user = await SharedPreferences.getInstance();
        if (!mounted) return;
        user.setString('userid', id);
        user.setString('username', userName);
        user.setString('useremail', userEmail);
        user.setString('userphone', userPhone);
        user.setString('useraddress', userAddress);

        noLoading();

        context.navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashboardScreen1()),
          (route) => false,
        );

        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Login Successful')));
      } else {
        noLoading();

        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Login Failed')));
      }
    } catch (e) {
      if (!mounted) return;
      noLoading();

      context.scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void noLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormPage(
      title: 'General User Login',
      heading: 'Welcome home.',
      description: 'Sign in to find the right help for your home.',
      icon: Icons.home_outlined,
      formKey: _loginKey,
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          validator: FormValidators.required('Please enter a valid email'),
          controller: _emailController,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: 'Email address',
              hintText: 'you@example.com'),
        ),
        const SizedBox(height: 8),
        PasswordField(
            controller: _passwordController,
            label: 'Password',
            validator:
                FormValidators.required('Please enter a valid password')),
        const SizedBox(height: 25),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
                onPressed: () {
                  if (_loginKey.currentState!.validate()) {
                    login();
                  }
                },
                child: const Text('Login'),
              ),
        const SizedBox(height: 18),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text('New to Homecare?'),
            TextButton(
              onPressed: () => context.navigator.push(MaterialPageRoute(
                  builder: (context) => const SignUpScreen1())),
              child: const Text('Create an account'),
            ),
          ],
        ),
      ],
    );
  }
}
