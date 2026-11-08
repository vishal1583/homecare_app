import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_7/extensions/build_context_extension.dart';
import 'package:flutter_application_7/ser_provider/sign_up_screen2.dart';
import 'package:flutter_application_7/services/api_config.dart';
import 'package:flutter_application_7/utils/form_validators.dart';
import 'package:flutter_application_7/widgets/app_form_page.dart';
import 'package:flutter_application_7/widgets/password_field.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen2.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final _loginKey = GlobalKey<FormState>();
  SharedPreferences? _prefObj;
  String ip = '';
  bool isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  // Load the IP address
  Future<void> loadPref() async {
    _prefObj = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      ip = _prefObj?.getString('ip') ?? 'No IP Address';
    });
  }

  // Login function
  Future<void> login() async {
    _prefObj = await SharedPreferences.getInstance();
    if (!mounted) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final url = ApiConfig.endpoint(ip, 'providerlogin.php');

    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
          'password': password,
        },
      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        var jsonString = jsonDecode(response.body);

        if (jsonString['message'] == 'success') {
          debugPrint(
              'Provider login succeeded: ${jsonString['providerInfo']['id']}');
          debugPrint(
              'Provider name: ${jsonString['providerInfo']['username']}');

          SharedPreferences provider = await SharedPreferences.getInstance();
          if (!mounted) return;
          var jsonString2 = jsonString['providerInfo']['id'];
          provider.setString('providerid', jsonString2);
          var jsonString3 = jsonString['providerInfo']['username'];
          provider.setString('providername', jsonString3);
          var jsonString4 = jsonString['providerInfo']['email'];
          provider.setString('provideremail', jsonString4);
          var jsonString5 = jsonString['providerInfo']['phone_no'];
          provider.setString('providerphoneno', jsonString5);
          var jsonString6 = jsonString['providerInfo']['location'];
          provider.setString('providerlocation', jsonString6);
          var jsonString7 = jsonString['providerInfo']['skills'];
          provider.setString('providerskills', jsonString7);

          context.navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const DashboardScreen2()),
            (Route<dynamic> route) => false,
          );
          context.scaffoldMessenger
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Login Successful')));
        } else {
          context.scaffoldMessenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Login Failed')),
            );
        }
      } else {
        context.scaffoldMessenger
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(
              content: Text('Server error. Please try again later.')));
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint('Provider login failed: $e');
      context.scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormPage(
      title: 'Service Provider Login',
      heading: 'Good work starts here.',
      description: 'Sign in to manage requests and your next job.',
      icon: Icons.handyman_outlined,
      formKey: _loginKey,
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          validator: FormValidators.required('Please enter your email'),
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
            validator: FormValidators.required('Please enter your password')),
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
                  builder: (context) => const SignUpScreen2())),
              child: const Text('Create an account'),
            ),
          ],
        ),
      ],
    );
  }
}
