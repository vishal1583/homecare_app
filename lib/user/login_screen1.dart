import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_7/user/dashboard_screen1.dart';
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

    String url = 'http://$ip/homecare_app/userlogin.php';

    try 
    {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
          'password': password,
        },
      );

      var jsonString = jsonDecode(response.body);
      var jsonData = jsonString['message'];

      var id = jsonString['userInfo']['id'];
      var userName = jsonString['userInfo']['username'];
      var userEmail = jsonString['userInfo']['email'];
      var userPhone = jsonString['userInfo']['phone_no'];
      var userAddress = jsonString['userInfo']['address'];

      if (jsonData == 'success') 
      {
        SharedPreferences user = await SharedPreferences.getInstance();
        user.setString('userid', id);
        user.setString('username', userName);
        user.setString('useremail', userEmail);
        user.setString('userphone', userPhone);
        user.setString('useraddress', userAddress);

        noLoading();

        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => const DashboardScreen1()),(route)=> false,);
        
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Successful')));

      }else
      {
        noLoading();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Failed')));
      }
    }catch(e) 
    {
      noLoading();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('General User Login'),
      ),
      body: Form(
        key: _loginKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 50),
            TextFormField(
              validator: (value) =>
                  (value!.isEmpty) ? 'Please enter a valid email' : null,
              controller: _emailController,
              
              decoration: const InputDecoration(labelText: 'E-mail', helperText: ''),
            ),
            const SizedBox(height: 8),
            TextFormField(
              validator: (value) =>
                  (value!.isEmpty) ? 'Please enter a valid password' : null,
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password', helperText: ''),
            ),
            const SizedBox(height: 25),
            isLoading
            ? const Center(child: CircularProgressIndicator())            // if(isLoading == true)
            : ElevatedButton(                                             // else
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
                        MaterialPageRoute(builder: (context) {
                          return const SignUpScreen1();
                        }),
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
