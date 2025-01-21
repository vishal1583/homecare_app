import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_7/ser_provider/sign_up_screen2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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
    setState(() {
      ip = _prefObj?.getString('ip') ?? 'No IP Address';
    });
  }

  // Login function
  Future<void> login() async {
    _prefObj = await SharedPreferences.getInstance();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    String url = 'http://$ip/homecare_app/providerlogin.php';

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

      if (response.statusCode == 200) {
        var jsonString = jsonDecode(response.body);

        if (jsonString['message'] == 'success') {
          print('provider id : ' + jsonString['providerInfo']['id']);
          print('provider name : ' + jsonString['providerInfo']['username']);

          
          SharedPreferences provider = await SharedPreferences.getInstance();
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
          // print(jsonString2);
          // print(jsonString3);
          // print(jsonString4);
          // print(jsonString6);
          // print(jsonString7);
          

          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => DashboardScreen2()),(Route<dynamic> route) => false,);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Successful')));

        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Failed')),);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Server error. Please try again later.')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Provider Login'),
      ),
      body: Form(
        key: _loginKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 50),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator: (value) => (value!.isEmpty) ? 'Please enter your email' : null,
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 13),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              // obscureText: true,
              validator: (value) => (value!.isEmpty) ? 'Please enter your password' : null,
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
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
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen2(),
                        ),
                      );
                    },
                    child: const Text(
                      ' Sign Up',
                      style: TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
