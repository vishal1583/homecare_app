import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

    if (password == confirmedpassword) 
    {
      setState(() {
        isLoading = true;
      });

      String url = 'http://$ip/homecare_app/usersignup.php';

      try
      {
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

        if (response.statusCode == 200) 
        {

          var jsonString = jsonDecode(response.body);
          setState(() {
            isLoading = false;
          });

          if (jsonString['message'] == 'success') 
          {

            _emailController.clear();
            _passwordController.clear();
            _confirmedPasswordController.clear();
            _usernameController.clear();
            _phoneController.clear();
            _addressController.clear();

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration Successful')));
          }else
          {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration Failed')));
          }
        }
        else
        {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Server error, please try again later')));
        }
      }catch(e) 
      {
        setState(() {
          isLoading = false; 
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    }else 
    {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords don\'t match')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Form(
          key: _signUpKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 75),
              TextFormField(
                validator: (value) => (value!.isEmpty) ? 'invalid input' : null,
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Enter your E-Mail'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                validator: (value) => (value!.isEmpty) ? 'invalid input' : null,
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Enter your Password :'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                validator: (value) => (value!.isEmpty) ? 'invalid input' : null,
                controller: _confirmedPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Enter your Password again'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                validator: (value) => (value!.isEmpty) ? 'invalid input' : null,
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Enter your Name'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                validator: (value) => (value!.isEmpty) ? 'invalid input' : null,
                controller: _phoneController,
                decoration:
                    const InputDecoration(labelText: 'Enter your Phone number'),
              ),
              const SizedBox(height: 15),
              TextFormField(
                validator: (value) => (value!.isEmpty) ? 'invalid input' : null,
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Enter your Address'),
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
          ),
        ),
      ),
    );
  }
}
